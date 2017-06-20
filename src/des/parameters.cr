require "yaml"

module Des
  class Parameters
    @opts : Des::Opts
    @rc : Des::Rc
    @image : String
    @packages : Array(String)
    @container : String
    @save_dir : String
    @web_app : Bool
    @overwrite : Bool

    getter image, packages, container, save_dir, web_app, overwrite

    def initialize(@rc, @opts)
      @image = _find_image
      @packages = _find_packages
      @container = _find_container
      @save_dir = _find_save_dir
      @web_app = _find_web_app
      @overwrite = _find_overwrite
    end

    private def _find_image
      image = nil
      image = @rc.image unless @rc.image.nil?
      image = @opts.image unless @opts.image.nil?
      raise "Image name is not set. See 'des -h'" if image.nil?
      image
    end

    private def _find_packages
      packages = nil
      packages = @rc.packages unless @rc.packages.nil?
      packages = @opts.packages unless @opts.packages.nil?
      raise "Packages is not set. See 'des -h'" if packages.nil?
      packages
    end

    private def _find_container
      container = nil
      container = @rc.container unless @rc.container.nil?
      container = @opts.container unless @opts.container.nil?
      raise "Container name is not set. See 'des -h'" if container.nil?
      container
    end

    private def _find_save_dir
      save_dir = nil
      save_dir = @rc.save_dir unless @rc.save_dir.nil?
      save_dir = @opts.save_dir unless @opts.save_dir.nil?
      raise "Save dir is not set. See 'des -h'" if save_dir.nil?
      save_dir
    end

    private def _find_web_app
      web_app = nil
      web_app = @rc.web_app unless @rc.web_app.nil?
      web_app = @opts.web_app unless @opts.web_app.nil?
      raise "web_app flag is not set. See 'des -h'" if web_app.nil?
      web_app
    end

    private def _find_overwrite
      overwrite = nil
      overwrite = @rc.overwrite unless @rc.overwrite.nil?
      overwrite = @opts.overwrite unless @opts.overwrite.nil?
      raise "overwrite flag is not set. See 'des -h'" if overwrite.nil?
      overwrite
    end
  end
end
