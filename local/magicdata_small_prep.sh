. ./path.sh || exit 1;

corpus=$1
data=$2

find $corpus -iname "*.wav" > $tmp_dir/wav.flist

for x in train; do
  grep -i "/$x/" $tmp_dir/wav.flist > $data/$x/wav.flist || exit 1;
  echo "Filtering data using found wav list and provided transcript for $x"
  local/magicdata_data_filter.py $data/$x/wav.flist $corpus/$x/TRANS.txt $data/$x local/magicdata_badlist
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

