defmodule NotorietyTest do
  use ExUnit.Case, async: true

  describe "generate_index/1" do
    test "uses the given input_path" do
      path_arg = "this path"

      list_files = fn path ->
        send(self(), {:input_path, path})
        []
      end

      Notoriety.generate_index(input_path: path_arg, list_files: list_files, output_file: "file")

      assert_receive {:input_path, path_arg}
    end

    test "uses the given output_file" do
      file_arg = "this file"

      {:ok, file_name, _contents} =
        Notoriety.generate_index(
          input_path: "path",
          output_file: file_arg
        )

      assert file_name == file_arg
    end

    test "includes tagged files in resulting index" do
      file_name = "file1"
      tag = "abc"
      title = "File Title"
      files = [{file_name, "---\ntags: [#{tag}]\n---\n\n# #{title}\n\nsome content"}]

      list_files = fn _ -> files end

      {:ok, _file_name, index} =
        Notoriety.generate_index(
          input_path: "path",
          list_files: list_files,
          output_file: "file"
        )

      assert index =~ tag
      assert index =~ file_name
      assert index =~ title
    end
  end
end
