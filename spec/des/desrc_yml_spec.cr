require "../spec_helper"

describe Des::DesrcYml do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create .desrc.yml.",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: ["curl", "vim"],
          container: nil,
          save_dir: nil,
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: ubuntu:16.04
          packages:
            - curl
            - vim
          container: my_container
          save_dir: .
          docker_compose_version: 3
          web_app: false
          overwrite: false
        EXPECT
      ),
      SpecCase.new(
        describe: "create .desrc.yml when opts has a 'image'.",
        cli_options: Des::CliOptions.new(
          image: "crystallang/crystal",
          packages: ["curl", "vim"],
          container: nil,
          save_dir: nil,
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: crystallang/crystal
          packages:
            - curl
            - vim
          container: my_container
          save_dir: .
          docker_compose_version: 3
          web_app: false
          overwrite: false
        EXPECT
      ),
      SpecCase.new(
        describe: "create .desrc.yml when opts has a 'packages'.",
        cli_options: Des::CliOptions.new(
          image: "crystallang/crystal",
          packages: ["wget", "htop"],
          container: nil,
          save_dir: nil,
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: crystallang/crystal
          packages:
            - wget
            - htop
          container: my_container
          save_dir: .
          docker_compose_version: 3
          web_app: false
          overwrite: false
        EXPECT
      ),
      SpecCase.new(
        describe: "create .desrc.yml when opts has a empty 'packages'.",
        cli_options: Des::CliOptions.new(
          image: "crystallang/crystal",
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: crystallang/crystal
          packages:
          container: my_container
          save_dir: .
          docker_compose_version: 3
          web_app: false
          overwrite: false
        EXPECT
      ),
      SpecCase.new(
        describe: "create .desrc.yml when opts has a 'container'.",
        cli_options: Des::CliOptions.new(
          image: "crystallang/crystal",
          packages: ["wget", "htop"],
          container: "spec_container",
          save_dir: nil,
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: crystallang/crystal
          packages:
            - wget
            - htop
          container: spec_container
          save_dir: .
          docker_compose_version: 3
          web_app: false
          overwrite: false
        EXPECT
      ),
      SpecCase.new(
        describe: "create .desrc.yml when opts has a 'save-dir'.",
        cli_options: Des::CliOptions.new(
          image: "crystallang/crystal",
          packages: ["wget", "htop"],
          container: "spec_container",
          save_dir: "spec_save_dir",
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: crystallang/crystal
          packages:
            - wget
            - htop
          container: spec_container
          save_dir: spec_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        EXPECT
      ),
      SpecCase.new(
        describe: "create .desrc.yml when opts has a 'web-app'.",
        cli_options: Des::CliOptions.new(
          image: "crystallang/crystal",
          packages: ["wget", "htop"],
          container: "spec_container",
          save_dir: "spec_save_dir",
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: true,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: crystallang/crystal
          packages:
            - wget
            - htop
          container: spec_container
          save_dir: spec_save_dir
          docker_compose_version: 3
          web_app: true
          overwrite: false
        EXPECT
      ),
      SpecCase.new(
        describe: "create .desrc.yml when opts has a 'overwrite'.",
        cli_options: Des::CliOptions.new(
          image: "crystallang/crystal",
          packages: ["wget", "htop"],
          container: "spec_container",
          save_dir: "spec_save_dir",
          rc_file: "#{__DIR__}/var/desrc_save_dir/.desrc.yml",
          docker_compose_version: "3",
          web_app: true,
          overwrite: true,
          desrc: false
        ),
        expect: <<-EXPECT
        default_param:
          image: crystallang/crystal
          packages:
            - wget
            - htop
          container: spec_container
          save_dir: spec_save_dir
          docker_compose_version: 3
          web_app: true
          overwrite: true
        EXPECT
      ),
    ].each do |spec_case|
      it spec_case.describe do
        created_file_path = spec_case.cli_options.rc_file

        File.delete(created_file_path) if File.exists?(created_file_path)

        DesrcYml.new(spec_case.cli_options, silent: true, auto_answer: true).create_file

        File.read(created_file_path).should eq spec_case.expect
        File.delete(created_file_path) if File.exists?(created_file_path)
      end
    end
  end
end
