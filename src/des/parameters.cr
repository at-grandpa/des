require "yaml"

module Des
  class Parameters
    @opts : Des::Opts
    @rc : Des::Rc
    @image : String
    @packages : Array(String)
    @container : String
    @save_dir : String
    @docker_compose_version : String
    @web_app : Bool
    @overwrite : Bool

    getter image, packages, container, save_dir, docker_compose_version, web_app, overwrite

    def initialize(@rc, @opts)
      @image = _find_image
      @packages = _find_packages
      @container = _find_container
      @save_dir = _find_save_dir
      @docker_compose_version = _find_docker_compose_version
      @web_app = _find_web_app
      @overwrite = _find_overwrite
    end

    macro find_parameter(*parameters)
      {% for parameter in parameters %}
        private def _find_{{parameter}}
          rc_default_options = @rc.default_options

          rc_parameter = if rc_default_options.nil?
                           nil
                         elsif rc_default_options.{{parameter}}.nil?
                           nil
                         else
                           rc_default_options.{{parameter}}
                         end

          opts_parameter = @opts.{{parameter}}

          return_parameter = rc_parameter unless rc_parameter.nil?
          return_parameter = opts_parameter unless opts_parameter.nil?
          raise "{{parameter}} parameter is not set. See 'des --help'" if return_parameter.nil?
          return_parameter
        end
      {% end %}
    end

    find_parameter image, container, save_dir, docker_compose_version, web_app, overwrite

    private def _find_packages
      rc_default_options = @rc.default_options

      rc_packages = if rc_default_options.nil?
                      [] of String
                    else
                      rc_default_options.packages
                    end

      opts_packages = @opts.packages

      return_packages = [] of String
      return_packages = rc_packages unless rc_packages.empty?
      return_packages = opts_packages unless opts_packages.empty?
      return_packages
    end

  end
end
