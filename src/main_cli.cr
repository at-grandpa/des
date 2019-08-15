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
          docker_compose_version: library_opts.docker_compose_version,
          web_app:                library_opts.web_app,
          overwrite:              library_opts.overwrite,
        }

        des_options = ::Des::Options::Options.new(
          Des::Options::CliOptions.new(cli_options),
          Des::Options::DesrcFileOptions.new(desrc_file_str)
        )

        file_creator = Des::Cli::FileCreator.new

        desrc_file = Des::SettingFile::DesrcFile.new(des_options)
        dockerfile = Des::SettingFile::Dockerfile.new(des_options)
        makefile = Des::SettingFile::Makefile.new(des_options)
        docker_compose = Des::SettingFile::DockerCompose.new(des_options)
        nginx_conf = Des::SettingFile::NginxConf.new(des_options)

        executer = Des::Cli::Executer.new(
          des_options,
          file_creator,
          desrc_file,
          dockerfile,
          makefile,
          docker_compose,
          nginx_conf
        )

        executer.execute
      end
      sub "desrc" do
        desc "Creates or Display desrc file."
        usage "des desrc [sub_command]"
        help short: "-h"
        run do |library_opts, args|
          puts library_opts.help_string
        end
        sub "create" do
          desc "Creates desrc file."
          usage "des desrc create [options]"
          help short: "-h"
          run do |library_opts, args|
            puts "create!"
          end
        end
        sub "display" do
          desc "Display desrc file."
          usage "des desrc display"
          help short: "-h"
          run do |library_opts, args|
            # if @des_options.desrc
            # @writer.puts ""
            # @writer.puts "File path: #{@des_options.desrc_path}"
            # @writer.puts ""
            # @writer.puts "#{File.read(@des_options.desrc_path)}"
            # return
            # end
            puts "display!"
          end
        end
      end
    end
  end
end

Des::MainCli.start(ARGV)
