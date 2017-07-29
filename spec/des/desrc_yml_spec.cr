require "../spec_helper"

describe Des::DesrcYml do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create .desrc.yml.",
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
        ],
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
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
          {"image" => "crystallang/crystal"},
        ],
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
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
          {"image" => "crystallang/crystal"},
          {"packages" => ["wget", "htop"]},
        ],
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
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
          {"image" => "crystallang/crystal"},
          {"packages" => [] of String},
        ],
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
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
          {"image" => "crystallang/crystal"},
          {"packages" => ["wget", "htop"]},
          {"container" => "spec_container"},
        ],
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
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
          {"image" => "crystallang/crystal"},
          {"packages" => ["wget", "htop"]},
          {"container" => "spec_container"},
          {"save-dir" => "spec_save_dir"},
        ],
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
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
          {"image" => "crystallang/crystal"},
          {"packages" => ["wget", "htop"]},
          {"container" => "spec_container"},
          {"save-dir" => "spec_save_dir"},
          {"web-app" => true},
        ],
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
        opts_parameters: [
          {"rc-file" => "#{__DIR__}/var/desrc_save_dir/.desrc.yml"},
          {"image" => "crystallang/crystal"},
          {"packages" => ["wget", "htop"]},
          {"container" => "spec_container"},
          {"save-dir" => "spec_save_dir"},
          {"web-app" => true},
          {"overwrite" => true},
        ],
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
        input_opts = Hash(String, String | Bool | Array(String) | Nil).new
        spec_case.opts_parameters.each do |parameter|
          input_opts.merge!(parameter)
        end

        created_file_path = input_opts["rc-file"].as(String)

        File.delete(created_file_path) if File.exists?(created_file_path)

        DesrcYml.new(input_opts, silent: true, auto_answer: true).create_file

        File.read(created_file_path).should eq spec_case.expect
        File.delete(created_file_path) if File.exists?(created_file_path)
      end
    end
  end
end
