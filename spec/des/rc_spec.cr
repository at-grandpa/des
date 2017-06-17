require "../spec_helper"

describe Des::Rc do
  describe "#image" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.image.should be_nil
    end
    it "returns nil when 'image' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.image.should be_nil
    end
    it "returns image when 'image' key exists." do
      yaml_str = <<-YAML
      default_param:
        image: crystallang/crystal
      YAML
      rc = Rc.new(yaml_str)
      rc.image.should eq "crystallang/crystal"
    end
  end
  describe "#packages" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.packages.should be_nil
    end
    it "returns nil when 'packages' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
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
      YAML
      rc = Rc.new(yaml_str)
      rc.packages.should eq ["curl", "vim", "wget"]
    end
  end
  describe "#container" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.container.should be_nil
    end
    it "returns nil when 'container' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.container.should be_nil
    end
    it "returns container when 'container' key exists." do
      yaml_str = <<-YAML
      default_param:
        container: my_container
      YAML
      rc = Rc.new(yaml_str)
      rc.container.should eq "my_container"
    end
  end
  describe "#save_dir" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.save_dir.should be_nil
    end
    it "returns nil when 'save_dir' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.save_dir.should be_nil
    end
    it "returns save_dir when 'save_dir' key exists." do
      yaml_str = <<-YAML
      default_param:
        save_dir: #{__DIR__}/rc/rc_file_save_dir
      YAML
      rc = Rc.new(yaml_str)
      rc.save_dir.should eq "#{__DIR__}/rc/rc_file_save_dir"
    end
  end
  describe "#mysql_version" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.mysql_version.should be_nil
    end
    it "returns nil when 'mysql_version' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.mysql_version.should be_nil
    end
    it "returns mysql_version when 'mysql_version' key exists." do
      yaml_str = <<-YAML
      default_param:
        mysql_version: 5.7
      YAML
      rc = Rc.new(yaml_str)
      rc.mysql_version.should eq "5.7"
    end
  end
  describe "#nginx_version" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.nginx_version.should be_nil
    end
    it "returns nil when 'nginx_version' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.nginx_version.should be_nil
    end
    it "returns nginx_versionwhen 'nginx_version' key exists." do
      yaml_str = <<-YAML
      default_param:
        nginx_version: 1.13.1
      YAML
      rc = Rc.new(yaml_str)
      rc.nginx_version.should eq "1.13.1"
    end
  end
end
