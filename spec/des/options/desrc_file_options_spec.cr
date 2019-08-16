require "../../spec_helper"

describe Des::Options::DesrcFileOptions do
  describe "#image" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'image' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          conatiner: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'image' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: crystallang/crystal
          conatiner: dummy_data
        YAML
        expected: "crystallang/crystal",
      },
      {
        desc:     "when 'image' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: mysql:8.0.17
          conatiner: dummy_data
        YAML
        expected: "mysql:8.0.17",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.image.should eq spec_case["expected"]
      end
    end
  end
  describe "#packages" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'packages' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
        YAML
        expected: nil,
      },
      {
        desc:     "when 'packages' is empty, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
          packages: []
        YAML
        expected: [] of String,
      },
      {
        desc:     "when 'packages' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
          packages:
            - vim
            - curl
        YAML
        expected: ["vim", "curl"],
      },
      {
        desc:     "when 'packages' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_dasta
          packages:
            - git
            - wget
        YAML
        expected: ["git", "wget"],
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.packages.should eq spec_case["expected"]
      end
    end
  end
  describe "#container" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'container' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'container' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          container: test_container
        YAML
        expected: "test_container",
      },
      {
        desc:     "when 'container' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          container: hoge_container
        YAML
        expected: "hoge_container",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.container.should eq spec_case["expected"]
      end
    end
  end
  describe "#save_dir" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'save_dir' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'save_dir' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          save_dir: /path/to/dir
        YAML
        expected: "/path/to/dir",
      },
      {
        desc:     "when 'save_dir' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          save_dir: /path/to/hoge_dir
        YAML
        expected: "/path/to/hoge_dir",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.save_dir.should eq spec_case["expected"]
      end
    end
  end
  describe "#docker_compose_version" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'docker_compose_version' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'docker_compose_version' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          docker_compose_version: 44
        YAML
        expected: "44",
      },
      {
        desc:     "when 'docker_compose_version' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          docker_compose_version: 99
        YAML
        expected: "99",
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.docker_compose_version.should eq spec_case["expected"]
      end
    end
  end
  describe "#web_app" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'web_app' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'web_app' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          web_app: true
        YAML
        expected: true,
      },
      {
        desc:     "when 'web_app' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          web_app: false
        YAML
        expected: false,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.web_app.should eq spec_case["expected"]
      end
    end
  end
  describe "#overwrite" do
    [
      {
        desc:     "when 'default_options' is not exist, return nil.",
        yaml_str: <<-YAML,
        YAML
        expected: nil,
      },
      {
        desc:     "when 'overwrite' is not exist, return nil.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
        YAML
        expected: nil,
      },
      {
        desc:     "when 'overwrite' is exist, return string.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          overwrite: true
        YAML
        expected: true,
      },
      {
        desc:     "when 'overwrite' is exist, return string other version.",
        yaml_str: <<-YAML,
        default_options:
          image: dummy_data
          overwrite: false
        YAML
        expected: false,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        options = Des::Options::DesrcFileOptions.new(spec_case["yaml_str"])
        options.overwrite.should eq spec_case["expected"]
      end
    end
  end

  describe "#==" do
    [
      {
        desc:          "returns true for the nil values.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          STRING
        ),
        expected: true,
      },
      {
        desc:          "returns true for the same values.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 99
            web_app: true
            overwrite: true
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 99
            web_app: true
            overwrite: true
          STRING
        ),
        expected: true,
      },
      {
        desc:          "returns false for the different image value.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: other_image
          STRING
        ),
        expected: false,
      },
      {
        desc:          "returns false for the different packages value.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - other_package1
              - other_package2
          STRING
        ),
        expected: false,
      },
      {
        desc:          "returns false for the different container value.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: other_container
          STRING
        ),
        expected: false,
      },
      {
        desc:          "returns false for the different save_dir value.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /other/path/to/dir
          STRING
        ),
        expected: false,
      },
      {
        desc:          "returns false for the different docker_compose_version value.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 99
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 100
          STRING
        ),
        expected: false,
      },
      {
        desc:          "returns false for the different web_app value.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 99
            web_app: true
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 99
            web_app: false
          STRING
        ),
        expected: false,
      },
      {
        desc:          "returns false for the different overwrite value.",
        options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 99
            web_app: true
            overwrite: true
          STRING
        ),
        other_options_input: Des::Options::DesrcFileOptions.new(
          <<-STRING
          default_options:
            image: desrc_image
            packages:
              - desrc_package1
              - desrc_package2
            container: desrc_container
            save_dir: /path/to/dir
            docker_compose_version: 99
            web_app: true
            overwrite: false
          STRING
        ),
        expected: false,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        (spec_case["options_input"] == spec_case["other_options_input"]).should eq spec_case["expected"]
      end
    end
  end
  # describe "#overwrite_values" do
  #   [
  #     {
  #       desc:          "Only elements in the specified target are overwritten.(case1)",
  #       options_input: Des::Options::DesrcFileOptions.new(
  #         <<-STRING
  #         STRING
  #       ),
  #       other_options_input: Des::Options::DesrcFileOptions.new(
  #         <<-STRING
  #         default_options:
  #           image: desrc_image
  #           packages:
  #             - desrc_package1
  #             - desrc_package2
  #           container: desrc_container
  #           save_dir: /path/to/dir
  #           docker_compose_version: 99
  #           web_app: true
  #           overwrite: false
  #         STRING
  #       ),
  #       target:   [nil, [] of String],
  #       expected: Des::Options::DesrcFileOptions.new(
  #         <<-STRING
  #         default_options:
  #           image: desrc_image
  #           packages:
  #             - desrc_package1
  #             - desrc_package2
  #           container: desrc_container
  #           save_dir: /path/to/dir
  #           docker_compose_version: 99
  #           web_app: true
  #           overwrite: false
  #         STRING
  #       ),
  #     },
  # {
  #   desc:              "Only elements in the specified target are overwritten.(case2)",
  #   options_input: Des::Options::DesrcFileOptions.new({
  #     image:                  "input image",
  #     packages:               [] of String,
  #     container:              nil,
  #     save_dir:               "input save_dir",
  #     docker_compose_version: "input docker_compose_version",
  #     web_app:                nil,
  #     overwrite:              "false",
  #   }),
  #   other_options_input: Des::Options::DesrcFileOptions.new({
  #     image:                  "default image",
  #     packages:               ["default package"],
  #     container:              "default container",
  #     save_dir:               "default save_dir",
  #     docker_compose_version: "default docker_compose_version",
  #     web_app:                "true",
  #     overwrite:              "true",
  #   }),
  #   target:   [nil, [] of String],
  #   expected: Des::Options::DesrcFileOptions.new({
  #     image:                  "input image",
  #     packages:               ["default package"],
  #     container:              "default container",
  #     save_dir:               "input save_dir",
  #     docker_compose_version: "input docker_compose_version",
  #     web_app:                "true",
  #     overwrite:              "false",
  #   }),
  # },
  # {
  #   desc:              "Only elements in the specified target are overwritten.(case3)",
  #   options_input: Des::Options::DesrcFileOptions.new({
  #     image:                  "input image",
  #     packages:               [] of String,
  #     container:              nil,
  #     save_dir:               "input save_dir",
  #     docker_compose_version: "input docker_compose_version",
  #     web_app:                nil,
  #     overwrite:              "false",
  #   }),
  #   other_options_input: Des::Options::DesrcFileOptions.new({
  #     image:                  "default image",
  #     packages:               ["default package"],
  #     container:              "default container",
  #     save_dir:               "default save_dir",
  #     docker_compose_version: "default docker_compose_version",
  #     web_app:                "true",
  #     overwrite:              "true",
  #   }),
  #   target:   [nil, "input save_dir"],
  #   expected: Des::Options::DesrcFileOptions.new({
  #     image:                  "input image",
  #     packages:               [] of String,
  #     container:              "default container",
  #     save_dir:               "default save_dir",
  #     docker_compose_version: "input docker_compose_version",
  #     web_app:                "true",
  #     overwrite:              "false",
  #   }),
  # },
  #   ].each do |spec_case|
  #     it spec_case["desc"] do
  #       spec_case["options_input"].overwrite_values(spec_case["other_options_input"], spec_case["target"]).should eq spec_case["expected"]
  #     end
  #   end
  # end
end
