require "./des/*"
require "clim"

module Des
  class Cli < Clim
    main_command
    desc "Creates docker environment skeleton."
    usage "des [options] container_name"
    string "-i IMAGE", "--image=IMAGE", desc: "Base docker image name.", default: "ubuntu:16.04"
    string "-m VERSION", "--mysql=VERSION", desc: "Add mysql container with version specified.", default: ""
    string "-n VERSION", "--nginx=VERSION", desc: "Add nginx container with version specified.", default: ""
    array "-p PACKAGES", "--packages=PACKAGE", desc: "apt-get install packages name.", default: [] of String, required: false
    run do |opts, args|
      container_name = Args.new(args).container_name
      Dockerfile.new(Rc.new, container_name, opts).create_file
      DockerCompose.new(container_name, opts).create_file
      Makefile.new(container_name, opts).create_file
    end
  end
end

Des::Cli.start(ARGV)
