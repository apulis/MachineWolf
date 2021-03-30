# 松山湖环境postgres数据丢失问题分析与复现



**总体称述**：

**数据丢失应该是维护操作导致的。**

* 会导致数据丢失的必然操作：重置集群，手工误删除文件（如删除cluster-id， pv），或重置NFS、pv/pvc配置。
* 可能会导致数据丢失的配置：`aiplatform-component-data-pv` 的回收策略为 `Recycle`,建议改为 `Retain`。
* 在perf-env测试环境,尝试更新、重启平台所有服务，重启NFS, 重启postgres没有复现数据丢失的问题。
* 调查回访测试运维、开发同事遇到的数据丢失，都是在安装部署或维护环境的情况下；而平台正常运行、测试阶段没有出现过数据丢失情况。

  昨天松山湖环境出现故障，在恢复harbor过程中删除了集群id文件`credentials/cluster-id`,在恢复平台时会重新生成id，重置集群配置和数据库。

## 一、问题

   **集群随机出现故障，数据库被清空**
   

## 二、相关环境和配置调查分析

### 部署环境
 
* 集群配置：1 x86-64 Master + 1 x86-64 * 8p NPU Worker  + 1 x arm64 * 8P NPU Worker
* 平台信息：松山湖工业质检平台，相关功能模块v3.0.0; k8s基础组件保持不变。 

### k8s PV/PVC策略

**accessModes支持多种访问模式**

1. ReadWriteOnce（RWO）：读写权限，但是只支持挂载在1个Pod
2. ReadOnlyMany（ROX）：只读权限，支持挂载在多个Pod
3. ReadWriteMany（RW）：读写权限，支持挂载在多个Pod上

**persistentVolumeReclaimPolicy的策略** 指的是如果PVC被释放掉后，PV的处理，这里所说的释放，指的是用户删除PVC后，与PVC对应的PV会被释放掉，PVC个PV是一一对应的关系

