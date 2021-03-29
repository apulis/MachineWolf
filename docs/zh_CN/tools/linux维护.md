# 常用维护方法


* Generating a new SSH key and adding it to the ssh-agent

    [Refer](https://docs.github.com/en/github/authenticating-to-github/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

    `ssh-keygen -t ed25519 -C "your_email@example.com"`

* Adding your SSH key to the ssh-agent

    ```bash
    eval "$(ssh-agent -s)"
    sh-add ~/.ssh/id_ed25519
    ```

* Start the ssh-agent in the background.

    ```bash
    $ eval "$(ssh-agent -s)"
    > Agent pid 59566
    ```

* Add your SSH private key to the ssh-agent. If you created your key with a different name, or if you are adding an existing key that has a different name, replace id_ed25519 in the command with the name of your private key file.

    `$ ssh-add ~/.ssh/id_ed25519`