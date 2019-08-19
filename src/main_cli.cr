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
      option "-d VERSION", "--docker-compose-version=VERSION", type: String, desc: "docker-compose version."
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
          docker_compose_version: library_opts.docker_compose_version,
          web_app:                library_opts.web_app,
          overwrite:              library_opts.overwrite,
        }

        file_creator = Des::Cli::FileCreator.new

        desrc_file_yaml_str = if File.exists?(Des::SettingFile::DesrcFile::DESRC_FILE_PATH)
                                File.read(Des::SettingFile::DesrcFile::DESRC_FILE_PATH)
                              else
                                ""
                              end

        des_options = Des::Options::Options.new(
          Des::Options::CliOptions.new(cli_options),
          Des::Options::DesrcFileOptions.from_yaml(desrc_file_yaml_str)
        )

        desrc_file = Des::SettingFile::DesrcFile.new(des_options)
        dockerfile = Des::SettingFile::Dockerfile.new(des_options)
        makefile = Des::SettingFile::Makefile.new(des_options)
        docker_compose = Des::SettingFile::DockerCompose.new(des_options)
        nginx_conf = Des::SettingFile::NginxConf.new(des_options)

        executer = Des::Cli::Executer.new(file_creator)
        executer.create(des_options, desrc_file, dockerfile, makefile, docker_compose, nginx_conf)
      rescue ex : Des::DesException
        puts "ERROR: #{ex.message}"
      end

      sub "desrc" do
        desc "Creates/Update/Display desrc file."
        usage "des desrc [sub_command]"
        help short: "-h"
        run do |library_opts, args|
          puts library_opts.help_string
        end
        sub "create" do
          desc "Create or Update desrc file."
          alias_name "update"
          usage "des desrc create [options]"
          option "-i IMAGE", "--image=IMAGE", type: String, desc: "Base docker image name."
          option "-p PACKAGES", "--packages=PACKAGE", type: Array(String), desc: "apt-get install packages name."
          option "-c NAME", "--container=NAME", type: String, desc: "Container name."
          option "-s SAVE_DIR", "--save-dir=SAVE_DIR", type: String, desc: "Save dir path."
          option "-d VERSION", "--docker-compose-version=VERSION", type: String, desc: "docker-compose version."
          option "-w FLAG", "--web-app=FLAG", type: String, desc: "Web app mode(true or false). Includes nginx and mysql."
          option "-o FLAG", "--overwrite=FLAG", type: String, desc: "Overwrite each file flag(true or false)."
          help short: "-h"
          run do |library_opts, args|
            cli_options = {
              image:                  library_opts.image,
              packages:               library_opts.packages,
              container:              library_opts.container,
              save_dir:               library_opts.save_dir,
              docker_compose_version: library_opts.docker_compose_version,
              web_app:                library_opts.web_app,
              overwrite:              library_opts.overwrite,
            }

            file_creator = Des::Cli::FileCreator.new

            desrc_file_yaml_str = if File.exists?(Des::SettingFile::DesrcFile::DESRC_FILE_PATH)
                                    File.read(Des::SettingFile::DesrcFile::DESRC_FILE_PATH)
                                  else
                                    ""
                                  end

            des_options = ::Des::Options::Options.new(
              Des::Options::CliOptions.new(cli_options),
              Des::Options::DesrcFileOptions.from_yaml(desrc_file_yaml_str)
            )

            desrc_file = Des::SettingFile::DesrcFile.new(des_options)
            executer = Des::Cli::Executer.new(file_creator)
            executer.create(desrc_file)
          rescue ex : Des::DesException
            puts "ERROR: #{ex.message}"
          end
        end
        sub "display" do
          desc "Display desrc file."
          usage "des desrc display"
          help short: "-h"
          run do |library_opts, args|
            file_creator = Des::Cli::FileCreator.new
            executer = Des::Cli::Executer.new(file_creator)
            executer.display_desrc_file(Des::SettingFile::DesrcFile::DESRC_FILE_PATH)
          rescue ex : Des::DesException
            puts "ERROR: #{ex.message}"
          end
        end
      end
    end
  end
end

Des::MainCli.start(ARGV)
