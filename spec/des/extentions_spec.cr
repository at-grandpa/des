require "../spec_helper"

describe NamedTuple do
  describe "#image" do
    [
      {
        desc:        "case0",
        main_tuple:  {k1: "a", k2: "b", k3: "c"},
        other_tuple: {k1: "x", k2: "y", k3: "z"},
        target:      [] of String,
        expected:    {k1: "a", k2: "b", k3: "c"},
      },
      {
        desc:        "case1",
        main_tuple:  {k1: "a", k2: "b", k3: "c"},
        other_tuple: {k1: "x", k2: "y", k3: "z"},
        target:      ["a"],
        expected:    {k1: "x", k2: "b", k3: "c"},
      },
      {
        desc:        "case2",
        main_tuple:  {k1: "a", k2: "b", k3: "c"},
        other_tuple: {k1: "x", k2: "y", k3: "z"},
        target:      ["hoge"],
        expected:    {k1: "a", k2: "b", k3: "c"},
      },
      {
        desc:        "case3",
        main_tuple:  {k1: "a", k2: nil, k3: nil},
        other_tuple: {k1: "x", k2: "y", k3: "z"},
        target:      ["hoge", nil],
        expected:    {k1: "a", k2: "y", k3: "z"},
      },
      {
        desc:        "case4",
        main_tuple:  {k1: "a", k2: nil, k3: ["foo", "bar"]},
        other_tuple: {k1: "x", k2: "y", k3: "z"},
        target:      ["a", nil],
        expected:    {k1: "x", k2: "y", k3: ["foo", "bar"]},
      },
      {
        desc:        "case5",
        main_tuple:  {k1: "a", k2: nil, k3: ["foo", "bar"]},
        other_tuple: {k1: "x", k2: "y", k3: "z"},
        target:      ["a", nil],
        expected:    {k1: "x", k2: "y", k3: ["foo", "bar"]},
      },
      {
        desc:        "case6",
        main_tuple:  {k1: "a", k2: nil, k3: ["foo", "bar"]},
        other_tuple: {k1: "x", k2: "y", k3: "z"},
        target:      [["foo", "bar"], nil],
        expected:    {k1: "a", k2: "y", k3: "z"},
      },
    ].each do |spec_case|
      it spec_case["desc"] do
        spec_case["main_tuple"].overwrite(spec_case["other_tuple"], spec_case["target"]).should eq spec_case["expected"]
      end
    end
  end
end
