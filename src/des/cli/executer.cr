require "ecr"
require "colorize"

module Des
  module Cli
    class Executer
      getter writer

      def initialize(
        @des_options : Des::Options::Options,
        @file_creator : Des::Cli::FileCreator,
        @desrc_file : Des::SettingFile::DesrcFile,
        @dockerfile : Des::SettingFile::Dockerfile,
        @makefile : Des::SettingFile::Makefile,
        @docker_compose : Des::SettingFile::DockerCompose,
        @nginx_conf : Des::SettingFile::NginxConf,
        @writer : IO = STDOUT
      )
      end

      def execute
        desrc_file_info = @desrc_file.build_file_create_info
        unless File.exists?(desrc_file_info.path)
          @file_creator.create(desrc_file_info)
        end

        @file_creator.create(@dockerfile.build_file_create_info)
        @file_creator.create(@makefile.build_file_create_info)
        @file_creator.create(@docker_compose.build_file_create_info)

        if @des_options.web_app
          @file_creator.create(@nginx_conf.build_file_create_info)
        end
      end
    end
  end
end
