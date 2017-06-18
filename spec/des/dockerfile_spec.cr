require "../spec_helper"

describe Des::Dockerfile do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create Dockerfile with rc_file parameter when there is no opts parameters.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [] of OptsParameter,
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
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [
          {"image" => "opts_image"},
        ],
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
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [
          {"packages" => ["opts_packages1", "opts_packages2", "opts_packages3"]},
        ],
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
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [
          {"container" => "opts_container"},
        ],
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
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [
          {"save_dir" => "#{__DIR__}/var/opts_save_dir"},
        ],
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
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [
          {"web_app" => true},
        ],
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
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/var/rc_file_save_dir
          web_app: false
        ",
        opts_parameters: [
          {"image" => "opts_image"},
          {"packages" => ["opts_packages1", "opts_packages2", "opts_packages3"]},
          {"container" => "opts_container"},
          {"save_dir" => "#{__DIR__}/var/opts_save_dir"},
          {"web_app" => true},
        ],
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
        rc = Rc.new(spec_case.rc_file_yaml)

        input_opts = Clim::Options::Values.new
        spec_case.opts_parameters.each do |parameter|
          input_opts.merge!(parameter)
        end
        opts = Opts.new(input_opts)

        parameters = Parameters.new(rc, opts)
        Dockerfile.new(parameters, silent: true).create_file

        created_file_path = "#{rc.save_dir}/Dockerfile"
        File.read(created_file_path).should eq spec_case.expect
        File.delete(created_file_path)
      end
    end
  end
end
