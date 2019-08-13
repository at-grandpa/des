require "./des/*"

module Des
  record CliOptions,
    image : String | Nil,
    packages : Array(String),
    container : String | Nil,
    save_dir : String | Nil,
    desrc_path : String,
    docker_compose_version : String,
    web_app : Bool,
    overwrite : Bool,
    desrc : Bool
end
