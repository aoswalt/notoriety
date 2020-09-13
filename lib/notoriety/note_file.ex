defmodule Notoriety.NoteFile do
  @moduledoc """
  A file name and its associated `Notoriety.Note`
  """

  alias Notoriety.Note

  @enforce_keys [:file_name, :note]
  defstruct [:file_name, :note]

  @doc """
  Construct a `NoteFile` from the given file name and `Notoriety.Note`.
  """
  def new(file_name, %Note{} = note) do
    %__MODULE__{file_name: file_name, note: note}
  end

  @doc """
  Return the `NoteFile`'s file name.
  """
  def file_name(%__MODULE__{} = file), do: file.file_name

  @doc """
  Return the `NoteFile`'s `Notoriety.Note`.
  """
  def note(%__MODULE__{} = file), do: file.note
end
