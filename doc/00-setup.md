# Setup you computer for OCaml

## Install VSCode

### About Windows

#### Win7, Win8

You need to use [Cygwin](https://www.cygwin.com/) in order to run OCaml.
Since those distributions are deprecated, trainings are not tested on those OS.

**I highly recommend to use the linux distribution that the university provides you.**

> You are accountable to make your environment work if you choose to use it despite this warning.

#### Win 10

You need to :

1. Install Windows Subsystem for Linux a.k.a [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
2. Install your [Linux distribution](https://docs.microsoft.com/en-us/windows/wsl/install-win10#step-6---install-your-linux-distribution-of-choice). If you're not accurate with linux you would install Ubuntu 20.
3. Install [vscode for WSL](https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-vscode)
4. Install OCaml Platform plugin : https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform

> If you have space in your username, you're doomed ¯\_(ツ)\_/¯ ; use Linux or try WSL2 (require a Windows Insider Program account)

### Ubuntu or Debian

1. Install terminator : `sudo apt-get install terminator`
2. Install Oh-My-Zsh : `sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

> If you encounter trouble about certificates when using `wget` you probably should install `ca-certificates` package : `sudo apt-get install ca-certificates`

3. Install vscode : https://code.visualstudio.com/docs/setup/linux#_debian-and-ubuntu-based-distributions
4. Install OCaml Platform plugin : https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform

> You may lack some tooling : `sudo apt install build-essential`

> You will need a libc >= 2.7. Check the version with `ldd --version`. If you have a version below 2.7, it means your distribution is too old, upgrade it or rebuild libc (advanced).

### macOS

1. Install iTerm2 : `brew cask install iterm2`
2. Install Oh-My-Zsh : `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
3. Install vscode : `brew cask install visual-studio-code`
4. Install OCaml Platform plugin : https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform

## Get the project

Choose one of thoose

### 1st solution (default): Local setup with vscode-docker

**This solution should be the default while you using a computer with x86_64 architecture (so neither an Apple M1 nor other ARM processors)**

1. Install Docker: https://code.visualstudio.com/docs/remote/containers#_system-requirements
2. On MacOS or Windows, start Docker Desktop.
3. Install vscode remote development plugin https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.vscode-remote-extensionpack
4. All projects come with `.devcontainer` folder. [Reopen the project in container](https://code.visualstudio.com/docs/remote/containers#_quick-start-open-an-existing-folder-in-a-container)

That's it ! 

### 2nd solution: Remote setup with Gitpod

**This solution is convenient if you work on old computer or from different computers**

1. Create a https://gitpod.io account
2. Install gitpod browser extension https://www.gitpod.io/docs/browser-extension
3. Create your workspace
4. You may develop inside your browser or install vscode gitpod plugin https://www.gitpod.io/docs/develop/vscode-desktop-support

That's it ! 

### 3rd solution: Local setup with esy.sh

**This solution should be the default if you are using a MacOS with M1 processor. In other case you are accountable to make it works with Windows + WSL or Linux, there is to many Linux and setup to maintain this doc for alls**

[esy.sh](https://esy.sh) is a rapid workflow for developing ReasonML or OCaml projects, inspired by npm.

- It provides an unique CLI to manage many tools
- It supports native packages hosted on [opam](http://opam.ocaml.org/) and [npm](https://www.npmjs.com/).
- It uses [Dune](https://dune.build/) build system.
- It eases the project settings with a main manifest `package.json`.
- It sandboxes dependencies per project;
- It simplifies Dune's configuration with [pesy](https://github.com/esy/pesy)

**We first need to install esy with npm**

#### Install node & npm

1. Install [NVM](https://github.com/nvm-sh/nvm#install--update-script) :

   - `wget -O- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash`

     OR

   - `curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh | bash`

2. Install node LTS : `nvm install --lts`
3. Update npm : `npm i -g npm`

#### Install esy

`npm i -g esy`

**Congratulation you're ready to start the Kata**

[Warm up your OCaml skills](./01-ocaml.md)
