
# -*- coding: utf-8 -*-
""" FAKE_USER
# INFO:    导入swagger接口数据
# VERSION: 2.0
# EDITOR:  thomas
# TIMER:   2021-03-20
"""

import requests
import json

SWAGGER_SITE = "http://192.168.1.185:8018/swagger/doc.json"
API_JSON = []
JSON_COUNT = 14

def  get_swagger_datas(api_file=SWAGGER_SITE):
    global API_JSON
    with requests.get(api_file) as resp:
        apis = resp.text.splitlines()
        num = 0
        for i in resp.text.splitlines():
            num += 1
            if (num <= 10) and (num > 1):
                continue
            API_JSON.append(i)
        API_JSON = json.loads("".join(API_JSON))
    return API_JSON["paths"]


def convert_api_to_datas(api_file):
    pass

if __name__ == "__main__":
    # download_api_file(api_file=SWAGGER_SITE)
    get_swagger_datas(api_file=SWAGGER_SITE)