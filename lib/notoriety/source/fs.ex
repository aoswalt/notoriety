defmodule Notoriety.Source.FS do
  @moduledoc """
  Use the file system as a `Notoriety.Source`.
  """

  @behaviour Notoriety.Source

  def list_files(pattern) do
    pattern
    |> Path.wildcard()
    |> Enum.map(&{&1, File.read!(&1)})
  end

  def save_index(index, file_name) do
    with :ok <- File.write(file_name, index) do
      {:ok, file_name, index}
    end
  end
end
