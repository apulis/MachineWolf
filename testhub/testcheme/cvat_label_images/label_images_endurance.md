数据标注（CVAT）测试调研和并发压力测试方案与测试用例和脚本
--------------------------------------------------------------------

---

### 测试需求

客户现场可能至少有20人的并行/发标注数据集的压力场景；综合考虑对影响到平台响应的接口做100人的并发压力测试。如果标注员是通过Internet访问平台，则还需对经客户环境Internet请求的时延、吞吐量进行验证。同时要关注用户连续标注图片时的存储占用和upload,dump变慢的问题。

* 数据标注的业务流

    数据（图片）标注，标注操作主要在用户本地完成，对平台的影响在于客户端向平台请求，主要有跳转cvat,创建任务，拉取数据集(图片),上传手工/半自动标注数据集，自动标注数据集，推送到AI平台等接口请求。

    *其中橙色节点都有向平台、DB、存储的请求；操作频繁但数据块小的是手工或半自动预览图片；不太频繁但数据比较大的是上传数据集和导出请求。*

    :::image type="content" source="./img/label_images.png" alt-text="流程图":::

### CVAT压力测试调研

* 主要参考链接
1. [cvat-test](https://github.com/openvinotoolkit/cvat/tree/develop/tests)
2. [cvat-action-nightly](https://github.com/openvinotoolkit/cvat/runs/2081412856?check_suite_focus=true)
3. [cvat-gitter](https://gitter.im/opencv-cvat/public?at=5c85a33f1c597e5db6b80a86)
4. [Forum on Intel Developer Zone](https://community.intel.com/t5/Intel-Distribution-of-OpenVINO/bd-p/distribution-openvino-toolkit)
5. [#cvat tag on StackOverflow*](https://stackoverflow.com/search?q=%23cvat)

#### Annotations Format Supported

| Annotation format                                                             | Import | Export |
| ----------------------------------------------------------------------------- | ------ | ------ |
| [CVAT for images](cvat/apps/documentation/xml_format.md#annotation)           | X      | X      |
| [CVAT for a video](cvat/apps/documentation/xml_format.md#interpolation)       | X      | X      |
| [Datumaro](https://github.com/openvinotoolkit/datumaro)                       |        | X      |
| [PASCAL VOC](http://host.robots.ox.ac.uk/pascal/VOC/)                         | X      | X      |
| Segmentation masks from [PASCAL VOC](http://host.robots.ox.ac.uk/pascal/VOC/) | X      | X      |
| [YOLO](https://pjreddie.com/darknet/yolo/)                                    | X      | X      |
| [MS COCO Object Detection](http://cocodataset.org/#format-data)               | X      | X      |
| [TFrecord](https://www.tensorflow.org/tutorials/load_data/tf_records)         | X      | X      |
| [MOT](https://motchallenge.net/)                                              | X      | X      |
| [LabelMe 3.0](http://labelme.csail.mit.edu/Release3.0)                        | X      | X      |
| [ImageNet](http://www.image-net.org)                                          | X      | X      |
| [CamVid](http://mi.eng.cam.ac.uk/research/projects/VideoRec/CamVid/)          | X      | X      |
| [WIDER Face](http://shuoyang1213.me/WIDERFACE/)                               | X      | X      |
| [VGGFace2](https://github.com/ox-vgg/vgg_face2)                               | X      | X      |

#### Deep learning serverless functions for automatic labeling

| Name                                                                                                    | Type       | Framework  | CPU | GPU |
| ------------------------------------------------------------------------------------------------------- | ---------- | ---------- | --- | --- |
| [Deep Extreme Cut](/serverless/openvino/dextr/nuclio)                                                   | interactor | OpenVINO   | X   |     |
| [Faster RCNN](/serverless/openvino/omz/public/faster_rcnn_inception_v2_coco/nuclio)                     | detector   | OpenVINO   | X   |     |
| [Mask RCNN](/serverless/openvino/omz/public/mask_rcnn_inception_resnet_v2_atrous_coco/nuclio)           | detector   | OpenVINO   | X   |     |
| [YOLO v3](/serverless/openvino/omz/public/yolo-v3-tf/nuclio)                                            | detector   | OpenVINO   | X   |     |
| [Object reidentification](/serverless/openvino/omz/intel/person-reidentification-retail-300/nuclio)     | reid       | OpenVINO   | X   |     |
| [Semantic segmentation for ADAS](/serverless/openvino/omz/intel/semantic-segmentation-adas-0001/nuclio) | detector   | OpenVINO   | X   |     |
| [Text detection v4](/serverless/openvino/omz/intel/text-detection-0004/nuclio)                          | detector   | OpenVINO   | X   |     |
| [SiamMask](/serverless/pytorch/foolwood/siammask/nuclio)                                                | tracker    | PyTorch    | X   |     |
| [f-BRS](/serverless/pytorch/saic-vul/fbrs/nuclio)                                                       | interactor | PyTorch    | X   |     |
| [Inside-Outside Guidance](/serverless/pytorch/shiyinzhang/iog/nuclio)                                   | interactor | PyTorch    | X   |     |
| [Faster RCNN](/serverless/tensorflow/faster_rcnn_inception_v2_coco/nuclio)                              | detector   | TensorFlow | X   | X   |
| [Mask RCNN](/serverless/tensorflow/matterport/mask_rcnn/nuclio)                                         | detector   | TensorFlow | X   | X   |


* **松山湖项目的数据集要求： coco、voc、imagenet、 txt+jpg**

### CVAT Limitations:

+ **No more than 10 tasks per user**
+ **Uploaded data is limited to 500Mb**

### 社区反应的相关性能问题：

* 最新版本 V1.2.0 解决了38个重要的Bug；还有51个open的bug，其中2个critical bug #2537，#2542在测试环境http://192.168.1.18/annotations没有复现，但有其他集成不完善的地方在沟通确认中。

* StackOverflow上2个没有回复的问题，目前应该不支持
    + [Merge labels in CVAT](https://stackoverflow.com/questions/66144011/merge-labels-in-cvat) 
    + [converting xml files to manifest json format](https://stackoverflow.com/questions/66450027/converting-xml-files-to-manifest-json-format)



#### 在gitter上有较多(视频)标注慢的问题 

* I just cannot export annotations in any format. It is just slowly loading but never download. I tried from two different accounts, even different laptops - the same issue. I am working as data annotator and just need the annotations to be exported for the client.

    Maxim Zhiltsov
    @zhiltsov-max
    Mar 09 16:24
    Hi, depending on the task, it can take some time - up to hours for long video segmentation formats, especially if there are multiple jobs in the task and images are 4k+. We're optimizing that continuously, but it is possible, that something still works slow.

* We are experiencing some data loading issues when skipping many frames (the loading wheel keeps rotating for a while). It is not super slow but not ideal if you go in the labelling video back and forth.

* POD内存可能需要4G以上，待实际环境验证

    Does CVAT server have any hardcoded memory limit? I am asking because we have it deployed with Kubernetes with a memory request of 2GiB and a memory limit of 4GiB and we see the UI freezing when we hit 2GiB (in theory; applications wouldn't be normally aware of the kubernetes memory requests so we are wondering if the 2GiB limit is hardcoded somewhere and it just happened to coincide by luck with our 2GiB Kube memory request).
    We are using the following image : https://hub.docker.com/layers/openvino/cvat_server/v1.2.0/images/sha256-e05ca3559cc557f5d821ccee618dc868ec8ed5ff5ed842924b0b00c06cfa9cd4?context=explore
    Thank you!

    Andrey Zhavoronkov
    @azhavoro
    Mar 02 20:28
    Hi, we doesn't set any memory limits

* 存储空间没有释放的问题

    Hey all I'm new to CVAT and using Docker. I have a question about space usage. I uploaded and labelled some videos, but when I tried to download the dataset, I got an error that there wasn't enough space. I increased my docker space available (from 60Gb to 103Gb). I also tried deleting some tasks I didn't need to work on immediately. The deleted tasks didn't free up any space at all, even though they were originally >1Gb each. I successfully exported one dataset, which made a zip file over 35Gb. However, it increased my docker space the same amount and I'm again getting the out of space error. When I do "docker system df -v" the volume cvat_cvat_data has over 50Gb on it. How do I clear out my deleted and temp files from CVAT? I've tried docker pruning and restarting the programs. Happy to provide more details.

* 由于500M限制，可以通过挂载目录共享大数据集

    I want to upload many images to a task and possible the size of the images is big (some GB). what is the best way to do that? I guess doing it from the web app is not optimal.. can you do that using the REST API ?? is it possible to create a symlink to a folder outside the docker linking to the task folder ?

    Andrey Zhavoronkov
    @azhavoro
    Mar 10 18:50
    Hi, symlinks are not the best choice for Docker, try to configure share https://github.com/openvinotoolkit/cvat/blob/develop/cvat/apps/documentation/installation.md#share-path. Also this may be interesting for you https://github.com/openvinotoolkit/cvat/blob/develop/cvat/apps/documentation/mounting_cloud_storages.md

#### github open-issues(可能与稳定性相关bug)

* [Deleted tasks and dataset exports use up Docker space](https://github.com/openvinotoolkit/cvat/issues/2859)
* [Delay in sending logs to Logstash](https://github.com/openvinotoolkit/cvat/issues/2832)
* [Unable to create task from zip archive located in connected shared folder](https://github.com/openvinotoolkit/cvat/issues/2677)
* [Cannot upload YOLO annotations generated from dump annotations ](https://github.com/openvinotoolkit/cvat/issues/2473)
* [big zipfile ,create task,django-rq , django.db.utils.OperationalError: connection not open](https://github.com/openvinotoolkit/cvat/issues/2353)
* [Timeout: Incomplete Dataset Export Download](https://github.com/openvinotoolkit/cvat/issues/2330)
* [Wrong annotation in the dumped file ](https://github.com/openvinotoolkit/cvat/issues/2254)
* [Possible memory leaks can lead to server crash on dataset export](https://github.com/openvinotoolkit/cvat/issues/2241)
* [CVAT new UI: Error when switching to another frame immediately after opening the job](https://github.com/openvinotoolkit/cvat/issues/1611)
* [Timeout when uploading a big file with annotations](https://github.com/openvinotoolkit/cvat/issues/964)
* [Maximum timeout value on the task creation](https://github.com/openvinotoolkit/cvat/issues/475)
* [CVAT with video performance](https://github.com/openvinotoolkit/cvat/issues/2694)

    *We have two types of videos: 1080p and +4K. When using CVAT on the same network as the server the performance for 1080p is decent but for 4K or 1080p accessing from a different network, it's impossible to watch the video without having to wait several times for it to buffer the following frames / chunks of video (we've tried with both pre-1.0 version and with the recent ones).*

* **待验证**单个用户连续标注图片可能存在响应变慢的问题 [UI becomes slow after 300-400 annotations](https://github.com/openvinotoolkit/cvat/issues/39)

### Github [CI-nightly](https://github.com/openvinotoolkit/cvat/actions/workflows/schedule.yml) testsuites

  每天晚上执行的action（集成测试）包含了所有的基本操作，近期的action执行结果都是✅PASS的。

* 主要分类： 
    + 项目操作： actions_projects
    + 任务操作： actions_tasks_objects
    + 用户操作： actions_users
    + 邮件通知： email_system
    + 登录认证： auth_page
    + 删除用户任务： remove_users_tasks

    *还有相关功能的bug验证测试脚本*

---

## 并发压力测试方案

了解到数据（图片）标注操作主要在用户本地完成，对平台的影响在于客户端向平台请求，主要有跳转cvat,创建任务，拉取数据集(图片),上传手工/半自动标注数据集，自动标注数据集，推送到AI平台的接口请求。对资源主要消耗存储和内存空间。

* 测试场景或用例

    1. 单用户并发10个task的基础操作请求
    2. 单用户持续标注1000以上图标的响应和时延
    3. 100用户并发的基础操作
    4. 20用户并发的upload/dump 500M文件的操作（数据集导入，导出）。
    5. 存储空间的耗用和回收
    6. 内存空间的耗用和系统整体的响应
    7. 内网环境、Internet下响应时延
    8. 其他...

* 测试环境

    + 办公室 1*x86Master + 2*x86-GPU 
    + 机房单个atlas测试环境

    + 松山湖环境

        1. 1x86 Master + 1xStorage

        * Master

        |资源  |规格  |
        |---------|---------|
        |CPU     |  64核       |
        |内存     |  128GB       |
        |系统盘     |   1TB SSDB      |
        |存储盘     |   10T HDD      |

        * Storage

        |资源  |规格  |
        |---------|---------|
        |CPU     |  128核       |
        |内存     |  128GB       |
        |系统盘     |   1TB SSDB      |
        |存储盘     |   500T HDD      |

* 测试数据举例

    + 数据集：没标注的图片数据集
    + 模型：待定
    + 数据标注格式：
        - 文本检测: ICDAR2013
        - 文字识别: mjsynth
        - 图像分类: imagenet
        - 目标检测: coco


* 测试流或计划

    |任务         |预估时间       |备注     |
    |-------------|--------------|---------|
    |原型测试      | 2人/天       |调试和定位适配问题 |
    |迭代测试      | 0.5人/天       |例行测试  |
    |发布验收测试  | 0.5人/天       |问题回归  |


* 风险预估和待定事项

    + cvat还在集成验证中
    + 测试所用数据集较小，与生产环境有较大差别
    + 待确认标注员在内网环境还是Internet

### 测试用例和脚本（待完善）

   `perfboard/testhub/testsuites/label_images/`

### SLO/SLI预估

SLI(Service Level indicators)：服务等级指标，其实就是我们选择哪些指标(qps，响应时间，准确性)来衡量我们的稳定性

SLO(Service Level Objectives)：服务等级目标，指的就是我们设定的稳定性目标，比如“qps几个 9,响应时间10ms”这样的目标

|SLI |SLO  |
|---------|---------|
|测试一段时间内基本操作创建、拉取图片、保存、上传的api调用、响应时延     | 99%的api响应时间 <=1s       |
|测试一段时间内基本操作的api响应失败率                                | 所有的api响应失败率 <= 0.01% |
|测试一段时间内多任务并发的CPU使用率                                  | 待定                        |   
|测试一段时间内多任务并发的MEM使用量                                  | 待定                        |  

### 高可用性预估

* 观察一段时间内多任务的存储空间的占用
* 观察一段时间内多任务处理时，平台不响应或异常报错
* 观察一段时间内文件的上传、下载、增删改查可能出现的异常报错

### 附录（参考）

*相关参考：*
1. [用户愿意等待的时间-性能指标与建议](https://www.huaweicloud.com/articles/e9d3c7dd5fbf841f7963d42c91bd31ea.html)

* 全部页面加载时间

    全部页面载入时间指从最初启动浏览开始，直到所有元素都被加载完成后，在2秒后仍然没有网络活动的时间。

    + 0-2秒：用户体验最好，打分100
    + 2-8秒：用户可以容忍，从第2秒开始，每超过1秒减5分
    + 8-15秒：用户不能忍受，从第2秒开始，每超过1秒减5分

* 首字节时间

    从开始加载到收到服务器返回数据的第一字节的时间.
    达标时间=DNS解析时间+创建连接时间+SSL认证时间+100ms. 比达标时间每慢10ms减1分.

    + 0-1秒：用户体验最好
    + 1-2秒：用户可以容忍
    + 2-3秒：用户不能容忍

* 客户端建立连接的时间
    + 0-100毫秒 100分
    + 100-500毫秒，一般，可能会影响用户体验，从100毫秒开始，没增加10毫秒，减去1分
    + 500毫秒以上，严重影响⽤用户的网页体验，从100毫秒开始，每增加10毫秒，减去1分