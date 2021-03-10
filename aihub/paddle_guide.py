# tensorflow 2.0 指导
# Date: 2021.01-25
# Matainer: thomas
# Env: Win10 64bit, python3.8


from __future__ import print_function
import paddle
import paddle.fluid as fluid
import numpy
import math
import sys

import paddle.fluid as fluid

# 定义一个数据类型为int64的二维数据变量x，x第一维的维度为3，第二个维度未知，要在程序执行过程中才能确定，因此x的形状可以指定为[3, None]
x = fluid.data(name="x", shape=[3, None], dtype="int64")

# 大多数网络都会采用batch方式进行数据组织，batch大小在定义时不确定，因此batch所在维度（通常是第一维）可以指定为None
batched_x = fluid.data(name="batched_x", shape=[None, 3, None], dtype='int64')

import paddle.fluid as fluid
data = fluid.layers.fill_constant(shape=[3, 4], value=16, dtype='int64')

print(data)
