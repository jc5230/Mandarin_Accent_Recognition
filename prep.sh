#!/usr/bin/env bash
# Jie Chen (jc5230)

. ./cmd.sh
. ./path.sh


dbase=`pwd`/dataset
magicdata_small=`pwd`/dataset/magicdata_small
stage=5

if [ $stage -le 0 ]; then
  dbase_small=$db3ase/magicdata_small
  mkdir -p $dbase_small
  mkdir -p $dbase_small/metadata
  python3 magicdata_subset.py ./dataset/magicdata ./dataset/magicdata_small
fi

if [ $stage -le 1 ]; then
  spk_id_list=`cat $dbase/magicdata_small/metadata/SPKINFO.txt | sed '1d' | awk '{print $1}'`
  wavfolder=$dbase/magicdata/train
  wavfolder_new=$dbase/magicdata_small/train
  mkdir -p $wavfolder_new
  for spk_id in $spk_id_list; do
    cp -R -u -p "$wavfolder/$spk_id" "$wavfolder_new"
  done
fi

if [ $stage -le 2 ]; then
  python3 revise_metadata_spkinfo.py
fi

if [ $stage -le 3 ]; then
  mkdir -p $magicdata_small/train/chuan
  mkdir -p $magicdata_small/train/dongbei
  mkdir -p $magicdata_small/train/guan
  mkdir -p $magicdata_small/train/wu
  mkdir -p $magicdata_small/train/yue

  wavfolder_new=$dbase/magicdata_small/train

  echo "Reorganizing wavs"
  cat $dbase/magicdata_small/metadata/SPKINFO.txt | while read id prov
  do
    mv $wavfolder_new/$id/* $wavfolder_new/$prov
  done


fi

if [ $stage -le 4 ]; then
  wavfolder_new=$dbase/magicdata_small/train
  cat $dbase/magicdata_small/metadata/SPKINFO.txt | while read id prov
  do
    rmdir $wavfolder_new/$id
  done
fi

if [ $stage -le 5 ]; then
  python3 revise_train_trans.py
fi

