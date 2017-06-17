require "ecr"

module Des
  class Dockerfile
    FILE_NAME = "Dockerfile"

    @opts : Des::Opts
    @rc : Des::Rc
    @image : String
    @packages : Array(String)
    @container_name : String
    @save_dir : String

    getter image, packages, container_name, save_dir

    def initialize(@rc, @opts)
      @image = _find_image
      @packages = _find_packages
      @container_name = _find_container_name
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

    private def _find_container_name
      container_name = nil
      container_name = @rc.container_name unless @rc.container_name.nil?
      container_name = @opts.container_name unless @opts.container_name.nil?
      raise "Container name for Dockerfile is not set. See 'des -h'" if container_name.nil?
      container_name
    end

    private def _find_save_dir
      save_dir = nil
      save_dir = @rc.save_dir unless @rc.save_dir.nil?
      save_dir = @opts.save_dir unless @opts.save_dir.nil?
      raise "Save dir is not set. See 'des -h'" if save_dir.nil?
      save_dir
    end

    def create_file
      File.write("#{@save_dir}/#{FILE_NAME}", to_s)
    end

    ECR.def_to_s "#{__DIR__}/dockerfile/template.ecr"
  end
end
