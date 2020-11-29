""" CSV_DRIVER
# 统一的 CSV 文档的读写
# VERSION: 0.0.1
# EDITOR:  haiyuan
# TIMER:   2020-06-10

"""

import csv


class CsvDriver:
    def __init__(self):
        pass

    def read():
        with open('eggs.csv', newline='') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=' ', quotechar='|')
            for row in spamreader:
                print(', '.join(row))

    def writer():
        with open('eggs.csv', 'w', newline='') as csvfile:
            spamwriter = csv.writer(csvfile, delimiter=' ',quotechar='|', quoting=csv.QUOTE_MINIMAL)
            spamwriter.writerow(['Spam'] * 5 + ['Baked Beans'])
            spamwriter.writerow(['Spam', 'Lovely Spam', 'Wonderful Spam'])