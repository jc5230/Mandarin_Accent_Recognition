# Jie Chen (jc5230)
#-- coding: utf-8 --
import sys
import io  
from collections import defaultdict
from importlib import reload

reload(sys)
#sys.setdefaultencoding('utf-8')

if __name__ == "__main__":
    trans = []
    trans_new = []
    spkinfo = {}
    with open(f'./dataset/magicdata_small/metadata/SPKINFO.txt','r', encoding="utf-8") as infile:
        for line in infile:
            spk_id, dialect = line.strip().split('\t')
            spkinfo[spk_id] = dialect

    with open(f'./dataset/magicdata/train/TRANS.txt', 'rb') as infile:
        for line in infile.readlines():
            print(line.decode('ascii'))
    with open(f'./dataset/magicdata_small/train/TRANS.txt','w') as outfile:
        for line in trans_new:
            outfile.writelines(line)


