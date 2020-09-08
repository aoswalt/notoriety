defmodule Notoriety.Source.FS do
  @behaviour Notoriety.Source

  def list_files(pattern \\ "notes/**/*.md") do
    pattern
    |> Path.wildcard()
    |> Enum.map(&{&1, File.read!(&1)})
  end

  def save_index(index, filename \\ "index.md") do
    File.write(filename, index)
  end
end