1. Retain，PV的数据不会清理，会保留volume，如果需要清理，需要手动进行
2. Recycle，会将数据进行清理，即 rm -rf /thevolume/*（只有 NFS 和 HostPath 支持），清理完成后，PV会呈available状态，支持再次的bound
3. Delete，删除存储资源，会删除PV及后端的存储资源，比如删除 AWS EBS 卷（只有 AWS EBS, GCE PD, Azure Disk 和 Cinder 支持）

### postgres 数据落盘 `aiplatform-component-data-pvc`

```bash
Controlled By:  ReplicaSet/postgres-77d5b58654
Containers:
postgres:
    Container ID:   docker://b2f1716bc56aa64e6f1576b79b6ea96e2931bfc96316a0d7bbe22f9687f6a131
    Image:          harbor.atlas.cn:8443/sz_gongdianju/postgres:11.10-alpine
    Image ID:       docker-pullable://harbor.atlas.cn:8443/atlas/postgres@sha256:a1cb95235623f0521f0d0795d27ad09d3639f88ba92302a2b3416e65b907337e
    Port:           5432/TCP
    Host Port:      5432/TCP
    State:          Running
    Started:      Fri, 26 Mar 2021 15:46:21 +0800
    Last State:     Terminated
    Reason:       Completed
    Exit Code:    0
    Started:      Fri, 26 Mar 2021 15:45:51 +0800
    Finished:     Fri, 26 Mar 2021 15:46:00 +0800
    Ready:          True
    Restart Count:  3
    Environment:
    POSTGRES_USER:      postgres
    POSTGRES_PASSWORD:  yuGa4H7Gfwrpv2ed
    Mounts:
    /var/lib/postgresql/data from aiplatform-component-data-pvc (rw,path="postgres/")
    /var/run/secrets/kubernetes.io/serviceaccount from default-token-9mp46 (ro)
Conditions:
Type              Status
Initialized       True
Ready             True
ContainersReady   True
PodScheduled      True
Volumes:
aiplatform-component-data-pvc:
    Type:       PersistentVolumeClaim (a reference to a PersistentVolumeClaim in the same namespace)
    ClaimName:  aiplatform-component-data-pvc
    ReadOnly:   false
default-token-9mp46:
    Type:        Secret (a volume populated by a Secret)
    SecretName:  default-token-9mp46
    Optional:    false
QoS Class:       BestEffort
Node-Selectors:  archType=amd64
                postgres=active
Tolerations:     node.kubernetes.io/not-ready:NoExecute for 300s
                node.kubernetes.io/unreachable:NoExecute for 300s
```

### 平台配置的PV/PVC策略配置

**aiplatform-component-data-pv**的访问模式为`RWX` 允许多个POD读写权限；回收策略为**Recycle**，有可能将数据清理。！

```bash
# aiplatform-model-data kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                                   STORAGECLASS     REASON   AGE
aiplatform-app-data-pv                     300Mi      RWX            Recycle          Bound    default/aiplatform-app-data-pvc                         app-data                  4d1h
aiplatform-component-data-pv               300Mi      RWX            Recycle          Bound    kube-system/aiplatform-component-data-pvc               component-data            4d1h
aiplatform-label-data-pv                   300Mi      RWX            Recycle          Bound    default/aiplatform-label-data-pvc                       label-data                4d1h
aiplatform-model-data-pv                   300Mi      RWX            Recycle          Bound    default/aiplatform-model-data-pvc                       model-data                4d1h
aiplatform-model-data-pv-kfserving-pod     300Mi      RWX            Retain           Bound    kfserving-pod/aiplatform-model-data-pvc-kfserving-pod   kfserving-data            4d1h
pvc-0058f548-9743-445d-92bf-407c760a0d6a   8Gi        RWO            Delete           Bound    default/data-rabbitmq-0                                 nfs-client                4d1h
#  aiplatform-model-data kubectl get pvc
NAME                        STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   AGE
aiplatform-app-data-pvc     Bound    aiplatform-app-data-pv                     300Mi      RWX            app-data       4d1h
aiplatform-label-data-pvc   Bound    aiplatform-label-data-pv                   300Mi      RWX            label-data     4d1h
aiplatform-model-data-pvc   Bound    aiplatform-model-data-pv                   300Mi      RWX            model-data     4d1h
data-rabbitmq-0             Bound    pvc-0058f548-9743-445d-92bf-407c760a0d6a   8Gi        RWO            nfs-client     4d1h
```

### 可能导致数据丢失的情况

1. 重启平台服务
2. 重启postgres
3. 重置集群 （会重新生成clustid，DB，必然会丢失数据）
4. 删除集群id `credentials/cluster-id`
5. 重启nfs所在机器
6. 手工在root环境下误操作
    * 更改 NFS 挂载路径
    * 修改 postgres volume
    * 误删除文件（如删除文件必然会破坏相关文件）
7. 日志清理脚本（暂时没有）

## 三、模拟操作测试

perf-env测试库环境更新松山湖最新InstalltionYTung/v3.0.0-songshanhu 部署代码和配置，以及相关模块v3.0.0-songshanhu镜像。

1. 重启平台服务，包含重启NFS

    其中调用`92.aiarts-stop.yaml`会stop NFS， `93.aiarts-restart.yaml`会start NFS，

    NFS重启的日志如下，仅删除pvc，没有删除pv上的数据!

    ```bash
    TASK [aiarts-service : stop k8s service  storage-nfs]

    failed: [192.168.1.198] (item=/root/build/storage-nfs/04.modeldata-pv.yaml) => {"ansible_loop_var": "yaml", "changed": true, "cmd": "/opt/kube/bin/kubectl delete -f /root/build/storage-nfs/04.modeldata-pv.yaml ", "delta": "0:00:00.059807", "end": "2021-03-30 03:46:12.312483", "msg": "non-zero return code", "rc": 1, "start": "2021-03-30 03:46:12.252676", "stderr": "Error from server (NotFound): error when deleting \"/root/build/storage-nfs/04.modeldata-pv.yaml\": namespaces \"kfserving-pod\" not found\nError from server (NotFound): error when deleting \"/root/build/storage-nfs/04.modeldata-pv.yaml\": persistentvolumeclaims \"aiplatform-model-data-pvc-kfserving-pod\" not found", "stderr_lines": ["Error from server (NotFound): error when deleting \"/root/build/storage-nfs/04.modeldata-pv.yaml\": namespaces \"kfserving-pod\" not found", "Error from server (NotFound): error when deleting \"/root/build/storage-nfs/04.modeldata-pv.yaml\": persistentvolumeclaims \"aiplatform-model-data-pvc-kfserving-pod\" not found"], "stdout": "persistentvolume \"aiplatform-model-data-pv\" deleted\npersistentvolumeclaim \"aiplatform-model-data-pvc\" deleted\npersistentvolume \"aiplatform-model-data-pv-kfserving-pod\" deleted", "stdout_lines": ["persistentvolume \"aiplatform-model-data-pv\" deleted", "persistentvolumeclaim \"aiplatform-model-data-pvc\" deleted", "persistentvolume \"aiplatform-model-data-pv-kfserving-pod\" deleted"], "yaml": "/root/build/storage-nfs/04.modeldata-pv.yaml"}
    ```

2. 重启postgres
   * 执行 `kubectl delete pods -n kube-system postgres-77d5b58654-zscpf` 未出现数据丢失
   * `./service_ctl.sh restart postgres` 未出现数据丢失

4. 重启nfs所在机器，也即重启Master节点，未出现数据丢失
