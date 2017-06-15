require "../spec_helper"

alias Args = Des::Args

describe Des::Args do
  describe "#project_name" do
    it "returns project_name when array size is 1." do
      arg = Args.new(["one"])
      arg.project_name.should eq "one"
    end
    it "raises an Exception when array size is 0." do
      arg = Args.new([] of String)
      expect_raises(Exception, "Invalid argument. Expected argument is 1.") do
        arg.project_name
      end
    end
    it "raises an Exception when array size is greater than 1." do
      arg = Args.new(["one", "two"])
      expect_raises(Exception, "Invalid argument. Expected argument is 1.") do
        arg.project_name
      end
    end
  end
end
