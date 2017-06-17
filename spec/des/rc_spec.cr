require "../spec_helper"

describe Des::Rc do
  describe "#image" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.image.should be_nil
    end
    it "returns nil when 'image' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.image.should be_nil
    end
    it "returns image when 'image' key exists." do
      yaml_str = <<-YAML
      default_param:
        image: crystallang/crystal
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.image.should eq "crystallang/crystal"
    end
  end
  describe "#packages" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.packages.should be_nil
    end
    it "returns nil when 'packages' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.packages.should be_nil
    end
    it "returns packages when 'packages' key exists." do
      yaml_str = <<-YAML
      default_param:
        packages:
          - curl
          - vim
          - wget
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.packages.should eq ["curl", "vim", "wget"]
    end
  end
  describe "#container_name" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.container_name.should be_nil
    end
    it "returns nil when 'container_name' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.container_name.should be_nil
    end
    it "returns container_name when 'container_name' key exists." do
      yaml_str = <<-YAML
      default_param:
        container_name: my_container
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.container_name.should eq "my_container"
    end
  end
  describe "#save_dir" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.save_dir.should be_nil
    end
    it "returns nil when 'save_dir' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.save_dir.should be_nil
    end
    it "returns save_dir when 'save_dir' key exists." do
      yaml_str = <<-YAML
      default_param:
        save_dir: #{__DIR__}/rc/rc_file_save_dir
      default_compose:
        version: "2.0"
      YAML
      rc = Rc.new(yaml_str)
      rc.save_dir.should eq "#{__DIR__}/rc/rc_file_save_dir"
    end
  end
end
