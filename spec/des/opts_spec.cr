require "../spec_helper"

alias Opts = Des::Opts

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
        input_opts.string = {"image" => spec_case["input"]}
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
        input_opts.string = {"image" => spec_case["input"]}
        opts = Opts.new(input_opts)
        expect_raises(Exception, "Invalid image name pattern. Valid pattern -> /#{Opts::IMAGE_PATTERN}/") do
          opts.image
        end
      end
    end
  end
  describe "#container_name" do
    [
      {
        "input"    => "spec_container_name",
        "expected" => "spec_container_name",
      },
    ].each do |spec_case|
      it "returns #{spec_case["expected"]} when input container_name is #{spec_case["input"]}." do
        input_opts = Clim::Options::Values.new
        input_opts.string = {"container-name" => spec_case["input"]}
        opts = Opts.new(input_opts)
        opts.container_name.should eq spec_case["expected"]
      end
    end
    it "returns nil when input container name not exests." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.container_name.should eq nil
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
        input_opts.string = {"container-name" => spec_case["input"]}
        opts = Opts.new(input_opts)
        expect_raises(Exception, "Invalid container name pattern. Valid pattern -> /#{Opts::CONTAINER_NAME_PATTERN}/") do
          opts.container_name
        end
      end
    end
  end
  describe "#save_dir" do
    it "returns save dir path when dir path exists." do
      input_opts = Clim::Options::Values.new
      input_opts.string = {"save-dir" => __DIR__}
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
      input_opts.string = {"save-dir" => "#{__DIR__}/missing_dir/"}
      opts = Opts.new(input_opts)
      expect_raises(Exception, "No such save dir. -> #{__DIR__}/missing_dir/") do
        opts.save_dir
      end
    end
  end
  describe "#rc_file" do
    it "returns rc file path when file exists." do
      input_opts = Clim::Options::Values.new
      input_opts.string = {"rc-file" => "#{__DIR__}/opts/.desrc.yml"}
      opts = Opts.new(input_opts)
      opts.rc_file.should eq "#{__DIR__}/opts/.desrc.yml"
    end
    it "returns nil when input rc file path not exests in opts." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.rc_file.should eq nil
    end
    it "raises an Exception when no such save dir." do
      input_opts = Clim::Options::Values.new
      input_opts.string = {"rc-file" => "#{__DIR__}/opts/missing_rc_file.yml"}
      opts = Opts.new(input_opts)
      expect_raises(Exception, "No such rc file. -> #{__DIR__}/opts/missing_rc_file.yml") do
        opts.rc_file
      end
    end
  end
  describe "#packages" do
    it "returns packages when packages exists." do
      input_opts = Clim::Options::Values.new
      input_opts.array = {"packages" => ["package1", "package2"]}
      opts = Opts.new(input_opts)
      opts.packages.should eq ["package1", "package2"]
    end
    it "returns nil when packages not exests in opts." do
      input_opts = Clim::Options::Values.new
      opts = Opts.new(input_opts)
      opts.packages.should eq nil
    end
  end
end
