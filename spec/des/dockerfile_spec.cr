require "../spec_helper"

describe Des::Dockerfile do
  describe "#create_file" do
    it "create file with rc_file parameter when there is no opts parameters." do
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
      opts = Opts.new(input_opts) # There is no parameters of option.

      parameters = Parameters.new(rc, opts)
      Dockerfile.new(parameters, silent: true).create_file

      created_file_path = "#{rc.save_dir}/Dockerfile"
      File.read(created_file_path).should eq <<-CREATED_FILE
      FROM rc_file_image

      RUN apt-get -y update
      RUN apt-get -y upgrade
      RUN apt-get -y install rc_file_package1 rc_file_package2

      WORKDIR /root/rc_file_container

      CREATED_FILE
      File.delete(created_file_path)
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
