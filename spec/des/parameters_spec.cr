require "../spec_helper"

describe Des::Parameters do
  describe "#initialize" do
    describe "(about 'image')" do
      it "raises an Exception when 'image' key not exists in rc_file and opts." do
        yaml_str = <<-YAML_STR
        default_param:
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str) # 'image' key not exists.

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'image' key not exists.

        expect_raises(Exception, "image parameter is not set. See 'des --help'") do
          Des::Parameters.new(rc, opts)
        end
      end
      it "set rc_file image when opts image not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'image' key not exist.

        parameters = Des::Parameters.new(rc, opts)
        parameters.image.should eq "rc_file_image"
      end
      it "overwrite rc_file image with opts image when opts image exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: "opts_image",
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)

        parameters = Des::Parameters.new(rc, opts)
        parameters.image.should eq "opts_image"
      end
    end
    describe "(about 'packages')" do
      it "set rc_file packages when opts packages not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: "opts_image",
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'packages' key not exist.

        parameters = Des::Parameters.new(rc, opts)
        parameters.packages.should eq ["rc_file_package1", "rc_file_package2"]
      end
      it "overwrite rc_file packages with opts packages when opts packages exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: "opts_image",
          packages: ["opts_package1", "opts_package2"],
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)

        parameters = Des::Parameters.new(rc, opts)
        parameters.packages.should eq ["opts_package1", "opts_package2"]
      end
    end
    describe "(about 'container')" do
      it "raises an Exception when 'container' key not exists in rc_file and opts." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str) # 'container' key not exists.

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'container' key not exists.

        expect_raises(Exception, "container parameter is not set. See 'des --help'") do
          Des::Parameters.new(rc, opts)
        end
      end
      it "set rc_file container when opts container not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'container' key not exist.

        parameters = Des::Parameters.new(rc, opts)
        parameters.container.should eq "rc_file_container"
      end
      it "overwrite rc_file container with opts container when opts container exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: "opts_container",
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)

        parameters = Des::Parameters.new(rc, opts)
        parameters.container.should eq "opts_container"
      end
    end
    describe "(about 'save_dir')" do
      it "raises an Exception when 'save_dir' key not exists in rc_file and opts." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
        YAML_STR
        rc = Rc.from_yaml(yaml_str) # 'save_dir' key not exists.

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'save_dir' key not exists.

        expect_raises(Exception, "save_dir parameter is not set. See 'des --help'") do
          Des::Parameters.new(rc, opts)
        end
      end
      it "set rc_file save_dir when opts save_dir not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'save_dir' key not exist.

        parameters = Des::Parameters.new(rc, opts)
        parameters.save_dir.should eq "#{__DIR__}/parameters/rc_file_save_dir"
      end
      it "overwrite rc_file save_dir with opts save_dir when opts save_dir exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: "#{__DIR__}/parameters/opts_save_dir",
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)

        parameters = Des::Parameters.new(rc, opts)
        parameters.save_dir.should eq "#{__DIR__}/parameters/opts_save_dir"
      end
    end

    describe "(about 'docker_compose_version')" do
      it "set rc_file docker_compose_version when opts docker_compose_version not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'docker_compose_version' key not exist.

        parameters = Des::Parameters.new(rc, opts)
        parameters.docker_compose_version.should eq "3"
      end
      it "overwrite rc_file docker_compose_version with opts docker_compose_version when opts docker_compose_version exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "4",
          web_app: true,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)

        parameters = Des::Parameters.new(rc, opts)
        parameters.docker_compose_version.should eq "4"
      end
    end

    describe "(about 'web_app')" do
      it "set rc_file web_app when opts web_app not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'web_app' key not exist.

        parameters = Des::Parameters.new(rc, opts)
        parameters.web_app.should eq false
      end
      it "overwrite rc_file web_app with opts web_app when opts web_app exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: true,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)

        parameters = Des::Parameters.new(rc, opts)
        parameters.web_app.should eq true
      end
    end

    describe "(about 'overwrite')" do
      it "set rc_file overwrite when opts overwrite not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options) # 'overwrite' key not exist.

        parameters = Des::Parameters.new(rc, opts)
        parameters.overwrite.should eq false
      end
      it "overwrite rc_file overwrite with opts overwrite when opts overwrite exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/parameters/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        YAML_STR
        rc = Rc.from_yaml(yaml_str)

        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: true,
          desrc: false
        )
        opts = Opts.new(cli_options)

        parameters = Des::Parameters.new(rc, opts)
        parameters.overwrite.should eq true
      end
    end
  end
end
