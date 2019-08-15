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
      option "-d DESRC_PATH", "--desrc-path=DESRC_PATH", type: String, desc: ".descr.yml path."
      option "--docker-compose-version=VERSION", type: String, desc: "docker-compose version."
      option "-w FLAG", "--web-app=FLAG", type: String, desc: "Web app mode(true or false). Includes nginx and mysql."
      option "-o FLAG", "--overwrite=FLAG", type: String, desc: "Overwrite each file flag(true or false)."
      version "des #{Des::VERSION}", short: "-v"
      help short: "-h"
      run do |library_opts, args|
        cli_options = {
          image:                  library_opts.image,
          packages:               library_opts.packages,
          container:              library_opts.container,
          save_dir:               library_opts.save_dir,
          desrc_path:             library_opts.desrc_path,
          docker_compose_version: library_opts.docker_compose_version,
          web_app:                library_opts.web_app,
          overwrite:              library_opts.overwrite,
        }

        if cli_options[:desrc]
          puts ""
          puts "File path: #{cli_options[:desrc_path]}"
          puts ""
          puts "#{File.read(cli_options[:desrc_path])}"
          exit 0
        end

        unless File.exists?(cli_options[:desrc_path])
          desrc_file = Des::SettingFile::DesrcFile.new(
            Des::Options::Options.new(
              Des::Options::CliOptions.new(cli_options),
              Des::Options::DesrcFileOptions.new("")
            )
          )
          Des::Cli::FileCreator.new(desrc_file.build_file_create_info).create
        end

        des_options = Des::Options::Options.new(
          Des::Options::CliOptions.new(cli_options),
          Des::Options::DesrcFileOptions.new(
            File.read(cli_options[:desrc_path])
          )
        )

        dockerfile = Des::SettingFile::Dockerfile.new(des_options)
        Des::Cli::FileCreator.new(dockerfile.build_file_create_info).create

        makefile = Des::SettingFile::Makefile.new(des_options)
        Des::Cli::FileCreator.new(makefile.build_file_create_info).create

        docker_compose = Des::SettingFile::DockerCompose.new(des_options)
        Des::Cli::FileCreator.new(docker_compose.build_file_create_info).create

        if options.web_app
          nginx_conf = Des::SettingFile::NginxConf.new(des_options)
          Des::Cli::FileCreator.new(nginx_conf.build_file_create_info).create
        end
      end
    end
  end
end

Des::MainCli.start(ARGV)
