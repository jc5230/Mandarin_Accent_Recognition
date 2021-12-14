#!/usr/bin/env bash

# Jie Chen (jc5230)
# Ref: multi_cn/s5/run.sh, hkust/s5/run.sh

. ./cmd.sh
. ./path.sh

stage=8
dbase=`pwd`/dataset

magicdata_url=www.openslr.org/resources/68

if [ $stage -le 0 ]; then
  # download magicdata
  local/magicdata_download_and_untar.sh $dbase/magicdata $magicdata_url train_set || exit 1;
  local/magicdata_download_and_untar.sh $dbase/magicdata $magicdata_url dev_set || exit 1;
  local/magicdata_download_and_untar.sh $dbase/magicdata $magicdata_url test_set || exit 1;
  local/magicdata_download_and_untar.sh $dbase/magicdata $magicdata_url metadata || exit 1;
fi

if [ $stage -le 8 ]; then
  # Reorganize magicdata metadata
  # local/make_metadata_folder.sh ./dataset/magicdata || exit 1;

  # slice and prepare data for subset
  #autopep8 -i python_scripts/prepare_magicdata_data.py
  #python3 python_scripts/prepare_magicdata_data.py

  local/magicdata_data_prep.sh $dbase/magicdata data
fi

if [ $stage -le 2 ]; then
  # normalize transcripts
  local/prepare_dict.sh || exit 1;
fi

if [ $stage -le 3 ]; then
  # Phone Sets, questions, L compilation
  local/train_lms.sh
fi

if [ $stage -le 4 ]; then
 # prepare LM
 echo "$0: L compilation preparation"
 utils/prepare_lang.sh data/local/dict "<UNK>" data/local/lang data/lang || exit 1;
 echo "$0: G compilation, check LG composition"
 utils/format_lm.sh data/lang data/local/lm/3gram-mincount/lm_unpruned.gz \
    data/local/dict/lexicon.txt data/lang || exit 1;
fi

if [ $stage -le 5 ]; then
  echo "$0: MFCC & pitch extraction"
  # make MFCC plus pitch
  mfccdir=mfcc
  for x in train dev; do
    steps/make_mfcc_pitch_online.sh --cmd "run.pl --mem 8G" --nj 10 data/magicdata/$x exp/make_mfcc/magicdata/$x $mfccdir || exit 1;
    steps/compute_cmvn_stats.sh data/magicdata/$x exp/make_mfcc/magicdata/$x $mfccdir || exit 1;
  done

  # Remoce small number of utterances that couldn't be extracted
  utils/fix_data_dir.sh data/magicdata/train || exit 1;
  utils/subset_data_dir.sh --first data/magicdata/train 100000 data/train_100k || exit 1;
fi

if [ $stage -le 6 ]; then
  echo "$0: monophone training & alignment"
  steps/train_mono.sh --cmd "$train_cmd" --nj 20 \
  data/magicdata/train data/lang exp/mono0a || exit 1;
  # Monophone decoding
  utils/mkgraph.sh data/lang_test exp/mono0a exp/mono0a/graph || exit 1
  steps/decode.sh --cmd "$decode_cmd" --config conf/decode.config --nj 20 \
    exp/mono0a/graph data/magicdata/dev exp/mono0a/decode

  # Get alignments from monophone system.
  steps/align_si.sh --cmd "$train_cmd" --nj 20 \
    data/magicdata/train data/lang exp/mono0a exp/mono_ali || exit 1;
fi


exit 0;