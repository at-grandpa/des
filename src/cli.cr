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
    string "-s SAVE_DIR", "--save-dir=SAVE_DIR", desc: "Save dir path."
    string "-r RC_FILE", "--rc-file=RC_FILE", desc: ".descr.yml path.", default: "#{File.expand_path("~")}/.desrc.yml"
    string "--docker-compose-version=VERSION", desc: "docker-compose version.", default: "3"
    bool "-w", "--web-app", desc: "Web app mode. (Includes nginx and mysql.)"
    bool "-o", "--overwrite", desc: "Overwrite each file."
    bool "-d", "--desrc", desc: "Dispray .descr.yml setting.", default: false
    bool "-v", "--version", desc: "Show version.", default: false
    run do |opts, args|
      # Display version
      if opts["version"].as(Bool)
        puts "des #{Des::VERSION}"
        exit 0
      end

      rc_file_path = opts["rc-file"].as(String)
      if !rc_file_path.nil? && !File.exists?(rc_file_path)
        DesrcYml.new(opts).create_file
      end

      # Display rc_file
      if opts["desrc"].as(Bool)
        puts ""
        puts "File path: #{rc_file_path}"
        puts ""
        puts "#{File.read(rc_file_path)}"
        exit 0
      end

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
      command "version"
      desc "Show version."
      usage "des version"
      run do |opts, args|
        puts "des #{Des::VERSION}"
      end
    end
  end
end

Des::Cli.start(ARGV)
