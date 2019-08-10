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
        cli_options = Des::CliOptions.new(
          image: spec_case["input"],
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)
        opts.image.should eq spec_case["expected"]
      end
    end
    it "returns nil when input image not exests." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
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
        cli_options = Des::CliOptions.new(
          image: spec_case["input"],
          packages: [] of String,
          container: nil,
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)
        expect_raises(Exception, "Invalid image name pattern. Valid pattern -> /#{Opts::IMAGE_PATTERN}/") do
          opts.image
        end
      end
    end
  end
  describe "#packages" do
    it "returns packages when packages exists." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: ["package1", "package2"],
        container: nil,
        save_dir: nil,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      opts.packages.should eq ["package1", "package2"]
    end
    it "returns [] of String when packages empty in opts." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      opts.packages.should eq [] of String
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
        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: spec_case["input"],
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)
        opts.container.should eq spec_case["expected"]
      end
    end
    it "returns nil when input container name not exests." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
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
        cli_options = Des::CliOptions.new(
          image: nil,
          packages: [] of String,
          container: spec_case["input"],
          save_dir: nil,
          rc_file: "dummy_path",
          docker_compose_version: "3",
          web_app: false,
          overwrite: false,
          desrc: false
        )
        opts = Opts.new(cli_options)
        expect_raises(Exception, "Invalid container name pattern. Valid pattern -> /#{Opts::CONTAINER_PATTERN}/") do
          opts.container
        end
      end
    end
  end
  describe "#save_dir" do
    it "returns save dir path when dir path exists." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: __DIR__,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      opts.save_dir.should eq __DIR__
    end
    it "returns nil when input save dir path not exests in opts." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      opts.save_dir.should eq nil
    end
    it "raises an Exception when no such save dir." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: "#{__DIR__}/missing_dir",
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      expect_raises(Exception, "Save dir set as an option is not found. -> #{__DIR__}/missing_dir") do
        opts.save_dir
      end
    end
  end
  describe "#rc_file" do
    it "returns rc file path when file exists." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "#{__DIR__}/opts/.desrc.yml",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      opts.rc_file.should eq "#{__DIR__}/opts/.desrc.yml"
    end
    it "raises an Exception when rc_file set as an option is not found." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "#{__DIR__}/opts/missing_rc_file.yml",
        docker_compose_version: "3",
        web_app: false,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      expect_raises(Exception, "rc_file set as an option is not found. -> #{__DIR__}/opts/missing_rc_file.yml") do
        opts.rc_file
      end
    end
  end
  describe "#web_app" do
    it "returns web_app when web_app exists." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: true,
        overwrite: false,
        desrc: false
      )
      opts = Opts.new(cli_options)
      opts.web_app.should eq true
    end
  end
  describe "#overwrite" do
    it "returns overwrite when overwrite exists." do
      cli_options = Des::CliOptions.new(
        image: nil,
        packages: [] of String,
        container: nil,
        save_dir: nil,
        rc_file: "dummy_path",
        docker_compose_version: "3",
        web_app: false,
        overwrite: true,
        desrc: false
      )
      opts = Opts.new(cli_options)
      opts.overwrite.should eq true
    end
  end
end
