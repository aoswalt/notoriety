defmodule NotorietyTest do
  use ExUnit.Case, async: true

  describe "generate_index/1" do
    test "uses the given path" do
      path_arg = "this path"

      list_files = fn path ->
        send(self(), {:path, path})
        []
      end

      Notoriety.generate_index(path: path_arg, list_files: list_files)

      assert_receive {:path, path_arg}
    end

    test "includes tagged files in resulting index" do
      file_name = "file1"
      tag = "abc"
      title = "File Title"
      files = [{file_name, "---\ntags: [#{tag}]\n---\n\n# #{title}\n\nsome content"}]

      list_files = fn _ -> files end

      save_index = fn index ->
        assert index =~ tag
        assert index =~ file_name
        assert index =~ title
      end

      Notoriety.generate_index(list_files: list_files, save_index: save_index)
    end
  end
end
