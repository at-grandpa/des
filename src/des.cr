require "./des/*"
require "clim"

module Des
  class Cli < Clim
    main_command
    desc "Creates docker environment skeleton."
    usage "des [options] project_name"
    string "-i IMAGE", "--image=IMAGE", desc: "Base docker image name.", default: "ubuntu:16.04"
    string "-m VERSION", "--mysql=VERSION", desc: "Add mysql container with version specified."
    string "-n VERSION", "--nginx=VERSION", desc: "Add nginx container with version specified."
    array "-p PACKAGE", "--package=PACKAGE", desc: "apt-get install package name.", default: [] of String
    run do |opts, args|
    end
  end
end

Des::Cli.start(ARGV)
