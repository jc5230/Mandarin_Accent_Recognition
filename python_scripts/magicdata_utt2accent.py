# Jie Chen (jc5230)
# Modified on Lin Ai's scripts

import os
from collections import defaultdict

MAGICDATA_ROOT = f'./dataset/magicdata'
DATA_ROOT = f'./data'

DIALECT_LABEL_DICT = {'bei jing': 'guan', 'tian jin': 'guan', 'he bei': 'guan',
                      'zhe jiang': 'wu', 'shang hai': 'wu', 'jiang su': 'wu',
                      'guang dong': 'yue', 'guang xi': 'yue',
                      'chong qing': 'chuan', 'si chuan': 'chuan',
                      'ji lin': 'dongbei', 'liao ning': 'dongbei', 'hei long jiang': 'dongbei'}

LABEL_DIALECT_DICT = {'guan': ['bei jing', 'tian jin', 'he bei'],
                      'wu': ['zhe jiang', 'shang hai', 'jiang su'],
                      'yue': ['guang dong', 'guang xi'],
                      'chuan': ['chong qing', 'si chuan'],
                      'dongbei': ['ji lin', 'liao ning', 'hei long jiang']}

SPK_PROV_DICT = defaultdict()
with open(f'{MAGICDATA_ROOT}/metadata/SPKINFO.txt', 'r') as infile:
    first_line = True
    for line in infile:
        if not first_line:
            spk_id, _, _, dialect = line.strip().split('\t')
            if dialect in DIALECT_LABEL_DICT:
                SPK_PROV_DICT[spk_id] = dialect
        first_line = False

def 


