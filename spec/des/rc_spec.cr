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
  describe "#web_app" do
    it "returns nil when 'default_param' key not exists." do
      yaml_str = <<-YAML
      dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.web_app.should be_nil
    end
    it "returns nil when 'web_app' key not exists." do
      yaml_str = <<-YAML
      default_param:
        dummy_key: dummy_value
      YAML
      rc = Rc.new(yaml_str)
      rc.web_app.should be_nil
    end
    it "raises an Exception when web_app other than true and false is set." do
      yaml_str = <<-YAML
      default_param:
        web_app: hoge
      YAML
      rc = Rc.new(yaml_str)
      expect_raises(Exception, "web_app flag set as rc_file is allowed only 'true' or 'false'. The set flag is [hoge].") do
        rc.web_app
      end
    end
    it "returns true when 'web_app' is true." do
      yaml_str = <<-YAML
      default_param:
        web_app: true
      YAML
      rc = Rc.new(yaml_str)
      rc.web_app.should be_true
    end
    it "returns false when 'web_app' is false." do
      yaml_str = <<-YAML
      default_param:
        web_app: false
      YAML
      rc = Rc.new(yaml_str)
      rc.web_app.should be_false
    end
  end
end
