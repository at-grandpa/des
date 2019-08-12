require "../../spec_helper"

describe Des::Cli::FileCreator do
  describe "#create" do
    [
      {
        desc:             "create file by 'write' and display message.",
        file_create_info: {
          path:      "#{__DIR__}/var/test.txt",
          str:       "abc\ndef\nghi\n",
          overwrite: false,
        },
        create_same_file_before: false,
        prompt_input_str:        "",
        file_expected:           "abc\ndef\nghi\n",
        message_expected:        /\A\e\[92mCreate\e\[0m \/.+?\/var\/test\.txt\n\z/,
      },
      {
        desc:             "create file by 'write' and display message. (overwrite = true)",
        file_create_info: {
          path:      "#{__DIR__}/var/test.txt",
          str:       "abc\ndef\nghi\n",
          overwrite: true,
        },
        create_same_file_before: false,
        prompt_input_str:        "",
        file_expected:           "abc\ndef\nghi\n",
        message_expected:        /\A\e\[92mCreate\e\[0m \/.+?\/var\/test\.txt\n\z/,
      },
      {
        desc:             "create file by 'overwrite' and display message.",
        file_create_info: {
          path:      "#{__DIR__}/var/test.txt",
          str:       "abc\ndef\nghi\n",
          overwrite: true,
        },
        create_same_file_before: true,
        prompt_input_str:        "",
        file_expected:           "abc\ndef\nghi\n",
        message_expected:        /\A\e\[92mOverwrite\e\[0m \/.+?\/var\/test\.txt\n\z/,
      },
      {
        desc:             "create file by 'overwrite_prompt' with 'y' and display message.",
        file_create_info: {
          path:      "#{__DIR__}/var/test.txt",
          str:       "abc\ndef\nghi\n",
          overwrite: false,
        },
        create_same_file_before: true,
        prompt_input_str:        "y",
        file_expected:           "abc\ndef\nghi\n",
        message_expected:        /\A\n\/.+?\/var\/test\.txt\nOverwrite\? \(y or n\) > \e\[92mOverwrite\e\[0m \/.+?\/var\/test\.txt\n\z/,
      },
      {
        desc:             "create file by 'overwrite_prompt' with 'n' and display message.",
        file_create_info: {
          path:      "#{__DIR__}/var/test.txt",
          str:       "abc\ndef\nghi\n",
          overwrite: false,
        },
        create_same_file_before: true,
        prompt_input_str:        "n",
        file_expected:           "", # empty file
        message_expected:        /\A\n\/.+?\/var\/test\.txt\nOverwrite\? \(y or n\) > \e\[93mDid not overwrite.\e\[0m\n\z/,
      },
      {
        desc:             "create file by 'overwrite_prompt' with 'hoge\ny' and display message.",
        file_create_info: {
          path:      "#{__DIR__}/var/test.txt",
          str:       "abc\ndef\nghi\n",
          overwrite: false,
        },
        create_same_file_before: true,
        prompt_input_str:        "hoge\ny",
        file_expected:           "abc\ndef\nghi\n",
        message_expected:        /\A\n\/.+?\/var\/test\.txt\nOverwrite\? \(y or n\) > Please input y or n.\n\n\n\/.+?\/var\/test\.txt\nOverwrite\? \(y or n\) > \e\[92mOverwrite\e\[0m \/.+?\/var\/test\.txt\n\z/,
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        file_create_info = Des::Cli::FileCreateInfo.new(
          path: spec_case["file_create_info"]["path"],
          str: spec_case["file_create_info"]["str"],
          overwrite: spec_case["file_create_info"]["overwrite"],
        )
        File.delete(file_create_info.path) if File.exists?(file_create_info.path)
        File.touch(file_create_info.path) if spec_case["create_same_file_before"]

        writer = IO::Memory.new
        reader = IO::Memory.new spec_case["prompt_input_str"]
        file_creator = Des::Cli::FileCreator.new(file_create_info, writer, reader)
        file_creator.create

        File.read(file_create_info.path).should eq spec_case["file_expected"]
        File.delete(file_create_info.path) if File.exists?(file_create_info.path)
        file_creator.writer.to_s.should match spec_case["message_expected"]
      end
    end
  end
end
