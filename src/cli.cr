require "./des"

module Des
  class Cli < Clim
    main_command
    desc "Creates docker environment skeleton."
    usage "des [options]"
    string "-i IMAGE", "--image=IMAGE",          desc: "Base docker image name.",                     default: "ubuntu:16.04"
    array  "-p PACKAGES", "--packages=PACKAGE",  desc: "apt-get install packages name.",              default: [] of String
    string "-c NAME", "--container=NAME",        desc: "Container name.",                             default: "my_container"
    string "-d SAVE_DIR", "--save-dir=SAVE_DIR", desc: "Save dir path.",                              default: "."
    string "-r RC_FILE", "--rc-file=RC_FILE",    desc: ".descr.yml path.",                            default: "~/.desrc.yml"
    bool   "-w", "--web-app",                    desc: "Web app version. (Includes nginx and mysql)", default: false
    run do |opts, args|

      opts = Opts.new(opts)

      rc_file_yaml_str = File.read(opts.rc_file)
      rc = Rc.new(rc_file_yaml_str)

      parameters = Parameters.new(rc, opts)

      Dockerfile.new(parameters).create_file
      Makefile.new(parameters).create_file
      DockerCompose.new(parameters).create_file

    end
  end
end

Des::Cli.start(ARGV)
