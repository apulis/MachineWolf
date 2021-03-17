"""
# ScriptType：support tools 
# UpdateDate: 2021.03-10
# Matainer: thomas
# Env: Win10 64bit, python3.8
 """
import csv
import re

def csv_reader_as_string(csv_path="",length=10):
    output = []
    num = 0
    with open(csv_path, newline='',encoding='utf-8') as csvfile:
        spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
        for row in spamreader:
            account = re.split('([\t])', row[0] )  
            output.append({"account":account[0],"passwd":account[2],"md5pwd":account[4],})
            num += 1
            if (length > 0) and (num >= length): 
                return output
    return  output

def csv_string_writer(csv_path="",datas=""):
    with open(csv_path, 'w', newline='') as csvfile: 
        spamwriter  = csv.writer(csvfile, 
                                newline='',
                                delimiter=' ',
                                quotechar='|', 
                                quoting=csv.QUOTE_MINIMAL) 
        for Spam in datas:
            spamwriter.writerow(Spam)
    return True

def csv_reader_as_json(csv_path="",length=0):
    output = []
    num = 0
    with open(csv_path, newline='',encoding='utf-8') as csvfile:
        reader = csv.DictReader(csvfile)
        for row in reader:
            output.append(row)
            num += 1
            if (length > 0) and (num >= length): 
                return output
    return  output

def csv_json_writer(csv_path="",datas={}):
    if not datas:
       return 0
    with open(csv_path, 'w', newline='') as csvfile: 
        fieldnames = list(datas[0].keys())
        dicWriter  = csv.DictWriter(csvfile, fieldnames=fieldnames)
        dicWriter.writeheader()
        for dics in datas:
            dicWriter.writerow(dics)
        return True

if __name__ == "__main__":
    csv_path = r"datasetshub/users_w.csv"
    account = csv_reader_as_string(r"datasetshub/users.csv", 0)
    csv_json_writer(csv_path=r"datasetshub/users_w.csv",datas=account)

