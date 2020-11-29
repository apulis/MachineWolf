# 基于  Github Action 的 CI/CD 流程

## 前言
在大型的开源项目或者软件开发过程中， 很多开发者都会去提交`PR`或者进行代码的 `push`操作。如果对于每次代码合并都需要项目的核心维护者进行 `code review`，这项工作是及其困难而且耗时的。因此许多团队都会指定一套代码规范, 然后编写测试用例严格的检查每次代码修改， 这样能够非常有效的减少后期代码维护的成本。

现在，基于 $Github  Action$, 我们可以自动化的完成代码的 `CI/CD` 工作流。$Github Ac­tions$是 GitHub 推出的持续集成 (Con­tin­u­ous in­te­gra­tion，简称 CI) 服务，它提供了配置非常不错的虚拟服务器环境，基于它可以进行构建、测试、打包、部署项目。

Github Actions 的最大优势就是它是与 GitHub 高度整合的，只需一个配置文件即可自动开启服务。甚至你不需要购买服务器 —— GitHub Actions 自带云环境运行，包括私有仓库也可以享用，而且云环境性能也非常不错。

本篇文章将介绍 GitHub Ac­tions 的基本使用方法。

### CI (Continuous integration)
互联网软件的开发和发布，已经形成了一套标准流程，最重要的组成部分就是持续集成（Continuous integration，简称CI）
#### 概念
持续集成指的是，频繁地（一天多次）将代码集成到主干。
它的好处主要有两个
- 快速发现错误。每完成一点更新，就集成到主干，可以快速发现错误，定位错误也比较容易。

- 防止分支大幅偏离主干。如果不是经常集成，主干又在不断更新，会导致以后集成的难度变大，甚至难以集成。

持续集成的目的，就是让产品可以快速迭代，同时还能保持高质量。它的核心措施是，代码集成到主干之前，必须通过自动化测试。只要有一个测试用例失败，就不能集成。

#### 持续交付
持续交付（Continuous delivery）指的是，频繁地将软件的新版本，交付给质量团队或者用户，以供评审。如果评审通过，代码就进入生产阶段。
持续交付可以看作持续集成的下一步。它强调的是，不管怎么更新，软件是随时随地可以交付的。

#### 持续部署
持续部署（continuous deployment）是持续交付的下一步，指的是代码通过评审以后，自动部署到生产环境。

持续部署的目标是，代码在任何时刻都是可部署的，可以进入生产阶段。

#### 流程
根据持续集成的设计，代码从提交到生产，整个过程有以下几步。
##### （1）提交
流程的第一步，是开发者向代码仓库提交代码。所有后面的步骤都始于本地代码的一次提交（commit）。

##### （2）测试（第一轮）
代码仓库对commit操作配置了钩子（hook），只要提交代码或者合并进主干，就会跑自动化测试。
测试有好几种。
- 单元测试：针对函数或模块的测试
- 集成测试：针对整体产品的某个功能的测试，又称功能测试
- 端对端测试：从用户界面直达数据库的全链路测试

##### (3) 构建
通过第一轮测试，代码就可以合并进主干，就算可以交付了。
交付后，就先进行构建（build），再进入第二轮测试。所谓构建，指的是将源码转换为可以运行的实际代码，比如安装依赖，配置各种资源（样式表、JS脚本、图片）等等。
常用的构建工具如下。
- Jenkins
- Travis
- Codeship
- Strider

##### (4) 测试（第二轮）
构建完成，就要进行第二轮测试。如果第一轮已经涵盖了所有测试内容，第二轮可以省略，当然，这时构建步骤也要移到第一轮测试前面。

第二轮是全面测试，单元测试和集成测试都会跑，有条件的话，也要做端对端测试。所有测试以自动化为主，少数无法自动化的测试用例，就要人工跑。

需要强调的是，新版本的每一个更新点都必须测试到。如果测试的覆盖率不高，进入后面的部署阶段后，很可能会出现严重的问题。

##### (5) 部署
通过了第二轮测试，当前代码就是一个可以直接部署的版本（artifact）。将这个版本的所有文件打包（ tar filename.tar * ）存档，发到生产服务器。

##### (6) 回滚
一旦当前版本发生问题，就要回滚到上一个版本的构建结果。最简单的做法就是修改一下符号链接，指向上一个版本的目录。


## [Github Action](https://github.com/features/actions)

### GitHub Actions 是什么？

Github Actions是由Github创建的 CI/CD服务。 它的目的是使所有软件开发工作流程的自动化变得容易。 直接从GitHub构建，测试和部署代码。CI（持续集成）由很多操作组成，比如代码合并、运行测试、登录远程服务器，发布到第三方服务等等。GitHub 把这些操作就称为 actions。

