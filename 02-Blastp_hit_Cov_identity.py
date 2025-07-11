print('This script is written for extracting filtering BLASTP hits based on similarity and coverage (self length)!')

import os
import sys
from Bio import SeqIO

while True:
    Parameters = input("Enter parameters 1.[blast_result.txt], 2.[ORF_fasta], 3.[similarity(0-100)] and 4.[length_coverage(0-100)] (default: 0) separated by Space: ")
    try:
        X1 = Parameters.strip().split(' ')[0]
        X2 = Parameters.strip().split(' ')[1]
        X3 = float(Parameters.strip().split(' ')[2])
        X4 = float(Parameters.strip().split(' ')[3])
        break
    except Exception as e:
        print('Errors: invalid input format or not enough input!')
        continue

f = open(f"{X1}_{X3}_{X4}.blast", 'w')
a = {}
for record in SeqIO.parse(X2, 'fasta'):
    a[str(record.id).strip()] = len(str(record.seq))

j = 0
for line in open(X1, 'r'):
    lis = line.split('\t')
    try:
        if float(lis[2]) >= X3 and ((float(lis[3]) * 100) / a[lis[0]]) >= X4:
            j += 1
            f.write(line)
    except KeyError:
        print(f"Error processing line: {line.strip()}")
        continue

print(f'{j} BLASTP hits were extracted based on the criteria of similarity >= {X3}% and coverage >= {X4}%.')
print('OK, Finished!')
print('Good')
input('Press <Enter> to close this window!')

