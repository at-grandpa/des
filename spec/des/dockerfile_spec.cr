require "../spec_helper"

alias OptsParameter = Hash(String, String) | Hash(String, Bool) | Hash(String, Array(String))

class SpecCase
  @describe : String = ""
  @rc_file_yaml : String = ""
  @opts_parameters : Array(OptsParameter) = [] of OptsParameter
  @expect : String = ""

  getter describe, rc_file_yaml, opts_parameters, expect

  def initialize(@describe, @rc_file_yaml, @opts_parameters, @expect)
  end
end

describe Des::Dockerfile do
  describe "#create_file" do
    [
      SpecCase.new(
        describe: "create file with rc_file parameter when there is no opts parameters.",
        rc_file_yaml: "
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/dockerfile/rc_file_save_dir
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
    it "create Dockerfile overwrited 'image' with the opts parameter when opts has an 'image'." do
      yaml_str = <<-YAML
      default_param:
        image: rc_file_image
        packages:
          - rc_file_package1
          - rc_file_package2
        container: rc_file_container
        save_dir: #{__DIR__}/dockerfile/rc_file_save_dir
        web_app: false
      YAML
      rc = Rc.new(yaml_str)

      input_opts = Clim::Options::Values.new
      input_opts.merge!({"image" => "opts_image"})
      opts = Opts.new(input_opts) # There is no parameters of option.

      parameters = Parameters.new(rc, opts)
      Dockerfile.new(parameters, silent: true).create_file

      created_file_path = "#{rc.save_dir}/Dockerfile"
      File.read(created_file_path).should eq <<-CREATED_FILE
      FROM opts_image

      RUN apt-get -y update
      RUN apt-get -y upgrade
      RUN apt-get -y install rc_file_package1 rc_file_package2

      WORKDIR /root/rc_file_container

      CREATED_FILE
      File.delete(created_file_path)
    end
  end
end
