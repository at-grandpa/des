require "./des"
require "clim"

module Des
  class MainCli < Clim
    main do
      desc <<-DESC
      Creates docker environment setting files.

          - Dockerfile
          - Makefile
          - docker-compose.yml
      DESC

      usage "des [options]"
      option "-i IMAGE", "--image=IMAGE", type: String, desc: "Base docker image name."
      option "-p PACKAGES", "--packages=PACKAGE", type: Array(String), desc: "apt-get install packages name."
      option "-c NAME", "--container=NAME", type: String, desc: "Container name."
      option "-s SAVE_DIR", "--save-dir=SAVE_DIR", type: String, desc: "Save dir path."
      option "-r RC_FILE", "--rc-file=RC_FILE", type: String, desc: ".descr.yml path.", default: "#{File.expand_path("~")}/.desrc.yml"
      option "--docker-compose-version=VERSION", type: String, desc: "docker-compose version.", default: "3"
      option "-w", "--web-app", type: Bool, desc: "Web app mode. (Includes nginx and mysql.)"
      option "-o", "--overwrite", type: Bool, desc: "Overwrite each file."
      option "-d", "--desrc", type: Bool, desc: "Dispray .descr.yml setting."
      version "des #{Des::VERSION}", short: "-v"
      help short: "-h"
      run do |library_opts, args|
        cli_options = Des::CliOptions.new(
          image: library_opts.image,
          packages: library_opts.packages,
          container: library_opts.container,
          save_dir: library_opts.save_dir,
          rc_file: library_opts.rc_file,
          docker_compose_version: library_opts.docker_compose_version,
          web_app: library_opts.web_app,
          overwrite: library_opts.overwrite,
          desrc: library_opts.desrc
        )
        rc_file_path = cli_options.rc_file
        if !rc_file_path.nil? && !File.exists?(rc_file_path)
          DesrcYml.new(cli_options).create_file
        end

        if cli_options.desrc
          puts ""
          puts "File path: #{rc_file_path}"
          puts ""
          puts "#{File.read(rc_file_path)}"
          exit 0
        end

        des_opts = Opts.new(cli_options)

        rc_file_yaml_str = File.read(des_opts.rc_file)
        rc = Rc.from_yaml(rc_file_yaml_str)

        parameters = Parameters.new(rc, des_opts)

        Dockerfile.new(parameters).create_file
        Makefile.new(parameters).create_file
        DockerCompose.new(parameters).create_file
        NginxConf.new(parameters).create_file if parameters.web_app
      end
    end
  end
end

Des::MainCli.start(ARGV)
