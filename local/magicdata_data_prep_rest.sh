#!/usr/bin/env bash

# Copyright 2019 Xingyu Na
# Apache 2.0

# Modified by Jie Chen (jc5230)
# Prepare transcipts


. ./path.sh || exit 1;

if [ $# != 2 ]; then
  echo "Usage: $0 <corpus-path> <data-path>"
  echo " $0 /export/a05/xna/data/magicdata data/magicdata"
  exit 1;
fi

corpus=$1
data=$2

if [ ! -d $corpus/train ] || [ ! -d $corpus/dev ] || [ ! -d $corpus/test ]; then
  echo "Error: $0 requires complete corpus"
  exit 1;
fi
  

for x in train dev test; do
  echo "Filtering data using found wav list and provided transcript for $x"
  echo "[MODIFY: corpus/train/TRANS.txt]"
  local/magicdata_data_filter.py $data/$x/wav.flist $corpus/train/TRANS.txt $data/$x local/magicdata_badlist
  cat $data/$x/transcripts.txt |\
    sed 's/！//g' | sed 's/？//g' |\
    sed 's/，//g' | sed 's/－//g' |\
    sed 's/：//g' | sed 's/；//g' |\
    sed 's/　//g' | sed 's/。//g' |\
    local/word_segment.py |\
    tr '[a-z]' '[A-Z]' |\
    sed 's/FIL/[FIL]/g' | sed 's/SPK/[SPK]/' |\
    awk '{if (NF > 1) print $0;}' > $data/$x/text
  for file in wav.scp utt2spk text; do
    sort $data/$x/$file -o $data/$x/$file
  done
  utils/utt2spk_to_spk2utt.pl $data/$x/utt2spk > $data/$x/spk2utt
done

utils/data/validate_data_dir.sh --no-feats $data/train || exit 1;
utils/data/validate_data_dir.sh --no-feats $data/dev || exit 1;
utils/data/validate_data_dir.sh --no-feats $data/test || exit 1;
