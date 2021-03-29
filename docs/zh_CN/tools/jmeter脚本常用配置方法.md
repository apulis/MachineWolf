# jmeter 脚本常用配置方法



* Job name
  ${__jexl3("gpu-test"+"_"+"${__threadNum}")}

* 随机数
${__Random(1,1000)}

${__jexl3(200+${__threadNum})}

* csv 文件读取
```
   resources_folder: ${__P(resources, ../resources)}
   ${resources_folder}/accounts.csv
   utf-8
   username,pureKey,passwd
   ,   # 分隔符

```
* 设置全局变量
${__setProperty(auth, ${token},)} 

+ 子控制过程引用全局变量
Cookie： token=${__P(auth,)}

* 当前线程ID
${__threadNum}

* 提取返回值 Json 中的id array
    userIdArray
    $.[*].id
    -1
    + 可直接批量引用
    [${rolePageIdArray_1},${rolePageIdArray_2},${rolePageIdArray_3},${rolePageIdArray_4},${rolePageIdArray_5},]
    userIdArray
    rolePageIdArray_1=1
    rolePageIdArray_10=69
    rolePageIdArray_2=2
    rolePageIdArray_3=62
    rolePageIdArray_4=63
    rolePageIdArray_5=64
    rolePageIdArray_6=65
    rolePageIdArray_7=66
    rolePageIdArray_8=67
    rolePageIdArray_9=68


* foreach controllor 逻辑块参数设置

MyJobIds
iJobId

* if controllor 逻辑块参数设置
${__jexl3("${jobStatus}" != "killed")}

* Loop controller 中的index
JMeter will expose the looping index as a variable named __jm__<Name of your element>__idx. So for example, if your Loop Controller is named LC, then you can access the looping index through ${__jm__LC__idx}. Index starts at 0

示例： Loop controller 重命名为：LoopSubmit
多用户批量执行Job name: ${__jexl3("cpu_test"+"_"+"${username}"+"_"+"${__jm__LoopSubmit__idx}")}


* CPU job

  + cmd: ```sleep 10m```

1. 单机

```
{"userName":"${username}","jobType":"training","gpuType":"nvidia","vcName":"platform","containerUserId":0,"jobName":"${__jexl3("cpu_test"+"_"+"${username}"+"_"+"${__jm__LoopSubmit__idx}")}","jobtrainingtype":"RegularJob","preemptionAllowed":"${preemptionAllowed}","image":"apulistech/mindspore:0.2.0","cmd":"sleep ${jobSleep}m","workPath":"./","enableworkpath":true,"dataPath":"./","enabledatapath":true,"jobPath":"./","enablejobpath":true,"env":[],"hostNetwork":false,"isPrivileged":false,"interactivePorts":"40000,45000","plugins":{"blobfuse":[{"accountName":"","accountKey":"","containerName":"","mountPath":"","mountOptions":""}],"imagePull":[{"registry":"","username":"","password":""}]},"resourcegpu":0}

```


2. 分布式
```
{"userName":"${username}","jobType":"training","gpuType":"nvidia","vcName":"baseline","containerUserId":0,"jobName":"${__jexl3("cpu_distirbuted_test"+"_"+"${username}"+"_"+"${__jm__LoopSubmit__idx}")}","jobtrainingtype":"RegularJob","preemptionAllowed":"${preemptionAllowed}","image":"ubuntu:16.04","cmd":"sleep ${jobSleep}m","workPath":"./","enableworkpath":true,"dataPath":"./","enabledatapath":true,"jobPath":"./","enablejobpath":true,"env":[],"hostNetwork":false,"isPrivileged":false,"interactivePorts":"","plugins":{"blobfuse":[{"accountName":"","accountKey":"","containerName":"","mountPath":"","mountOptions":""}],"imagePull":[{"registry":"","username":"","password":""}]},"resourcegpu":0}
```

* GPU job

  + cmd: ```sudo bash -c "source /root/anaconda3/bin/deactivate && conda activate open-mmlab && cd /root/pytorch_samples/mnist/ && python main.py --epochs 10002"```

