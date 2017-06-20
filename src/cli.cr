require "./des"

module Des
  class Cli < Clim
    main_command

    desc <<-DESC
    Creates docker environment setting files.

        - Dockerfile
        - Makefile
        - docker-compose.yml
    DESC

    usage "des [options]"
    string "-i IMAGE", "--image=IMAGE", desc: "Base docker image name."
    array "-p PACKAGES", "--packages=PACKAGE", desc: "apt-get install packages name."
    string "-c NAME", "--container=NAME", desc: "Container name."
    string "-d SAVE_DIR", "--save-dir=SAVE_DIR", desc: "Save dir path."
    string "-r RC_FILE", "--rc-file=RC_FILE", desc: ".descr.yml path.", default: "~/.desrc.yml"
    bool "-w", "--web-app", desc: "Web app mode. (Includes nginx and mysql)"
    bool "-o", "--overwrite", desc: "Overwrite each file."
    run do |opts, args|
      opts = Opts.new(opts)

      rc_file_yaml_str = File.read(opts.rc_file)
      rc = Rc.new(rc_file_yaml_str)

      parameters = Parameters.new(rc, opts)

      Dockerfile.new(parameters).create_file
      Makefile.new(parameters).create_file
      DockerCompose.new(parameters).create_file
      NginxConf.new(parameters).create_file if parameters.web_app
    end

    sub do
      command "rcfile"
      desc "Create default run commands file '.desrc.yml'."
      usage "des rcfile [options]"
      string "-d SAVE_DIR", "--save-dir=SAVE_DIR", desc: "Save dir path.", default: File.expand_path("~")
      bool "-o", "--overwrite", desc: "Overwrite file.", default: false
      run do |opts, args|
        opts = Opts.new(opts)
        rc = Rc.new
        parameters = Parameters.new(rc, opts)
        # RcFile.new(parameters).create_file
      end
    end
  end
end

Des::Cli.start(ARGV)
