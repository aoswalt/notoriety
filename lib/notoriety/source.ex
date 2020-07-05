defmodule Notoriety.Source do
  @callback list_files() :: [{file_name :: String.t(), contents :: String.t()}]
  @callback save_index(index :: String.t) :: {:ok, term} | {:error, reason :: term}
end
