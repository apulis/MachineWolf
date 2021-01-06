内网穿透测试
---------------------------------------------------
为什么使用 frp ？
通过在具有公网 IP 的节点上部署 frp 服务端，可以轻松地将内网服务穿透到公网，同时提供诸多专业的功能特性，这包括：

    客户端服务端通信支持 TCP、KCP 以及 Websocket 等多种协议。
    采用 TCP 连接流式复用，在单个连接间承载更多请求，节省连接建立时间。
    代理组间的负载均衡。
    端口复用，多个服务通过同一个服务端端口暴露。
    多个原生支持的客户端插件（静态文件查看，HTTP、SOCK5 代理等），便于独立使用 frp 客户端完成某些工作。
    高度扩展性的服务端插件系统，方便结合自身需求进行功能扩展。
    服务端和客户端 UI 页面。

1. frp 服务器，客户端配置

分别在公网服务器和私网终端下载[frp包](https://github.com/fatedier/frp/releases)，根据如下配置server,client。

这个示例通过简单配置 TCP 类型的代理让用户访问到内网的服务器。

**通过 SSH 访问内网机器: **

1.1. 服务器端 frps.ini

```
[common]
bind_port = 7000
dashboard_port = 7500
token = 12345678
dashboard_user = admin
dashboard_pwd = admin
vhost_http_port = 10080
vhost_https_port = 10443
```

其中：

    “bind_port”表示用于客户端和服务端连接的端口，这个端口号我们之后在配置客户端的时候要用到。
    “dashboard_port”是服务端仪表板的端口，若使用7500端口，在配置完成服务启动后可以通过浏览器访问 x.x.x.x:7500 （其中x.x.x.x为VPS的IP）查看frp服务运行信息。
    “token”是用于客户端和服务端连接的口令，请自行设置并记录，稍后会用到。
    “dashboard_user”和“dashboard_pwd”表示打开仪表板页面登录的用户名和密码，自行设置即可。
    “vhost_http_port”和“vhost_https_port”用于反向代理HTTP主机时使用，本文不涉及HTTP协议，因而照抄或者删除这两条均可。

---

1.2. 客户端frp.ini

```
[common]
server_addr = x.x.x.x
server_port = 7000
token = won517574356
[rdp]
type = tcp
local_ip = 127.0.0.1           
local_port = 3389
remote_port = 7001  
[smb]
type = tcp
local_ip = 127.0.0.1
local_port = 445
remote_port = 7002
```
其中common字段下的三项即为服务端的设置。

    “server_addr”为服务端IP地址，填入即可。
    “server_port”为服务器端口，填入你设置的端口号即可，如果未改变就是7000
    “token”是你在服务器上设置的连接口令，原样填入即可。


2. 开机自启动服务配置

我服务文件都弄好了，放到 /etc/systemd/system（供系统管理员和用户使用），/usr/lib/systemd/system（供发行版打包者使用）了

* 在服务器端使用 Systemd 管理 frps

    ```bash
    # 需要先 cd 到 frp 解压目录.

    # 复制文件
    cp frps /usr/local/bin/frps
    mkdir /etc/frp
    cp frps.ini /etc/frp/frps.ini

    # 编写 frp service 文件，以 ubuntu 为例
    vim /etc/systemd/system/frps.service (有时候需要手动创建system文件夹)
    # 内容如下
    [Unit]
    Description=frps
    After=network.target

    [Service]
    TimeoutStartSec=30
    ExecStart=/usr/local/bin/frps -c /etc/frp/frps.ini
    ExecStop=/bin/kill $MAINPID
    Restart=on-failure
    RestartSec=30s
    KillMode=none


    [Install]
    WantedBy=multi-user.target

    # 启动 frp 并设置开机启动
    systemctl stop frps
    systemctl disable frps
    systemctl start frps
    systemctl enable frps
    systemctl status frps

    # 部分服务器上,可能需要加 .service 后缀来操作,即:
    systemctl enable frps.service
    systemctl start frps.service
    systemctl status frps.service
    ```

* 在客户端使用 Systemd 管理 frpc

    ```bash
    # 需要先 cd frp 解压目录.

    # 复制文件
    cp frpc /usr/local/bin/frpc
    mkdir /etc/frp
    cp frpc.ini /etc/frp/frpc.ini

    # 编写 frp service 文件，以 centos7 为例,适用于 debian
    vim /etc/systemd/system/frpc.service
    # 内容如下
    [Unit]
    Description=frpc
    Wants=network-online.target
    After=network.target

    [Service]
    type=simple
    #RemainAfterExit=yes
    TimeoutStartSec=120
    ExecStart=/usr/local/bin/frpc -c /etc/frp/frpc.ini
    ExecReload=/usr/local/bin/frpc reload -c /etc/frp/frpc.ini
    ExecStop=/bin/kill -2 $MAINPID
    Restart=on-failure
    RestartSec=30s
    KillMode=none

    [Install]
    WantedBy=multi-user.target

    # 启动 frp 并设置开机启动
    systemctl stop frpc
    systemctl disable frpc
    systemctl start frpc
    systemctl enable frpc
    systemctl status frpc
    ```

* 参考链接：

1. [github](https://github.com/fatedier/frp)
2. [中文文档](https://gofrp.org/docs/setup/)
3. [systemd example](https://www.jianshu.com/p/ea7dec93ee92)
4. [systemd example2](https://zhuanlan.zhihu.com/p/80908971)
5. [frpc.ini example](https://sspai.com/post/52523)
6. [Opensuse Systemd service](https://zh.opensuse.org/openSUSE:How_to_write_a_systemd_service)
