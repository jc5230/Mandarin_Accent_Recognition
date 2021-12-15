# Jie Chen (jc5230)

from collections import defaultdict

if __name__ == "__main__":
    DIALECT_LABEL_DICT = {'si chuan': 'chuan',
                          'hei long jiang': 'dongbei',
                          'bei jing': 'guan',
                          'zhe jiang': 'wu',
                          'guang xi': 'yue'}
    spkinfo_new = []
    SPK_PROV_DICT = defaultdict()
    with open(f'./dataset/magicdata_small/metadata/SPKINFO.txt', 'r') as infile:
        first_line = True
        for line in infile:
            if not first_line:
                spk_id, _, _, dialect = line.strip().split('\t')
                if dialect in DIALECT_LABEL_DICT:
                    SPK_PROV_DICT[spk_id] = DIALECT_LABEL_DICT[dialect]
                    spkinfo_new.append(spk_id + '\t' + DIALECT_LABEL_DICT[dialect] + '\n')
            first_line = False
    with open(f'./dataset/magicdata_small/metadata/SPKINFO.txt','w') as outfile:
        for line in spkinfo_new:
            outfile.writelines(line)
