defmodule Notoriety.Source do
  @moduledoc """
  A source of generating a list of files and saving the resulting index.
  """

  @doc """
  From a given path, return a set of file names to their contents.
  """
  @callback list_files(path :: String.t()) :: [{file_name :: String.t(), contents :: String.t()}]

  @doc """
  Save the resulting index to the given file.
  """
  @callback save_index(index :: String.t(), file_name :: String.t()) ::
              {:ok, term} | {:error, reason :: term}
end
