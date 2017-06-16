require "./des/*"
require "clim"

module Des
  class Cli < Clim
    main_command
    desc "Creates docker environment skeleton."
    usage "des [options]"
    string "-i IMAGE", "--image=IMAGE", desc: "Base docker image name.", default: "ubuntu:16.04"
    string "-c CONTAINER_NAME", "--container-name=CONTAINER_NAME", desc: "Container name.", default: "my_container"
    string "-d SAVE_DIR", "--save-dir=SAVE_DIR", desc: "Save dir path.", default: "."
    string "-r RC_FILE", "--rc-file=RC_FILE", desc: ".descr.yml path.", default: "~/.desrc.yml"
    array "-p PACKAGES", "--packages=PACKAGE", desc: "apt-get install packages name.", default: [] of String, required: false
    string "--mysql=VERSION", desc: "Add mysql container with version specified.", default: ""
    string "--nginx=VERSION", desc: "Add nginx container with version specified.", default: ""
    run do |opts, args|
      Dockerfile.new(Rc.new, Opts.new(opts)).create_file
      DockerCompose.new(opts).create_file
      Makefile.new(opts).create_file
    end
  end
end

Des::Cli.start(ARGV)
