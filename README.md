# des

CLI to create **D**ocker **E**nvironment **S**etting files.

If you have a script you want to run in the docker environment, you can quickly build a docker environment.

[![Build Status](https://travis-ci.org/at-grandpa/des.svg?branch=master)](https://travis-ci.org/at-grandpa/des)

## Installation

### homebrew

```shell
brew update
brew install crystal-lang
brew tap at-grandpa/homebrew-des
brew install des
```

### git clone

```shell
brew update
brew install crystal-lang
git clone https://github.com/at-grandpa/des.git
cd des
sudo make install
```

## Usage

For example, you have a crystal code you want to run. However, crystal is not installed. In that case, use `des`.

```shell
$ ls
sample.cr

$ cat sample.cr
puts "I want to run this crystal code."

$ crystal -v
bash: crystal: command not found

$ des --image=crystallang/crystal --container=my_crystal_container
Create /your/home/.desrc.yml
Create ./Dockerfile
Create ./Makefile
Create ./docker-compose.yml
```

`Dockerfile`, `Makefile` and `docker-compose.yml` are created.

Next, run `make setup`. The docker environment is built.

```shell
$ make setup
docker-compose -f ./docker-compose.yml build
Building app
Step 1/5 : FROM crystallang/crystal

...

Successfully built xxxxxxxxxx
docker-compose -f ./docker-compose.yml up -d
Creating network "destest_default" with the default driver
Creating my_crystal_container
$
```

Next, run `make attach`. You can attach the docker container.

```shell
$ make attach
docker exec -it my_crystal_container /bin/bash
root@xxxxxxxxx:~/my_crystal_container#
```

This container is in the following state.

* The current directory of the host machine is mounted.
* Created from the specified image. (In this example, `crystallang/crystal`)

```shell
root@xxx:~/my_crystal_container# ls -la
Dockerfile  Makefile  docker-compose.yml  sample.cr
root@xxx:~/my_crystal_container# crystal -v
Crystal 0.30.1 [5e6a1b672] (2019-08-12)

LLVM: 4.0.0
Default target: x86_64-unknown-linux-gnu
root@xxx:~/my_crystal_container#
```

You can run the your script.

```shell
root@xxx:~/my_crystal_container# crystal run sample.cr
I want to run this crystal code.
```

## Command Options

```shell
$ des --help

  Creates docker environment setting files.

    - Dockerfile
    - Makefile
    - docker-compose.yml

  Usage:

    des [options]

  Options:

    -i IMAGE, --image=IMAGE          Base docker image name. [type:String]
    -p PACKAGES, --packages=PACKAGE  apt-get install packages name. [type:Array(String)]
    -c NAME, --container=NAME        Container name. [type:String]
    -s SAVE_DIR, --save-dir=SAVE_DIR Save dir path. [type:String]
    -d VERSION, --docker-compose-version=VERSION
                                     docker-compose version. [type:String]
    -w FLAG, --web-app=FLAG          Web app mode(true or false). Includes nginx and mysql. [type:String]
    -o FLAG, --overwrite=FLAG        Overwrite each file flag(true or false). [type:String]
    -h, --help                       Show this help.
    -v, --version                    Show version.

  Sub Commands:

    desrc   Creates/Update/Display desrc file.

```

## Sub Commands

```shell
$ des desrc -h

  Creates/Update/Display desrc file.

  Usage:

    des desrc [sub_command]

  Options:

    -h, --help                       Show this help.

  Sub Commands:

    create, update   Create or Update desrc file.
    display          Display desrc file.

```

```shell
$ des desrc update -i ubuntu:18.04 -c example_container -w true

path: /your/home/.desrc.yml

default_options:
  image: ubuntu:18.04
  packages: []
  container: example_container
  save_dir: .
  docker_compose_version: 3
  web_app: true
  overwrite: false


/your/home/.desrc.yml
Overwrite? (y or n) > y
Overwrite /your/home/.desrc.yml
$
```

```shell
$ des desrc display

path: /your/home/.desrc.yml

default_options:
  image: ubuntu:18.04
  packages: []
  container: example_container
  save_dir: .
  docker_compose_version: 3
  web_app: true
  overwrite: false

$
```

## .desrc.yml

Write the default option values of the command in this file. It is placed at `~/.desrc.yml` by default.

```yaml
default_options:
  image: ubuntu:18.04
  packages:
    - curl
    - vim
  container: my_container
  save_dir: .
  docker_compose_version: 3
  web_app: true
  overwrite: false
```

## Default options

If neither cli nor .desrc.yml has an option, the following options are used by default. Therefore, the priority is `cli options` > `.desrc.yml options` > `default options`.

```yaml
default_options:
  image: ubuntu:18.04
  packages: []
  container: my_container
  save_dir: .
  docker_compose_version: 3
  web_app: false
  overwrite: false
```

## Development

```shell
make spec
```

## Contributing

1. Fork it ( https://github.com/at-grandpa/des/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [at-grandpa](https://github.com/at-grandpa) at-grandpa - creator, maintainer
