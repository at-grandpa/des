require "../spec_helper"

describe Des::Opts do
  describe "#image" do
    [
      {
        "input"    => "ubuntu",
        "expected" => "ubuntu",
      },
      {
        "input"    => "ubuntu:16.04",
        "expected" => "ubuntu:16.04",
      },
      {
        "input"    => "crystallang/crystal",
        "expected" => "crystallang/crystal",
      },
    ].each do |spec_case|
      it "returns #{spec_case["expected"]} when input image is #{spec_case["input"]}." do
        input_opts = Clim::Options::Values.new
        input_opts.merge!({"image" => spec_case["input"]})
        opts = Opts.new(input_opts)
        opts.image.should eq spec_case["expected"]
      end
    end
    it "returns nil when input image not exests." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.image.should eq nil
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
      it "raises an Exception when invarid image name. spec pattern -> #{spec_case["input"]}." do
        input_opts = Clim::Options::Values.new
        input_opts.merge!({"image" => spec_case["input"]})
        opts = Opts.new(input_opts)
        expect_raises(Exception, "Invalid image name pattern. Valid pattern -> /#{Opts::IMAGE_PATTERN}/") do
          opts.image
        end
      end
    end
  end
  describe "#packages" do
    it "returns packages when packages exists." do
      input_opts = Clim::Options::Values.new
      input_opts.merge!({"packages" => ["package1", "package2"]})
      opts = Opts.new(input_opts)
      opts.packages.should eq ["package1", "package2"]
    end
    it "returns nil when packages not exests in opts." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.packages.should eq nil
    end
  end
  describe "#container" do
    [
      {
        "input"    => "spec_container",
        "expected" => "spec_container",
      },
    ].each do |spec_case|
      it "returns #{spec_case["expected"]} when input container is #{spec_case["input"]}." do
        input_opts = Clim::Options::Values.new
        input_opts.merge!({"container" => spec_case["input"]})
        opts = Opts.new(input_opts)
        opts.container.should eq spec_case["expected"]
      end
    end
    it "returns nil when input container name not exests." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.container.should eq nil
    end
    [
      {"input" => ""},
      {"input" => ":aaa"},
      {"input" => "/aaa"},
      {"input" => "aaa:"},
      {"input" => "aaa/bbb:ccc:ddd"},
    ].each do |spec_case|
      it "raises an Exception when invarid container name. spec pattern -> #{spec_case["input"]}." do
        input_opts = Clim::Options::Values.new
        input_opts.merge!({"container" => spec_case["input"]})
        opts = Opts.new(input_opts)
        expect_raises(Exception, "Invalid container name pattern. Valid pattern -> /#{Opts::CONTAINER_PATTERN}/") do
          opts.container
        end
      end
    end
  end
  describe "#save_dir" do
    it "returns save dir path when dir path exists." do
      input_opts = Clim::Options::Values.new
      input_opts.merge!({"save-dir" => __DIR__})
      opts = Opts.new(input_opts)
      opts.save_dir.should eq __DIR__
    end
    it "returns nil when input save dir path not exests in opts." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.save_dir.should eq nil
    end
    it "raises an Exception when no such save dir." do
      input_opts = Clim::Options::Values.new
      input_opts.merge!({"save-dir" => "#{__DIR__}/missing_dir"})
      opts = Opts.new(input_opts)
      expect_raises(Exception, "Save dir set as an option is not found. -> #{__DIR__}/missing_dir") do
        opts.save_dir
      end
    end
  end
  describe "#rc_file" do
    it "returns rc file path when file exists." do
      input_opts = Clim::Options::Values.new
      input_opts.merge!({"rc-file" => "#{__DIR__}/opts/.desrc.yml"})
      opts = Opts.new(input_opts)
      opts.rc_file.should eq "#{__DIR__}/opts/.desrc.yml"
    end
    it "raises an Exception when rc_file path is not set in opts." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      expect_raises(Exception, "rc_file path is not set. See 'des -h'") do
        opts.rc_file
      end
    end
    it "raises an Exception when rc_file set as an option is not found." do
      input_opts = Clim::Options::Values.new
      input_opts.merge!({"rc-file" => "#{__DIR__}/opts/missing_rc_file.yml"})
      opts = Opts.new(input_opts)
      expect_raises(Exception, "rc_file set as an option is not found. -> #{__DIR__}/opts/missing_rc_file.yml") do
        opts.rc_file
      end
    end
  end
  describe "#mysql_version" do
    it "returns mysql_version when mysql_version exists." do
      input_opts = Clim::Options::Values.new
      input_opts.merge!({"mysql-version" => "5.7"})
      opts = Opts.new(input_opts)
      opts.mysql_version.should eq "5.7"
    end
    it "returns nil when mysql_version not exests in opts." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.mysql_version.should eq nil
    end
  end
  describe "#nginx_version" do
    it "returns nginx_version when nginx_version exists." do
      input_opts = Clim::Options::Values.new
      input_opts.merge!({"nginx-version" => "1.13.1"})
      opts = Opts.new(input_opts)
      opts.nginx_version.should eq "1.13.1"
    end
    it "returns nil when nginx_version not exests in opts." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.nginx_version.should eq nil
    end
  end
end
