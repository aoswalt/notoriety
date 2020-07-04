defmodule Notoriety.NoteFile do
  @moduledoc """
  A file name and its `Notoriety.Note`
  """

  alias Notoriety.Note

  @enforce_keys [:file_name, :note]
  defstruct [:file_name, :note]

  def new(file_name, %Note{} = note) do
    %__MODULE__{file_name: file_name, note: note}
  end

  def file_name(%__MODULE__{} = file), do: file.file_name

  def note(%__MODULE__{} = file), do: file.note
end
