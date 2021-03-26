# -*- coding: utf-8 -*-
""" FAKE_USER
# INFO:    创建指定大小，和数量的图片
# VERSION: 2.0
# EDITOR:  thomas
# TIMER:   2021-03-09
"""

"""
工业相机通过GigE Vision 协议传输的数据速率取决于相机的像素、格式、帧率：

传输速率（Mbps）= （像素 x 格式 x 帧率）/（1024*1024）

目前主流工业视觉应用一般为；

* 像素500W、1000W及2000W
* 格式包括(Mono、RGB、YUV等)1位、8位、16位、24位、32位等
* 帧率 24fps 30fps 60fps,75fps

|视频质量         |分辨率      |视频编码格式 |典型码率|
|-----------------|------------|-------------|--------|
|1080p@30fps      |1920x1080   | H.264       |4M      |
|2K@30fps         |2560x1440   | H.264       |6M      | 
|4K@30fps         |3840x2160   | H.264       |16M     |

以中国移动目前2.6GHz的100MHz频段为例，但在实际应用环境中，单终端普遍可获得上行速率在50~100Mbps。

* 工业场景图像质量分类

|分类                 |原始图像大小          |上行速率      |在总的图像数目的占比|
|---------------------|----------------------|--------------|--------------------|
|3C结构件检测         | 428 KB               |              |                    |
|手机中框3D检测       | 3.37 MB              |              |                    | 
|汽车零部件检测       | 2.5 MB               |              |                    | 
|3C工件表面检测       | 1.5MB                |              |                    | 
|3D 结构光SPI视觉检测 |500W 像素，8Bit 灰阶  | 约为3.2Mbps；| 5%                 |
|AOI 炉前/后视觉检测  |500W 像素，24Bit 彩图 | 约为1.2Mbps；| 10%                |
|装配动作合规检测     |2K H.264 编码         | 典型 6Mbps;  |                    |  
|产品表面瑕疵检测     |1000W 像素，24Bit 彩图|   约 30Mbps；|                    |

松山湖提供的图像数据 1 ~ 10MB，均值为2MB
"""
import threading
 
from PIL import Image
 
image_size = range(1000, 1001)
 
 
def start():
  for size in image_size:
    t = threading.Thread(target=create_image, args=(size,))
    t.start()
 
 
def create_image(size):
  pri_image = Image.open("datasetshub/origin.jpg")
  pri_image.resize((size, size), Image.ANTIALIAS).save("datasetshub/png_%d.jpg" % size)
 
 
if __name__ == "__main__":
    start()
