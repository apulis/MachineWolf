# Diamond contributing guidelines


## Getting Started

- Fork the repository on [Github](https://github.com/apulis/PerfBoard)
- Read the [README.md](README.md) for project information and build instructions.

## Contribution Workflow

### Code style

Please follow this style to make diamond easy to review, maintain and develop.

* Coding guidelines

    The *Python* coding style suggested by [Python PEP 8 Coding Style](https://pep8.org/) and *C++* coding style suggested by [Google C++ Coding Guidelines](http://google.github.io/styleguide/cppguide.html) are used in diamond community.

* Unittest guidelines

    The *Python* unittest style suggested by [pytest](http://www.pytest.org/en/latest/) and *C++* unittest style suggested by [Googletest Primer](https://github.com/google/googletest/blob/master/googletest/docs/primer.md) are used in diamond community.

### Fork-Pull development model

* Fork diamond repository

    Before submitting code to diamond project, please make sure that this project have been forked to your own repository. It means that there will be parallel development between diamond repository and your own repository, so be careful to avoid the inconsistency between them.

* Clone the remote repository

    If you want to download the code to the local machine, `git` is the best way:
    ```shell
    # For GitHub
    git clone https://github.com/{insert_your_forked_repo}/PerfBoard.git
    git remote add upstream https://github.com/diamond-ai/PerfBoard.git
    # For Gitee
    git clone https://gitee.com/{insert_your_forked_repo}/PerfBoard.git
    git remote add upstream https://gitee.com/diamond/PerfBoard.git
    ```

* Develop code locally

    To avoid inconsistency between multiple branches, checking out to a new branch is `SUGGESTED`:
    ```shell
    git checkout -b {new_branch_name} origin/master
    ```

    Then you can change the code arbitrarily.

* Push the code to the remote repository

    After updating the code, you should push the update in the formal way:
    ```shell
    git add .
    git status # Check the update status
    git commit -m "Your commit title"
    git commit -s --amend #Add the concrete description of your commit
    git push origin {new_branch_name}
    ```

* Pull a request to diamond repository

    In the last step, your need to pull a compare request between your new branch and diamond `master` branch. After finishing the pull request, the Jenkins CI will be automatically set up for building test.

### Report issues

A great way to contribute to the project is to send a detailed report when you encounter an issue. We always appreciate a well-written, thorough bug report, and will thank you for it!

When reporting issues, refer to this format:

- What version of env (diamond, os, python etc) are you using?
- Is this a BUG REPORT or FEATURE REQUEST?
- What happened?
- What you expected to happen?
- How to reproduce it?(as minimally and precisely as possible)
- Special notes for your reviewers?

**Issues advisory:**

- **If you find an unclosed issue, which is exactly what you are going to solve,** please put some comments on that issue to tell others you would be in charge of it.
- **If an issue is opened for a while,** it's recommended for contributors to precheck before working on solving that issue.
- **If you resolve an issue which is reported by yourself,** it's also required to let others know before closing that issue.

### Propose PRs

* Raise your idea as an *issue* on [GitHub](https://github.com/apulis/PerfBoard/issues)
* If it is a new feature that needs lots of design details, a design proposal should also be submitted.
* After reaching consensus in the issue discussions and design proposal reviews, complete the development on the forked repo and submit a PR.
* None of PRs is not permitted until it receives **2+ LGTM** from approvers. Please NOTICE that approver is NOT allowed to add *LGTM* on his own PR.
* After PR is sufficiently discussed, it will get merged, abandoned or rejected depending on the outcome of the discussion.

**PRs advisory:**

- Any irrelevant changes should be avoided.
- Make sure your commit history being ordered.
- Always keep your branch up with the master branch.
- For bug-fix PRs, make sure all related issues being linked.
