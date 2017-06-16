require "../spec_helper"

describe Des::Dockerfile do
  describe "#validate_image!" do
    [
      {"input" => "ubuntu"},
      {"input" => "ubuntu:16.04"},
      {"input" => "crystallang"},
      {"input" => "crystallang/crystal"},
      {"input" => "crystallang/crystal:latest"},
    ].each do |spec_case|
      it "not raises an Exception when valid pattern. spec pattern -> #{spec_case["input"]}" do
        dockerfile = Dockerfile.new(Rc.new, "", Clim::Options::Values.new)
        dockerfile.validate_image!(spec_case["input"]).should be_nil # not raises an Exception
      end
    end
    [
      {"input" => ""},
      {"input" => ":aaa"},
      {"input" => "-aaa"},
      {"input" => "/aaa"},
      {"input" => "0aaa"},
      {"input" => "aaa:"},
      {"input" => "aaa/bbb:ccc:ddd"},
    ].each do |spec_case|
      it "raises an Exception when invarid image name. spec pattern -> #{spec_case["input"]}" do
        dockerfile = Dockerfile.new(Rc.new, "", Clim::Options::Values.new)
        expect_raises(Exception, "Invalid image name pattern. Valid pattern -> /\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z/") do
          dockerfile.validate_image!(spec_case["input"])
        end
      end
    end
  end
  describe "#update_to_config_param" do
    it "non update image and packages when 'default_param' key does not exists in conf file." do
      opts = Clim::Options::Values.new
      opts.string = {"image" => "default_image"}
      opts.array = {"packages" => ["default_package1", "default_package1"]}
      rc = Rc.new(File.expand_path("./spec/des/dockerfile/.desrc_not_default_param_key.yml"))
      dockerfile = Dockerfile.new(rc, "", opts)
      dockerfile.update_to_config_param
      dockerfile.image.should eq "ubuntu:latest" # non update
      dockerfile.packages.should eq [] of String # non update
    end
    it "non update image when 'default_image' key does not exists." do
      opts = Clim::Options::Values.new
      opts.string = {"image" => "default_image"}
      opts.array = {"packages" => ["default_package1", "default_package1"]}
      rc = Rc.new(File.expand_path("./spec/des/dockerfile/.desrc_not_image_key.yml"))
      dockerfile = Dockerfile.new(rc, "", opts)
      dockerfile.update_to_config_param
      dockerfile.image.should eq "ubuntu:latest" # non update
      dockerfile.packages.should eq ["desrc_package1", "desrc_package2"] # update
    end
    it "non update packages when 'default_packages' key does not exists." do
      opts = Clim::Options::Values.new
      opts.string = {"image" => "default_image"}
      opts.array = {"packages" => ["default_package1", "default_package1"]}
      rc = Rc.new(File.expand_path("./spec/des/dockerfile/.desrc_not_packages_key.yml"))
      dockerfile = Dockerfile.new(rc, "", opts)
      dockerfile.update_to_config_param
      dockerfile.image.should eq "desrc_image" # update
      dockerfile.packages.should eq [] of String # non update
    end
    it "update image and packages when .desrc.yml exists." do
      opts = Clim::Options::Values.new
      opts.string = {"image" => "default_image"}
      opts.array = {"packages" => ["default_package1", "default_package1"]}
      rc = Rc.new(File.expand_path("./spec/des/dockerfile/.desrc.yml"))
      dockerfile = Dockerfile.new(rc, "", opts)
      dockerfile.update_to_config_param
      dockerfile.image.should eq "desrc_image"
      dockerfile.packages.should eq ["desrc_package1", "desrc_package2"]
    end
  end
end
