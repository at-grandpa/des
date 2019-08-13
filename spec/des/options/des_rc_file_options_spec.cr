require "../../spec_helper"

describe Des::Options::DesrcFileOptions do
  describe "#image" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'image' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          conatiner: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'image' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: crystallang/crystal
          conatiner: dummy_data
        YAML
        expected: "crystallang/crystal",
      },
      {
        desc:     "when 'image' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: mysql:8.0.17
          conatiner: dummy_data
        YAML
        expected: "mysql:8.0.17",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.image.should eq spec_case["expected"]
      end
    end
  end
  describe "#packages" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'packages' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
        YAML
        expected: nil,
      },
      {
        desc:     "when 'packages' is empty, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
          packages: []
        YAML
        expected: [] of String,
      },
      {
        desc:     "when 'packages' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
          packages:
            - vim
            - curl
        YAML
        expected: ["vim", "curl"],
      },
      {
        desc:     "when 'packages' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
          packages:
            - git
            - wget
        YAML
        expected: ["git", "wget"],
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.packages.should eq spec_case["expected"]
      end
    end
  end
  describe "#container" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'container' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'container' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          container: test_container
        YAML
        expected: "test_container",
      },
      {
        desc:     "when 'container' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          container: hoge_container
        YAML
        expected: "hoge_container",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.container.should eq spec_case["expected"]
      end
    end
  end
  describe "#save_dir" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'save_dir' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'save_dir' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          save_dir: /path/to/dir
        YAML
        expected: "/path/to/dir",
      },
      {
        desc:     "when 'save_dir' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          save_dir: /path/to/hoge_dir
        YAML
        expected: "/path/to/hoge_dir",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.save_dir.should eq spec_case["expected"]
      end
    end
  end
  describe "#desrc_path" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'desrc_path' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'desrc_path' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          desrc_path: /path/to/dir/desrc.yml
        YAML
        expected: "/path/to/dir/desrc.yml",
      },
      {
        desc:     "when 'desrc_path' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          desrc_path: /path/to/hoge_dir/desrc.yml
        YAML
        expected: "/path/to/hoge_dir/desrc.yml",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.desrc_path.should eq spec_case["expected"]
      end
    end
  end
  describe "#docker_compose_version" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'docker_compose_version' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'docker_compose_version' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          docker_compose_version: 44
        YAML
        expected: "44",
      },
      {
        desc:     "when 'docker_compose_version' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          docker_compose_version: 99
        YAML
        expected: "99",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.docker_compose_version.should eq spec_case["expected"]
      end
    end
  end
  describe "#web_app" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'web_app' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'web_app' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          web_app: true
        YAML
        expected: true,
      },
      {
        desc:     "when 'web_app' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          web_app: false
        YAML
        expected: false,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.web_app.should eq spec_case["expected"]
      end
    end
  end
  describe "#overwrite" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'overwrite' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'overwrite' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          overwrite: true
        YAML
        expected: true,
      },
      {
        desc:     "when 'overwrite' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          overwrite: false
        YAML
        expected: false,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.overwrite.should eq spec_case["expected"]
      end
    end
  end
end
