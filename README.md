# des

CLI to create Docker Environment Setting files.

If you have a script you want to run in the docker environment, you can quickly build a docker environment.

## Installation

TODO

## Usage

For example, you have a crystal code you want to run. However, crystal is not installed. In that case, use 'des'.

```
$ ls
sample.cr

$ cat sample.cr
puts "I want to run this crystal code."

$ des --image=crystallang/crystal --container=my_crystal_container
Create ./Dockerfile
Create ./Makefile
Create ./docker-compose.yml
```

`Dockerfile`, `Makefile` and `docker-compose.yml` are created. Next, run `make setup`.

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

The docker environment is built. Next, run `make attach`.

```
$ make attach
docker exec -it my_crystal_container /bin/bash
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
root@da6f8953e270:~/my_crystal_container#
```

A directory on the host side is mounted and a crystal environment is also built. You can run the your script.

```
root@xxxxxxxxx:~/my_crystal_container# crystal run sample.cr
I want to run this crystal code.
```

## Development

TODO: Write development instructions here

## Contributing

1. Fork it ( https://github.com/[your-github-name]/des/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [[your-github-name]](https://github.com/[your-github-name]) at-grandpa - creator, maintainer
