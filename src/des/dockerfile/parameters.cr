module Des
  module Dockerfile
    class Parameters
      @opts : Des::Opts
      @rc : Des::Rc
      @image : String
      @packages : Array(String)
      @container : String
      @save_dir : String

      getter image, packages, container, save_dir

      def initialize(@rc, @opts)
        @image = _find_image
        @packages = _find_packages
        @container = _find_container
        @save_dir = _find_save_dir
      end

      private def _find_image
        image = nil
        image = @rc.image unless @rc.image.nil?
        image = @opts.image unless @opts.image.nil?
        raise "Image name for Dockerfile is not set. See 'des -h'" if image.nil?
        image
      end

      private def _find_packages
        packages = nil
        packages = @rc.packages unless @rc.packages.nil?
        packages = @opts.packages unless @opts.packages.nil?
        raise "Packages for Dockerfile is not set. See 'des -h'" if packages.nil?
        packages
      end

      private def _find_container
        container = nil
        container = @rc.container unless @rc.container.nil?
        container = @opts.container unless @opts.container.nil?
        raise "Container name for Dockerfile is not set. See 'des -h'" if container.nil?
        container
      end

      private def _find_save_dir
        save_dir = nil
        save_dir = @rc.save_dir unless @rc.save_dir.nil?
        save_dir = @opts.save_dir unless @opts.save_dir.nil?
        raise "Save dir is not set. See 'des -h'" if save_dir.nil?
        save_dir
      end
    end
  end
end