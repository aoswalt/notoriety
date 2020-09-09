defmodule Notoriety.Source do
  @callback list_files(path :: String.t()) :: [{file_name :: String.t(), contents :: String.t()}]
  @callback save_index(index :: String.t()) :: {:ok, term} | {:error, reason :: term}
end
