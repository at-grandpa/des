require "../../spec_helper"

describe Des::Dockerfile::Parameters do
  describe "#initialize" do
    describe "(about 'image')" do
      it "raises an Exception when 'image' key not exists in rc_file and opts." do
        yaml_str = <<-YAML_STR
        default_param:
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str) # 'image' key not exists.

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'image' key not exists.

        expect_raises(Exception, "Image name for Dockerfile is not set. See 'des -h'") do
          Des::Dockerfile::Parameters.new(rc, opts)
        end
      end
      it "set rc_file image when opts image not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'image' key not exist.

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.image.should eq "rc_file_image"
      end
      it "overwrite rc_file image with opts image when opts image exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts_values.merge!({"image" => "opts_image"})
        opts = Opts.new(opts_values)

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.image.should eq "opts_image"
      end
    end
    describe "(about 'packages')" do
      it "raises an Exception when 'packages' key not exists in rc_file and opts." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str) # 'packages' key not exists.

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'packages' key not exists.

        expect_raises(Exception, "Packages for Dockerfile is not set. See 'des -h'") do
          Des::Dockerfile::Parameters.new(rc, opts)
        end
      end
      it "set rc_file packages when opts packages not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'packages' key not exist.

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.packages.should eq ["rc_file_package1", "rc_file_package2"]
      end
      it "overwrite rc_file packages with opts packages when opts packages exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts_values.merge!({"packages" => ["opts_package1", "opts_package2"]})
        opts = Opts.new(opts_values)

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.packages.should eq ["opts_package1", "opts_package2"]
      end
    end
    describe "(about 'container')" do
      it "raises an Exception when 'container' key not exists in rc_file and opts." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str) # 'container' key not exists.

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'container' key not exists.

        expect_raises(Exception, "Container name for Dockerfile is not set. See 'des -h'") do
          Des::Dockerfile::Parameters.new(rc, opts)
        end
      end
      it "set rc_file container when opts container not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'container' key not exist.

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.container.should eq "rc_file_container"
      end
      it "overwrite rc_file container with opts container when opts container exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts_values.merge!({"container" => "opts_container"})
        opts = Opts.new(opts_values)

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.container.should eq "opts_container"
      end
    end

    describe "(about 'save_dir')" do
      it "raises an Exception when 'save_dir' key not exists in rc_file and opts." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
        YAML_STR
        rc = Rc.new(yaml_str) # 'save_dir' key not exists.

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'save_dir' key not exists.

        expect_raises(Exception, "Save dir is not set. See 'des -h'") do
          Des::Dockerfile::Parameters.new(rc, opts)
        end
      end
      it "set rc_file save_dir when opts save_dir not exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts = Opts.new(opts_values) # 'save_dir' key not exist.

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.save_dir.should eq "#{__DIR__}/rc_file_save_dir"
      end
      it "overwrite rc_file save_dir with opts save_dir when opts save_dir exists." do
        yaml_str = <<-YAML_STR
        default_param:
          image: rc_file_image
          packages:
            - rc_file_package1
            - rc_file_package2
          container: rc_file_container
          save_dir: #{__DIR__}/rc_file_save_dir
        YAML_STR
        rc = Rc.new(yaml_str)

        opts_values = Clim::Options::Values.new
        opts_values.merge!({"save-dir" => "#{__DIR__}/opts_save_dir"})
        opts = Opts.new(opts_values)

        parameters = Des::Dockerfile::Parameters.new(rc, opts)
        parameters.save_dir.should eq "#{__DIR__}/opts_save_dir"
      end
    end
  end
end
