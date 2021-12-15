# Jie Chen (jc5230)
# Partial ref: Lin Ai

import os
from collections import defaultdict
import sys

if __name__ == "__main__":
   
    MAGICDATA_ROOT = f'{sys.argv[1]}'
    MAGICDATA_ROOT_NEW = f'{sys.argv[2]}'

    DIALECT_LABEL_DICT = {'si chuan': 'chuan',
                          'hei long jiang': 'dongbei',
                          'bei jing': 'guan',
                          'zhe jiang': 'wu',
                          'guang xi': 'yue'}
    spkinfo_new = []
    SPK_PROV_DICT = defaultdict()
    with open(f'{MAGICDATA_ROOT}/metadata/SPKINFO.txt', 'r') as infile:
        first_line = True
        for line in infile:
            if first_line:
                spkinfo_new.append(line)
            if not first_line:
                spk_id, _, _, dialect = line.strip().split('\t')
                if dialect in DIALECT_LABEL_DICT:
                    SPK_PROV_DICT[spk_id] = DIALECT_LABEL_DICT[dialect]
                    spkinfo_new.append(line)
            first_line = False

    all_spk_list = [x for x in os.listdir(MAGICDATA_ROOT+'/train')]
    spk_list = SPK_PROV_DICT.keys()

    with open(f'{MAGICDATA_ROOT_NEW}/metadata/SPKINFO.txt','w') as outfile:
        for line in spkinfo_new:
            outfile.writelines(line)

    #print(SPK_PROV_DICT.keys())
