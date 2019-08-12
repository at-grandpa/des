require "../spec_helper"

describe Des::Rc do
  describe "#default_options" do
    it "returns nil when 'default_options' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.should be_nil
    end
  end
  describe "#image" do
    it "returns nil when 'default_options' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.image.should be_nil
    end
    it "returns nil when 'image' key not exists." do
      yaml_str = <<-YAML
      default_options:
        dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.image.should be_nil
    end
    it "returns image when 'image' key exists." do
      yaml_str = <<-YAML
      default_options:
        image: crystallang/crystal
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.image.should eq "crystallang/crystal"
    end
  end
  describe "#packages" do
    it "returns nil when 'default_options' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.packages.should be_nil
    end
    it "returns [] of String when 'packages' key not exists." do
      yaml_str = <<-YAML
      default_options:
        dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.packages.should eq [] of String
    end
    it "returns packages when 'packages' key exists." do
      yaml_str = <<-YAML
      default_options:
        packages:
          - curl
          - vim
          - wget
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.packages.should eq ["curl", "vim", "wget"]
    end
  end
  describe "#container" do
    it "returns nil when 'default_options' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.container.should be_nil
    end
    it "returns nil when 'container' key not exists." do
      yaml_str = <<-YAML
      default_options:
        dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.container.should be_nil
    end
    it "returns container when 'container' key exists." do
      yaml_str = <<-YAML
      default_options:
        container: my_container
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.container.should eq "my_container"
    end
  end
  describe "#save_dir" do
    it "returns nil when 'default_options' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.save_dir.should be_nil
    end
    it "returns nil when 'save_dir' key not exists." do
      yaml_str = <<-YAML
      default_options:
        dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.save_dir.should be_nil
    end
    it "returns save_dir when 'save_dir' key exists." do
      yaml_str = <<-YAML
      default_options:
        save_dir: #{__DIR__}/rc/rc_file_save_dir
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.save_dir.should eq "#{__DIR__}/rc/rc_file_save_dir"
    end
  end
  describe "#web_app" do
    it "returns nil when 'default_options' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.web_app.should be_nil
    end
    it "returns false when 'web_app' key not exists." do
      yaml_str = <<-YAML
      default_options:
        dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.web_app.should be_false
    end
    it "returns true when 'web_app' is true." do
      yaml_str = <<-YAML
      default_options:
        web_app: true
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.web_app.should be_true
    end
    it "returns false when 'web_app' is false." do
      yaml_str = <<-YAML
      default_options:
        web_app: false
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.web_app.should be_false
    end
  end
  describe "#overwrite" do
    it "returns nil when 'default_options' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.overwrite.should be_nil
    end
    it "returns false when 'overwrite' key not exists." do
      yaml_str = <<-YAML
      default_options:
        dummy_key: dummy_value
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.overwrite.should be_false
    end
    it "returns true when 'overwrite' is true." do
      yaml_str = <<-YAML
      default_options:
        overwrite: true
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.overwrite.should be_true
    end
    it "returns false when 'overwrite' is false." do
      yaml_str = <<-YAML
      default_options:
        overwrite: false
      YAML
      rc = Rc.from_yaml(yaml_str)
      rc.default_options.try &.overwrite.should be_false
    end
  end
end
