# des

CLI to create **D**ocker **E**nvironment **S**etting files.

If you have a script you want to run in the docker environment, you can quickly build a docker environment.

[![Build Status](https://travis-ci.org/at-grandpa/des.svg?branch=master)](https://travis-ci.org/at-grandpa/des)

## Installation

#### homebrew
```
$ brew update
$ brew install crystal-lang
$ brew tap at-grandpa/homebrew-des
$ brew install des
```

#### git clone
```
$ brew update
$ brew install crystal-lang
$ git clone https://github.com/at-grandpa/des.git
$ cd des
$ make install
```

## Usage

For example, you have a crystal code you want to run. However, crystal is not installed. In that case, use `des`.

```
$ ls
sample.cr

$ cat sample.cr
puts "I want to run this crystal code."

$ crystal -v
bash: crystal: command not found

$ des --image=crystallang/crystal --container=my_crystal_container
Create ./Dockerfile
Create ./Makefile
Create ./docker-compose.yml
```

`Dockerfile`, `Makefile` and `docker-compose.yml` are created.

Next, run `make setup`. The docker environment is built.

```
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

```
$ make attach
docker exec -it my_crystal_container /bin/bash
root@xxxxxxxxx:~/my_crystal_container#
```

This container is in the following state.

* The current directory of the host machine is mounted.
* Created from the specified image. (In this example, `crystallang/crystal`)

```
root@xxxxxxxxx:~/my_crystal_container# ls -la
total 20
drwxr-xr-x 6 root root  204 Jun 21 00:18 .
drwx------ 3 root root 4096 Jun 21 00:22 ..
-rw-r--r-- 1 root root  139 Jun 21 00:18 Dockerfile
-rw-r--r-- 1 root root  365 Jun 21 00:18 Makefile
-rw-r--r-- 1 root root  199 Jun 21 00:18 docker-compose.yml
-rw-r--r-- 1 root root   40 Jun 21 00:16 sample.cr
root@xxxxxxxxx:~/my_crystal_container# crystal -v
Crystal 0.23.1 [e2a1389] (2017-07-13) LLVM 3.8.1
root@xxxxxxxxx:~/my_crystal_container#
```

You can run the your script.

```
root@xxxxxxxxx:~/my_crystal_container# crystal run sample.cr
I want to run this crystal code.
```

## Options

```
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
    -r RC_FILE, --rc-file=RC_FILE    .descr.yml path. [type:String] [default:"/Users/y-tsuchida/.desrc.yml"]
    --docker-compose-version=VERSION docker-compose version. [type:String] [default:"3"]
    -w, --web-app                    Web app mode. (Includes nginx and mysql.) [type:Bool]
    -o, --overwrite                  Overwrite each file. [type:Bool]
    -d, --desrc                      Dispray .descr.yml setting. [type:Bool]
    -h, --help                       Show this help.
    -v, --version                    Show version.

```

## .desrc.yml

Write the default option values of the command in this file. It is placed at `~/.desrc.yml` by default.

```yaml
default_param:
  image: ubuntu:16.04
  packages:
    - curl
    - vim
  container: my_container
  save_dir: .
  docker_compose_version: 3
  web_app: false
  overwrite: false
```

## Development

```
$ crystal spec
```

## Contributing

1. Fork it ( https://github.com/at-grandpa/des/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [at-grandpa](https://github.com/at-grandpa) at-grandpa - creator, maintainer
