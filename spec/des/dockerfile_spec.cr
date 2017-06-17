require "../spec_helper"

describe Des::Dockerfile do
  describe "#initialize" do
    it "sets parameters." do
      yaml_str = <<-YAML_STR
      default_param:
        image: rc_file_image
        packages:
          - rc_file_curl
          - rc_file_vim
        container_name: rc_file_container
        rc_file: ~/.rc_file_desrc.yml
      default_compose:
        version: "2.0"
      YAML_STR
      rc = Rc.new(yaml_str)

      opts_values = Clim::Options::Values.new
      opts_values.string = {"image" => "opts_image"}
      opts_values.array = {"packages" => ["opts_package1", "opts_package2"]}
      opts_values.string = {"container-name" => "opts_container"}
      opts_values.string = {"save-dir" => "#{__DIR__}"}
      opts = Opts.new(opts_values)

      dockerfile = Dockerfile.new(rc, opts)
      dockerfile.image.should eq "opts_image"
      dockerfile.packages.should eq ["opts_package1", "opts_package2"]
      dockerfile.container_name.should eq "opts_container"
      dockerfile.save_dir.should eq "#{__DIR__}"
    end
  end
end
