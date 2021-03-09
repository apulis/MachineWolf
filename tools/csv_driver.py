"""
# ScriptType：support tools 
# UpdateDate: 2021.03-4
# Matainer: thomas
# Env: Win10 64bit, python3.8
 """
import csv
import re

def csv_reader_as_json(csf_path="",length=100):
    output = []
    num = 0
    with open(csf_path, newline='',encoding='utf-8') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        for row in spamreader:
            num += 1
            if num <= length:
                account = re.split('([\t])', row[0] )  
                output.append({"account":account[0],"passwd":account[2],"md5pwd":account[4],})
    return output


def csv_writer():
    pass


if __name__ == "__main__":
    csf_path = r"users.csv"
    csv_reader_as_json(csf_path,10)
