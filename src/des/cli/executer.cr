require "ecr"
require "colorize"

module Des
  module Cli
    class Executer
      getter writer

      def initialize(
        @des_options : Des::Options::Options,
        @file_creator : Des::Cli::FileCreator,
        @des_rc_file : Des::SettingFile::DesRcFile,
        @dockerfile : Des::SettingFile::Dockerfile,
        @makefile : Des::SettingFile::Makefile,
        @docker_compose : Des::SettingFile::DockerCompose,
        @nginx_conf : Des::SettingFile::NginxConf,
        @writer : IO = STDOUT
      )
      end

      def execute
        if @des_options.desrc
          @writer.puts ""
          @writer.puts "File path: #{@des_options.rc_file}"
          @writer.puts ""
          @writer.puts "#{File.read(@des_options.rc_file)}"
          exit 0
        end

        unless File.exists?(@des_options.rc_file)
          @file_creator.create(@des_rc_file.build_file_create_info)
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
