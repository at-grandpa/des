require "../spec_helper"

describe Des::Dockerfile do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create Dockerfile with rc_file parameter when there is no opts parameters.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: ["rc_file_package1", "rc_file_package2"],
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        FROM rc_file_image

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install rc_file_package1 rc_file_package2

        WORKDIR /root/rc_file_container

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'image' with the opts parameter when opts has an 'image'.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: "opts_image",
          packages: ["rc_file_package1", "rc_file_package2"],
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        FROM opts_image

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install rc_file_package1 rc_file_package2

        WORKDIR /root/rc_file_container

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'packages' with the opts parameter when opts has an 'packages'.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: ["opts_packages1", "opts_packages2", "opts_packages3"],
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        FROM rc_file_image

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install opts_packages1 opts_packages2 opts_packages3

        WORKDIR /root/rc_file_container

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'container' with the opts parameter when opts has an 'container'.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: ["rc_file_package1", "rc_file_package2"],
          container: "opts_container",
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        FROM rc_file_image

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install rc_file_package1 rc_file_package2

        WORKDIR /root/opts_container

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'save_dir' with the opts parameter when opts has an 'save_dir'.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: ["rc_file_package1", "rc_file_package2"],
          container: nil,
          save_dir: "#{__DIR__}/var/opts_save_dir",
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        FROM rc_file_image

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install rc_file_package1 rc_file_package2

        WORKDIR /root/rc_file_container

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited 'web_app' with the opts parameter when opts has an 'web_app'.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: nil,
          packages: ["rc_file_package1", "rc_file_package2"],
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: true,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        FROM rc_file_image

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install rc_file_package1 rc_file_package2

        WORKDIR /root/rc_file_container

        EXPECT
      ),
      SpecCase.new(
        describe: "create Dockerfile overwrited all parameters with the opts parameter when opts has an all parameters.",
        rc_file_yaml: "
        default_options:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          docker_compose_version: 3
          web_app: false
          overwrite: false
        ",
        cli_options: Des::CliOptions.new(
          image: "opts_image",
          packages: ["opts_packages1", "opts_packages2", "opts_packages3"],
          container: "opts_container",
          save_dir: "#{__DIR__}/var/opts_save_dir",
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: true,
          overwrite: false,
          desrc: false
        ),
        expect: <<-EXPECT
        FROM opts_image

        RUN apt-get -y update
        RUN apt-get -y upgrade
        RUN apt-get -y install opts_packages1 opts_packages2 opts_packages3

        WORKDIR /root/opts_container

        EXPECT
      ),
    ].each do |spec_case|
      it spec_case.describe do
        rc = Rc.from_yaml(spec_case.rc_file_yaml)
        opts = Opts.new(spec_case.cli_options)
        parameters = Parameters.new(rc, opts)
        created_file_path = "#{parameters.save_dir}/Dockerfile"

        File.delete(created_file_path) if File.exists?(created_file_path)

        Dockerfile.new(parameters, silent: true).create_file

        File.read(created_file_path).should eq spec_case.expect
        File.delete(created_file_path) if File.exists?(created_file_path)
      end
    end
  end
end
