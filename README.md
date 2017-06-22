# des

CLI to create Docker Environment Setting files.

If you have a script you want to run in the docker environment, you can quickly build a docker environment.

[![Build Status](https://travis-ci.org/at-grandpa/des.svg?branch=master)](https://travis-ci.org/at-grandpa/des)

## Installation

#### homebrew
```
$ brew tap at-grandpa/homebrew-des
$ brew install des
```

#### git clone
```
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
Crystal 0.22.0 [3c71228] (2017-04-20) LLVM 3.5.0
root@xxxxxxxxx:~/my_crystal_container#
```

You can run the your script.

```
root@xxxxxxxxx:~/my_crystal_container# crystal run sample.cr
I want to run this crystal code.
```

## Options

```
$ des -h

  Creates docker environment setting files.

    - Dockerfile
    - Makefile
    - docker-compose.yml

  Usage:

    des [options]

  Options:

    -h, --help                       Show this help.
    -i IMAGE, --image=IMAGE          Base docker image name.
    -p PACKAGES, --packages=PACKAGE  apt-get install packages name.
    -c NAME, --container=NAME        Container name.
    -d SAVE_DIR, --save-dir=SAVE_DIR Save dir path.
    -r RC_FILE, --rc-file=RC_FILE    .descr.yml path.  [default:~/.desrc.yml]
    -w, --web-app                    Web app mode. (Includes nginx and mysql.)
    -o, --overwrite                  Overwrite each file.
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
  web_app: false
  overwrite: false
```

## Development

```
$ make spec
```

## Contributing

1. Fork it ( https://github.com/at-grandpa/des/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [at-grandpa](https://github.com/at-grandpa) at-grandpa - creator, maintainer
