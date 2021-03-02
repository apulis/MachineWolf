# -*- coding: utf-8 -*-

import urllib.request
import ssl
import requests
import json
import time
import os
from ruamel import yaml
import random
# 导入头文件

# 生成证书上下文(unverified 就是不验证https证书)
context = ssl._create_unverified_context()


def huawei(pageNo):
    models=[]
    requestUrl='https://ascend.huawei.com/turing/model/queryResourceList'
    header={'User-Agent': 'Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.101 Safari/537.36',
            'token':'[object Object]'}
    pay_load = {"type":"1","pageNo":1,"pageSize":16,"modelType":"","modelName":"","lang":"zh","applicationArea":"87","frame":"","categoriesId":""}

    content=requests.post(requestUrl,json=pay_load,headers=header,verify=False,allow_redirects=False)
    content=content.__dict__
    content=content["_content"].decode().replace("null","None")
    content=eval(content)
    lists=content["data"]["list"]

    list02 = ["model_name",
              "publisheer",
              "application",
              "processor",
              "version",
              "level",
              "precision",
              "update",
              "frame",
              "format",
              "matching_npu",
              "matching_gpu",
              "matching_platform"]

    for i in range(len(lists)):
        list01=[]
        base_url="https://ascend.huawei.com/turing/model/queryModelByModelType"
        data={
            "id": lists[i]["id"],
            "lang": "zh",
            "modelType": lists[i]["modelType"]
              }
        res_dict=requests.post(base_url,json=data,verify=False).json()

        listTem=[
            res_dict["data"]["model"]["modelScriptName"].split(" ")[0],
            res_dict["data"]["model"]["publisherId"],
            res_dict["data"]["model"]["applicationAreaId"],
            res_dict["data"]["model"]["processorTypeId"].encode("utf8").decode("utf8"),
            res_dict["data"]["model"]["versionName"],
            res_dict["data"]["model"]["categoriesId"],
            res_dict["data"]["model"]["precisionId"],
            res_dict["data"]["model"]["createTime"],
            res_dict["data"]["model"]["frameId"],
            res_dict["data"]["model"]["modelFormatId"],
            "yes","no","no"
        ]

        list01.extend(listTem)
        models.append(dict(zip(list02, list01)))  # 两个列表合成为一个字典

    return models






if __name__=='__main__':
    i=0
    while True:
        try:
            models = huawei(pageNo=i + 1)
            for j in range(len(models)):
                # print(models[j])
                curpath = os.path.dirname(os.path.realpath(__file__))
                yamlpath = os.path.join(curpath, "huawei.yaml")
                # 写入到yaml文件
                with open(yamlpath, "a+", encoding="utf8") as f:
                    yaml.dump(models[j], f, encoding='utf-8', allow_unicode=True)
                    # Yaml 写入中文乱码的问题 加入参数 allow_unicode=True
        except Exception as e:
            break
        finally:
            i=i+1

