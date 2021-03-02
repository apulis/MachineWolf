# 拉取开放的 AI 模型库和数据集，并对其的比较分析
# Date: 2021.02-24
# Matainer: thomas
# Env: Win10 64bit, python3.9

import requests
from bs4 import BeautifulSoup
import codecs
from tqdm import tqdm
import json
import yaml
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper

CONF_PATH = r"./hub.yaml"

def read_conf(conf_file=CONF_PATH):
    # 读取配置文件中的datasets, modelsets
    stream = {}
    with open(conf_file,'r') as cf:
        stream =cf.read()
    conf = yaml.safe_load(stream)
    return conf

def get_modelzoo(modelzoo_link):
    response = requests.get(modelzoo_link["BasicsList"]) 
    response = requests.post(modelzoo_link["ResourceList"], json=modelzoo_link["request_data"], headers=modelzoo_link["request_header"]) 
    print(response.json)
    soup = BeautifulSoup(response.text, 'lxml')
    model_list = []
    language_url_dict = {} 
    print(soup.prettify())
    # for li in soup.find_all('li'):
    #     model_list.append(base_url + li.find('a').get('href')) 

def update_modelset(modelset_conf):
    hub_list = modelset_conf['model_hub']
    for imodel in hub_list.keys():
        print(hub_list[imodel])
        get_models(hub_list[imodel])


# debug
if __name__ == "__main__":
    conf=read_conf()
    modelzoo_link = {
    "entrance_url":"https://ascend.huawei.com/zh/#/software/modelzoo",
    "BasicsList":"https://ascend.huawei.com/ascendgateway/ascendservice/model/queryBasicsList?lang=zh&parentId=81&isRecommended=",
    "ResourceList":"https://ascend.huawei.com/ascendgateway/ascendservice/model/queryResourceList",
    "request_data":{"type":"1","pageNo":1,"pageSize":16,"modelType":"","modelName":"","lang":"zh","applicationArea":"87","frame":"","categoriesId":""},
    "request_header" : {"user-agent":"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36","x-requested-with":"XMLHttpRequest","accept":"application/json, text/plain, */*","accept-encoding":"gzip, deflate, br","accept-language":"en-US,en;q=0.9,zh-TW;q=0.8,zh;q=0.7","content-length":"131","content-type":"application/json;charset=UTF-8","origin":"https://ascend.huawei.com"}
    }
    print(modelzoo_link["BasicsList"])
    get_modelzoo(modelzoo_link)