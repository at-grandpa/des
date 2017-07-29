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
        input_opts = Hash(String, String | Bool | Array(String) | Nil).new
        input_opts.merge!({"image" => spec_case["input"]})
        opts = Opts.new(input_opts)
        opts.image.should eq spec_case["expected"]
      end
    end
    it "returns nil when input image not exests." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
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
        input_opts = Hash(String, String | Bool | Array(String) | Nil).new
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
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      input_opts.merge!({"packages" => ["package1", "package2"]})
      opts = Opts.new(input_opts)
      opts.packages.should eq ["package1", "package2"]
    end
    it "returns nil when packages not exests in opts." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
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
        input_opts = Hash(String, String | Bool | Array(String) | Nil).new
        input_opts.merge!({"container" => spec_case["input"]})
        opts = Opts.new(input_opts)
        opts.container.should eq spec_case["expected"]
      end
    end
    it "returns nil when input container name not exests." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
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
        input_opts = Hash(String, String | Bool | Array(String) | Nil).new
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
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      input_opts.merge!({"save-dir" => __DIR__})
      opts = Opts.new(input_opts)
      opts.save_dir.should eq __DIR__
    end
    it "returns nil when input save dir path not exests in opts." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      opts = Opts.new(input_opts)
      opts.save_dir.should eq nil
    end
    it "raises an Exception when no such save dir." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      input_opts.merge!({"save-dir" => "#{__DIR__}/missing_dir"})
      opts = Opts.new(input_opts)
      expect_raises(Exception, "Save dir set as an option is not found. -> #{__DIR__}/missing_dir") do
        opts.save_dir
      end
    end
  end
  describe "#rc_file" do
    it "returns rc file path when file exists." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      input_opts.merge!({"rc-file" => "#{__DIR__}/opts/.desrc.yml"})
      opts = Opts.new(input_opts)
      opts.rc_file.should eq "#{__DIR__}/opts/.desrc.yml"
    end
    it "raises an Exception when rc_file path is not set in opts." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      opts = Opts.new(input_opts)
      expect_raises(Exception, "rc_file path is not set. See 'des --help'") do
        opts.rc_file
      end
    end
    it "raises an Exception when rc_file set as an option is not found." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      input_opts.merge!({"rc-file" => "#{__DIR__}/opts/missing_rc_file.yml"})
      opts = Opts.new(input_opts)
      expect_raises(Exception, "rc_file set as an option is not found. -> #{__DIR__}/opts/missing_rc_file.yml") do
        opts.rc_file
      end
    end
  end
  describe "#web_app" do
    it "returns web_app when web_app exists." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      input_opts.merge!({"web-app" => true})
      opts = Opts.new(input_opts)
      opts.web_app.should eq true
    end
    it "returns nil when web_app not exests in opts." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      opts = Opts.new(input_opts)
      opts.web_app.should eq nil
    end
  end
  describe "#overwrite" do
    it "returns overwrite when overwrite exists." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      input_opts.merge!({"overwrite" => true})
      opts = Opts.new(input_opts)
      opts.overwrite.should eq true
    end
    it "returns nil when overwrite not exests in opts." do
      input_opts = Hash(String, String | Bool | Array(String) | Nil).new
      opts = Opts.new(input_opts)
      opts.overwrite.should eq nil
    end
  end
end
