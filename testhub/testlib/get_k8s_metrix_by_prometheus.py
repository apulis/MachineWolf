#!/usr/bin/env python
# -*- coding:utf-8 -*-
""" prometheus_client
# INFO:    获取虚拟环境的CPU,MEM,storage
# VERSION: 2.0.0
# EDITOR:  thomas
# TIMER:   2021-03-11
# STATUS: Debug
"""

# apulis ai platform prometheus config 
# config.file=/etc/prometheus/prometheus.yml
# web.listen-address=0.0.0.0:9091
# web.external-url=http://localhost:9091/prometheus/

"""
from prometheus_client import start_http_server, Summary
import random
import prometheus_client
import time
import psutil

UPDATE_PERIOD = 300
SYSTEM_USAGE = prometheus_client.Gauge('system_usage',
                                       'Hold current system resource usage',
                                       ['resource_type'])

if __name__ == '__main__':
  prometheus_client.start_http_server(9999)
  
while True:
  SYSTEM_USAGE.labels('CPU').set(psutil.cpu_percent())
  SYSTEM_USAGE.labels('Memory').set(psutil.virtual_memory()[2])
  time.sleep(UPDATE_PERIOD)
 
"""

from random import randint
from flask import Flask, Response
from prometheus_client import Counter, Gauge, Histogram, Summary, generate_latest, CollectorRegistry

app = Flask(__name__)

registry = CollectorRegistry()
counter = Counter('my_counter', 'an example showed how to use counter', ['machine_ip'], registry=registry)
gauge = Gauge('my_gauge', 'an example showed how to use gauge', ['machine_ip'], registry=registry)

buckets = (100, 200, 300, 500, 1000, 3000, 10000, float('inf'))
histogram = Histogram('my_histogram', 'an example showed how to use histogram',
                      ['machine_ip'], registry=registry, buckets=buckets)
summary = Summary('my_summary', 'an example showed how to use summary', ['machine_ip'], registry=registry)


@app.route('/metrics')
def matrix(machine_ip='192.168.1.18:9091'):
    counter.labels(machine_ip).inc(1)
    gauge.labels(machine_ip).set(2)
    histogram.labels(machine_ip).observe(1001)
    summary.labels(machine_ip).observe(randint(1, 10))

    return Response(generate_latest(registry), mimetype='text/plain')


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
