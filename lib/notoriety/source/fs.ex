defmodule Notoriety.Source.FS do
  @behaviour Notoriety.Source

  def list_files(pattern) do
    pattern
    |> Path.wildcard()
    |> Enum.map(&{&1, File.read!(&1)})
  end

  def save_index(index, filename \\ Application.get_env(:notoriety, :output_path)) do
    File.write(filename, index)
  end
end