很多操作在不同项目里面是类似的，完全可以共享。GitHub 允许开发者把每个操作写成独立的脚本文件，存放到代码仓库，使得其他开发者可以引用。

如果你需要某个 action，不必自己写复杂的脚本，直接引用他人写好的 action 即可，整个持续集成过程，就变成了一个 actions 的组合。这就是 GitHub Actions 最特别的地方。

GitHub 做了一个[GitHub Marketplace](https://github.com/marketplace?type=actions) ，可以搜索到他人提交的 actions。另外，还有一个[Awesome Actions](https://github.com/sdras/awesome-actions)的仓库，也可以找到不少 action。

#### 基础概念

GitHub Actions 有一些自己的术语。

- workflow （工作流程）：持续集成一次运行的过程。
- job （任务）：一个 workflow 由一个或多个 job 构成，含义是一次持续集成的运行，可以完成多个任务。
- step（步骤）：每个 job 由多个 step 构成，一步步完成。
- action （动作）：每个 step 可以依次执行一个或多个命令（action）。

#### 虚拟环境
GitHub Ac­tions 为每个任务 (job) 都提供了一个虚拟机来执行，每台虚拟机都有相同的硬件资源：
- 2-core CPU,  7 GB RAM 内存, 14 GB SSD 硬盘空间
- 硬盘总容量为90G左右，可用空间为30G左右，评测详见：《GitHub Actions 虚拟服务器环境简单评测》

使用限制：
- 每个仓库只能同时支持20个 workflow 并行。
- 每小时可以调用1000次 GitHub API 。
- 每个 job 最多可以执行6个小时。
- 免费版的用户最大支持20个 job 并发执行，macOS 最大只支持5个。
- 私有仓库每月累计使用时间为2000分钟，超过后$ 0.008/分钟，公共仓库则无限制。
- 操作系统方面可选择 Win­dows server、Linux、ma­cOS，并预装了大量软件包和工具。

>TIPS： 虽然名称叫持续集成，但当所有任务终止和完成时，虚拟环境内的数据会随之清空，并不会持续。即每个新任务都是一个全>新的虚拟环境。


#### workflow 文件

GitHub Ac­tions 的配置文件叫做 work­flow 文件，存放在代码仓库的`.github/workflows` 目录中。

work­flow 文件采用 YAML 格式，文件名可以任意取，但是后缀名统一为.yml，比如 `build.yml`。一个库可以有多个 work­flow 文件，GitHub 只要发现`.github/workflows` 目录里面有`.yml` 文件，就会按照文件中所指定的触发条件在符合条件时自动运行该文件中的工作流程。

在 Ac­tions 页面可以看到很多种语言的 work­flow 文件的模版，可以用于简单的构建与测试。下面是一个简单的 work­flow 文件示例：

```sh
name: Hello World
on: push
jobs:
  my_first_job:
    name: My first job
    runs-on: ubuntu-latest
    steps:
    - name: checkout
      uses: actions/checkout@master
    - name: Run a single-line script
      run: echo "Hello World!"
  my_second_job:
    name: My second job
    runs-on: macos-latest
    steps:
    - name: Run a multi-line script
      env:
        MY_VAR: Hello World!
        MY_NAME: P3TERX
      run: |
        echo $MY_VAR
        echo My name is $MY_NAME
```

#### workflow 语法

##### (1) name

name 字段是 work­flow 的名称。若忽略此字段，则默认会设置为 work­flow 文件名。

```sh
name: GitHub Actions Demo
```
##### (2) on
on 字段指定 work­flow 的触发条件，通常是某些事件，比如示例中的触发事件是 push，即在代码 push 到仓库后被触发。on 字段也可以是事件的数组，多种事件触发，比如在 push 或 pull_request 时触发：
```sh
on: [push, pull_request]
```
- push 指定分支触发
```sh
on:
  push:
    branches:
      - master
```
- push tag 时触发
```sh
on:
  push:
    tags:
    - 'v*'
```

完整的事件列表，请查看[官方文档](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)。除了代码库事件，GitHub Actions 也支持外部事件触发，或者定时运行。

##### (3) jobs
jobs 表示要执行的一项或多项任务。每一项任务必须关联一个 ID (job_id)，比如示例中的 my_first_job 和 my_second_job。job_id 里面的 name 字段是任务的名称。job_id 不能有空格，只能使用数字、英文字母和 - 或_符号，而 name 可以随意，若忽略 name 字段，则默认会设置为 job_id。

当有多个任务时，可以指定任务的依赖关系，即运行顺序，否则是同时运行。
```sh
jobs:
  job1:
  job2:
    needs: job1
  job3:
    needs: [job1, job2]
```

上面代码中，job1 必须先于 job2 完成，而 job3 等待 job1 和 job2 的完成才能运行。因此，这个 work­flow 的运行顺序依次为：job1、job2、job3。

##### (4) runs-on
```sh
runs-on: ubuntu-18.04
```
runs-on 字段指定任务运行所需要的虚拟服务器环境，是必填字段，目前可用的虚拟机如下：

|虚拟环境        |	YAML workflow 标签|
|:----------------------:|:--------------------:|
|Windows Server 2019|	windows-latest|
|Ubuntu 18.04|	ubuntu-latest or ubuntu-18.04|
|Ubuntu 16.04|	ubuntu-16.04|
|macOS X Catalina 10.15|	macos-latest|


##### （5）steps
steps 字段指定每个任务的运行步骤，可以包含一个或多个步骤。步骤开头使用 - 符号。每个步骤可以指定以下字段:

  - name：步骤名称。
  - uses：该步骤引用的action或 Docker 镜像。
  - run：该步骤运行的 bash 命令。
  - env：该步骤所需的环境变量。
其中 uses 和 run 是必填字段，每个步骤只能有其一。同样名称也是可以忽略的。


#### action
action 是 GitHub Ac­tions 中的重要组成部分，这点从名称中就可以看出，actions 是 action 的复数形式。它是已经编写好的步骤脚本，存放在 GitHub 仓库中。

对于初学者来说可以直接引用其它开发者已经写好的 action，可以在官方 action 仓库或者 [GitHub Marketplace](https://github.com/marketplace?type=actions) 去获取。此外 [Awesome Actions](https://github.com/sdras/awesome-actions) 这个项目收集了很多非常不错的 action。
既然 action 是代码仓库，当然就有版本的概念。引用某个具体版本的 action：
```sh
steps:
  - uses: actions/setup-node@74bc508 # 指定一个 commit
  - uses: actions/setup-node@v1.2    # 指定一个 tag
  - uses: actions/setup-node@master  # 指定一个分支
```

## [Git hooks](https://githooks.com)
### 1. 什么是 Git hooks


Git hooks 是 Git 在事件之前或之后执行的脚本, 用于控制 git 工作的流程。`Git hooks` 脚本对于我们提交`code review` 之前识别一些简单的问题很有用。 我们在每次提交代码时都会触发这些 hooks，以自动指出代码中的问题，例如缺少分号，尾随空白和调试语句。通过在`code review` 之前指出这些问题，代码审阅者可以专注于代码结构和功能的更改，而不需要浪费时间来审查这些格式问题。

Git hooks 分为客户端钩子和服务端钩子。客户端钩子由诸如提交和合并这样的操作所调用，而服务器端钩子作用于诸如接收被推送的提交这样的联网操作。

客户端钩子：`pre-commit`、`prepare-commit-msg`、`commit-msg`、`post-commit`等，主要用于控制客户端 git 的提交和合并这样的操作。

服务端钩子：pre-receive、post-receive、update，主要在服务端接收提交对象时、推送到服务器之前调用。

- pre-commit: Check the commit message for spelling errors.
- pre-receive: Enforce project coding standards.
- post-commit: Email/SMS team members of a new commit.
- post-receive: Push the code to production.

### 2. Git hooks 如何工作？

每个Git存储库都有一个`.git/hooks`文件夹，其中包含可以绑定到的每个钩子的脚本。您可以根据需要随意更改或更新这些脚本，Git将在这些事件发生时执行它们。进去`.git/hooks` 后会看到一些 `hooks` 的官方示例，他们都是以`.sample`结尾的文件名。

注意这些以`.sample`结尾的示例脚本是不会执行的，如果你想启用它们，得先移除这个后缀。

例如下面的文件列表是 `git init` 在 `.git/hooks` 文件夹下自动创建的 `hooks` 方法。

```python
-rwxrwxr-x 1 robin robin  478 Jun  1 17:54 applypatch-msg.sample*
-rwxrwxr-x 1 robin robin  896 Jun  1 17:54 commit-msg.sample*
-rwxrwxr-x 1 robin robin  189 Jun  1 17:54 post-update.sample*
-rwxrwxr-x 1 robin robin  424 Jun  1 17:54 pre-applypatch.sample*
-rwxrwxr-x 1 robin robin 1642 Jun  1 17:54 pre-commit.sample*
-rwxrwxr-x 1 robin robin 1239 Jun  1 17:54 prepare-commit-msg.sample*
-rwxrwxr-x 1 robin robin 1348 Jun  1 17:54 pre-push.sample*
-rwxrwxr-x 1 robin robin 4898 Jun  1 17:54 pre-rebase.sample*
-rwxrwxr-x 1 robin robin 3610 Jun  1 17:54 update.sample*
```

例如下面的文件列表中多了一个 `pre-commit` 的文件， 是我添加的用于代码检查的 `pre-commit hook`方法。

```python
-rwxrwxr-x 1 robin robin  478 Sep  7 10:25 applypatch-msg.sample*
-rwxrwxr-x 1 robin robin  896 Sep  7 10:25 commit-msg.sample*
-rwxrwxr-x 1 robin robin  189 Sep  7 10:25 post-update.sample*
-rwxrwxr-x 1 robin robin  424 Sep  7 10:25 pre-applypatch.sample*
-rwxrwxr-x 1 robin robin 1475 Sep  8 20:13 pre-commit*
-rwxrwxr-x 1 robin robin 1642 Sep  7 10:25 pre-commit.sample*
-rwxrwxr-x 1 robin robin 1239 Sep  7 10:25 prepare-commit-msg.sample*
-rwxrwxr-x 1 robin robin 1348 Sep  7 10:25 pre-push.sample*
-rwxrwxr-x 1 robin robin 4898 Sep  7 10:25 pre-rebase.sample*
-rwxrwxr-x 1 robin robin 3610 Sep  7 10:25 update.sample*
```

### 3.[pre-commit](https://pre-commit.com) 简介

`pre-commit`是客户端hooks之一，`pre-commit` 在 `git add`提交之后，然后执行 `git commit` 时执行, 实现对代码的审查。 脚本执行没报错就继续提交，反之就驳回提交的操作。

这个钩子脚本可用于处理简单问题：对将要提交的代码进行检查、优化代码格式, 例如检查是字符数是否超出限制，尾随空格和调试语句等。

Git钩子。我们在每次提交时运行我们的钩子，以。本文以python 项目为例。



#### (1).安装
```python
## 使用 pip 安装:
pip install pre-commit
```
#### (2). 配置
在项目根目录填加 `.pre-commit-config.yaml` 文件, 这里以 `mmdetection` 的配置文件为例来做说明：
```python
repos:
  - repo: https://gitlab.com/pycqa/flake8.git
    rev: 3.8.3
    hooks:
      - id: flake8
  - repo: https://github.com/asottile/seed-isort-config
    rev: v2.2.0
    hooks:
      - id: seed-isort-config
  - repo: https://github.com/timothycrosley/isort
    rev: 4.3.21
    hooks:
      - id: isort
  - repo: https://github.com/pre-commit/mirrors-yapf
    rev: v0.30.0
    hooks:
      - id: yapf
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v3.1.0
    hooks:
      - id: trailing-whitespace
      - id: check-yaml
      - id: end-of-file-fixer
      - id: requirements-txt-fixer
      - id: double-quote-string-fixer
      - id: check-merge-conflict
      - id: fix-encoding-pragma
        args: ["--remove"]
      - id: mixed-line-ending
        args: ["--fix=lf"]
  - repo: https://github.com/myint/docformatter
    rev: v1.3.1
    hooks:
      - id: docformatter
        args: ["--in-place", "--wrap-descriptions", "79"]
```

其中 flake8 根据 flake8 给出的代码规则检查代码.

#### (3). 安装 git hook scripts
```python
# pre-commit install
pre-commit install
# pre-commit installed at .git/hooks/pre-commit
```
第一次 pre-commit 运行时，将会自动下载、安装并且运行 hook。安装完成之后，`pre-commit` 将会在每次运行`git commit`命令时自动执行。 注意： 每次 clone 代码后，都需要执行 `pre-commit install`。

#### (4). 手动触发
第一次，需要触发全部：

```python
(pytorch) robin@robin-Z390-UD:~/jianzh/ApulisVision$ pre-commit run --all-files
flake8...................................................................Passed
seed isort known_third_party.............................................Passed
isort....................................................................Passed
yapf.....................................................................Passed
Trim Trailing Whitespace.................................................Failed
- hook id: trailing-whitespace
- exit code: 1
- files were modified by this hook

Fixing docs/GithubAction.md

Check Yaml...............................................................Passed
Fix End of Files.........................................................Passed
Fix requirements.txt.....................................................Passed
Fix double quoted strings................................................Passed
Check for merge conflicts................................................Passed
Fix python encoding pragma...............................................Passed
Mixed line ending........................................................Passed
docformatter.............................................................Passed
```
可以看到， 我的文档中， 存在一些 `trailing whitespace`

#### (5). 支持语言
```python
docker
docker_image
fail
golang
node
python
python_venv
ruby
rust
swift
pcre
pygrep
script
system
```
