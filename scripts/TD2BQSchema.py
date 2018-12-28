#!/usr/bin/python
# _*_ coding: utf-8 _*_
# This script converts teradata table schema to BQ schema
# Script is written in python2 and does not support python3

import os
import sys
import json
import subprocess

globalVars = {
    }

if __name__ == "__main__":
    if len(sys.argv) <> 3 :
        exit()

    for line in open('../config/config.txt', 'r'):
        fields = line.strip().split('|')
        globalVars[fields[0]]=fields[1]

    globalVars["<DatabaseName>"]=sys.argv[1]
    globalVars["<TableName>"]=sys.argv[2]
    globalVars["<TDTableMetadataFile>"]='\'../output/'+ sys.argv[1] + '_' + sys.argv[2] + '_Metadata.txt\''
    print(globalVars)

    bteq= '../temp/'+ \
        globalVars["<DatabaseName>"]+ '_' + \
        globalVars["<TableName>"]+ '_' +\
        'tdextractmetadata.sql'

    temptdextractmetadata = open(bteq, 'w')
    for line in open('../config/tdextractmetadata.sql', 'r'):
        for key in globalVars:
            line=line.replace(key,globalVars[key])
        temptdextractmetadata.write(line)
    temptdextractmetadata.close()

    print(bteq)

    subprocess.call('bteq < '+ bteq + '>/dev/null 2>../logs/error.txt', shell=True)


    data = {}
    data['']=[]
    with open(globalVars["<TDTableMetadataFile>"].strip('\''),'r') as f:
        for _ in range(2):
            next(f)
        for line in f:
            column = line.strip().split('|')
            print(line)
            data[''].append({
            "description":column[3],
            "mode":column[2],
            "name":column[0],
            "type":column[1]
            })

    with open('data.txt', 'w') as outfile:
        json.dump(data, outfile)

    os.remove(globalVars["<TDTableMetadataFile>"].strip('\''))