1. 单机

```
{"userName":"${username}","jobType":"training","gpuType":"nvidia","vcName":"platform","containerUserId":0,"jobName":"${__jexl3("gpu_test"+"_"+"${username}"+"_"+"${__jm__LoopSubmit__idx}")}","jobtrainingtype":"RegularJob","preemptionAllowed":"${preemptionAllowed}","image":"apulistech/cuda:10.0","cmd":"sudo bash -c \"source /root/anaconda3/bin/deactivate && conda activate open-mmlab && cd /root/pytorch_samples/mnist/ && python main.py --epochs ${jobSleep}\"","workPath":"./","enableworkpath":true,"dataPath":"./","enabledatapath":true,"jobPath":"./","enablejobpath":true,"env":[],"hostNetwork":false,"isPrivileged":false,"interactivePorts":"40000,45000","plugins":{"blobfuse":[{"accountName":"","accountKey":"","containerName":"","mountPath":"","mountOptions":""}],"imagePull":[{"registry":"","username":"","password":""}]},"resourcegpu":${resourcegpu}}
```


2. 分布式

```
{"userName":"${username}","jobType":"training","gpuType":"${gpuType}","vcName":"${vcName}","containerUserId":0,"jobName":"${__jexl3("gpu_distirbuted_test"+"_"+"${username}"+"_"+"${__jm__LoopSubmit__idx}")}","jobtrainingtype":"PSDistJob","preemptionAllowed":"${preemptionAllowed}","image":"apulistech/cuda:10.0","cmd":"sudo bash -c \"source /root/anaconda3/bin/deactivate && conda activate open-mmlab && cd /root/pytorch_samples/mnist/ && python main.py --epochs ${jobSleep}\"","workPath":"./","enableworkpath":true,"dataPath":"./","enabledatapath":true,"jobPath":"./","enablejobpath":true,"env":[],"hostNetwork":true,"isPrivileged":true,"interactivePorts":"","plugins":{"blobfuse":[{"accountName":"","accountKey":"","containerName":"","mountPath":"","mountOptions":""}],"imagePull":[{"registry":"","username":"","password":""}]},"numps":1,"resourcegpu":${resourcegpu},"numpsworker":${numpsworker}}

```
{"userName":"sample0","jobType":"training","gpuType":"nvidia_gpu_amd64","vcName":"atlas01","containerUserId":0,"jobName":"test_gpu_2","jobtrainingtype":"PSDistJob","preemptionAllowed":"False","image":"apulistech/cuda:10.0","cmd":"sudo bash -c \"source /root/anaconda3/bin/deactivate && conda activate open-mmlab && python /data/code/main.py --epochs 10002\"","workPath":"./","enableworkpath":true,"dataPath":"./","enabledatapath":true,"jobPath":"./","enablejobpath":true,"env":[],"hostNetwork":true,"isPrivileged":true,"interactivePorts":"","plugins":{"blobfuse":[{"accountName":"","accountKey":"","containerName":"","mountPath":"","mountOptions":""}],"imagePull":[{"registry":"","username":"","password":""}]},"numps":1,"resourcegpu":8,"numpsworker":2}

* 设置 endpoint
{"endpoints":[{"name":"port-40000","podPort":40000},{"name":"port-45000","podPort":45000},"ssh","ipython"]}

https://china-gpu02.sigsus.cn/sign-in


https://china-gpu02.sigsus.cn/api/v2/clusters/china-gpu02/teams/platform/jobs?limit=999 
                            /api/v2/clusters/${host}/teams/baseline/jobs?limit=999

                      
* 创建VC 
  1.VC_Name
    ${__jexl3("VC"+"_"+"${VCType}"+"_"+"${__threadNum}"}

//sandbox2-master.sigsus.cn:52080/api/sandbox02-gpu01/addVc/${__jexl3("VC"+"_"+"${VCType}"+"_"+"${__threadNum}"}/%7B%22${VCType}%22:${VCNu

* 随机取Array 元素

``` ${__RandomFromMultipleVars(userIdArray)} ```