# Generate wav list (flist) from magicdata subset
# Jie Chen jc5230

DATA_ROOT = f'./data'
for fname in ['train', 'dev', 'test']:
    wavlist = []
    with open(f'{DATA_ROOT}/{fname}/wav.scp', 'r') as infile:
        for line in infile:
            _, wavname = line.split()
            wavlist.append(wavname)
    with open(f'{DATA_ROOT}/{fname}/wav.flist', 'w') as outfile:
        for item in wavlist:
            outfile.writelines(f'{item}\n')


