require "../spec_helper"

describe Des::Dockerfile do
  describe "#setup_image" do
    [
      {"input" => "ubuntu"},
      {"input" => "ubuntu:16.04"},
      {"input" => "crystallang"},
      {"input" => "crystallang/crystal"},
      {"input" => "crystallang/crystal:latest"},
    ].each do |spec_case|
      it "returns image name when valid pattern. spec pattern -> #{spec_case["input"]}" do
        opts = Clim::Options::Values.new
        opts.string = {"image" => spec_case["input"]}
        dockerfile = Dockerfile.new(Rc.new, "", opts)
        dockerfile.setup_image.should eq spec_case["input"]
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
        opts = Clim::Options::Values.new
        opts.string = {"image" => spec_case["input"]}
        dockerfile = Dockerfile.new(Rc.new, "", opts)
        expect_raises(Exception, "Invalid image name pattern. Valid pattern -> /\\A[a-zA-Z][^:]+?(|:[0-9a-zA-Z-\._]+?)\\z/") do
          dockerfile.setup_image
        end
      end
    end
  end
  describe "#setup_packages" do
    [
      {"input" => [] of String},
      {"input" => ["curl", "vim", "apache-2utils"]},
    ].each do |spec_case|
      it "returns packages when valid package names. spec pattern -> #{spec_case["input"]}" do
        opts = Clim::Options::Values.new
        opts.array = {"packages" => spec_case["input"]}
        dockerfile = Dockerfile.new(Rc.new, "", opts)
        dockerfile.setup_packages.should eq spec_case["input"]
      end
    end
  end
  describe "#setup_config_param" do
    it "update image and packages when .desrc.yml exists." do
      opts = Clim::Options::Values.new
      opts.string = {"image" => "default_image"}
      opts.array = {"packages" => ["default_package1", "default_package1"]}
      rc = Rc.new(File.expand_path("./spec/des/dockerfile/.desrc.yml"))
      dockerfile = Dockerfile.new(rc, "", opts)
      dockerfile.setup_config_param
      dockerfile.image.should eq "desrc_image"
      dockerfile.packages.should eq ["desrc_package1", "desrc_package2"]
    end
  end
end
