#!/usr/bin/env bash

# Jie Chen (jc5230)

. ./cmd.sh
. ./path.sh

stage=1
dbase=`pwd`/dataset

magicdata_url=www.openslr.org/resources/68

if [ $stage -eq 0 ]; then
  # download magicdata
  local/magicdata_download_and_untar.sh $dbase/magicdata $magicdata_url train_set || exit 1;
  local/magicdata_download_and_untar.sh $dbase/magicdata $magicdata_url dev_set || exit 1;
  local/magicdata_download_and_untar.sh $dbase/magicdata $magicdata_url test_set || exit 1;
fi

if [ $stage -eq 1 ]; then
   local/magicdata_data_prep.sh $dbase/magicdata data/magicdata || exit 1;
fi

exit 0;
