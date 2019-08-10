require "yaml"

module Des
  class RcParameters
    YAML.mapping(
      image: {
        type:    String,
        nilable: true,
        default: nil,
      },
      packages: {
        type:    Array(String),
        nilable: false,
        default: [] of String,
      },
      container: {
        type:    String,
        nilable: true,
        default: nil,
      },
      save_dir: {
        type:    String,
        nilable: true,
        default: nil,
      },
      rc_file: {
        type:    String,
        nilable: true,
        default: nil,
      },
      docker_compose_version: {
        type:    String,
        nilable: true,
        default: nil,
      },
      web_app: {
        type:    Bool,
        default: false,
      },
      overwrite: {
        type:    Bool,
        default: false,
      },
      desrc: {
        type:    Bool,
        default: false,
      },
    )
  end

  class Rc
    YAML.mapping(
      default_param: {
        type:    RcParameters,
        nilable: true,
        default: nil,
      },
    )
  end
end
