# Template repositories

Templates Repository 是由 Apulis 算法研发团队维护的代码仓库模板， 可以帮助大家在所有项目中重用文件结构和部分代码。

## How to use
应用非常简单，该repo 已经被标记为 template，大家进入到此 Repo 主页， 点击`Use this template`就可以基于此生成新的 repo，且新 repo 具备 template repo 的所有文件和文件夹。下面是 template 的文件结构：
```sh
.github （文件夹）： github action 的相关配置
configs（文件夹）：相关的参数配置文件
data（文件夹）: 相关数据以及标注文件，如测试图片，可视化样例（不存放训练数据）
models（文件夹）：训练的网络配置，建议每个不同的网络分开写
utils（文件夹）：算法涉及的各种预处理后处理的函数，如nms处理函数
Dockerfile   : Docker file
.pre-commit-config.yaml  配置 pre-commit hook 的yaml文件
requriements.txt         使用该 repo 的第三方库
README.md
```

## Git 使用规范

### Git主要分支说明


| 分支名称 |功能描述|
| ----------- | -------------------------------------------------------------------- |
|Master | 主分支，维护发布产品的代码，存储了正式发布的历史|
|Develop	|开发分支，作为功能的集成分支，维护开发中的代码，代码最终要合入Master分支|
|Feature   |开自 Develop分支，主要用于开发新功能，开发者根据自己负责模块自行维护，模块开发完成并自测通过后，代码合入Develop分支，新功能提交应该从不直接与master分支交互， 命名规范为：feature/#...，每一个功能都应对应一个issue，...即为issue号. |
| Bugfix	 | 开自Develop分支或者Release分支，主要用于修复当前开发中的功能的已知bug；每一个已发现的bug都应该在gitlab中记录issue，并定期更新当前解决进展，如有有价值的思考或独特的解决方法, 命名规范为：bugfix/#...|
| Hotfix |	开自Master分支，主要用于修复当前已发布版本的已知bug；解决bug时注意事项参考Bugfix。这是唯一可以直接从master分支fork出来的分支。修复完成，修改应该马上合并回master分支和develop分支（当前的发布分支），master分支应该用新的版本号打好Tag。为Bug修复使用专门分支，让团队可以处理掉问题而不用打断其它工作或是等待下一个发布循环。你可以把它想成是一个直接在master分支上处理的临时发布。命名规范为：hotfix/#... |
| Release	| 开自Develop分支，主要用于发布版本，一旦develop分支上有了做一次发布（或者说快到了既定的发布日）的足够功能，就从develop分支上fork一个发布分支。新建的分支用于开始发布循环，所以从这个时间点开始之后新的功能不能再加到这个分支上 —— 这个分支只应该做Bug修复、文档生成和其它面向发布任务。一旦对外发布的工作都完成了，执行以下三个操作：合并Release分支到Master； 给Master打上对应版本的标签tag； Release回归，这些从新建发布分支以来的做的修改要合并回develop分支。 命名规范为：release/...，...为版本号|


### Git commit 规范

建议经常用命令"git status"查看当前所在分支并用"git log"查看当前分支记录，每次提交前与checkout分支时都先查看当前分支再进行下一步操作提交信息的说明，禁止无意义的日志语言，如modify，修改xxx文件等，任何修改都应该简要说明
##### Commit message格式
```sh
<type>: <subject>      注意冒号后面有空格
type
用于说明 commit 的类别，只允许使用下面7个标识
feat：新功能（feature）
fix：修补bug
docs：文档（documentation）
style： 格式（不影响代码运行的变动）
refactor：重构（即不是新增功能，也不是修改bug的代码变动）
test：增加测试
chore：构建过程或辅助工具的变动

subject
subject是 commit 目的的简短描述，不超过50个字符，且结尾不加句号（.）。
提交分支合并请求之前的基础原则，如本地编译通过、手工或者自动化验收的测试通过
```

## Code style

### Python
We adopt [PEP8](https://www.python.org/dev/peps/pep-0008/) as the preferred code style.

We use the following tools for linting and formatting:
- [flake8](http://flake8.pycqa.org/en/latest/): linter
- [yapf](https://github.com/google/yapf): formatter
- [isort](https://github.com/timothycrosley/isort): sort imports

Style configurations of yapf and isort can be found in [setup.cfg](../setup.cfg).

We use [pre-commit hook](https://pre-commit.com/) that checks and formats for `flake8`, `yapf`, `isort`, `trailing whitespaces`,
 fixes `end-of-files`, sorts `requirments.txt` automatically on every commit.
The config for a pre-commit hook is stored in [.pre-commit-config](../.pre-commit-config.yaml).

After you clone the repository, you will need to install initialize pre-commit hook.

```
pip install -U pre-commit
```

From the repository folder
```
pre-commit install
```

After this on every commit check code linters and formatter will be enforced.


>Before you create a PR, make sure that your code lints and is formatted by yapf.

### C++ and CUDA
We follow the [Google C++ Style Guide](https://google.github.io/styleguide/cppguide.html).

## Github Action

关于 Githb Action 的使用可以参考 [GithubAction](docs/GithubAction.md).
