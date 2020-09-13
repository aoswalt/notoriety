defmodule Notoriety.NoteDb do
  @moduledoc """
  A collection of `Notoriety.Note`s stored by their file names
  """

  alias Notoriety.NoteFile

  defstruct db: %{}

  @doc """
  Construct a `NoteDb` given a list of `Notoriety.NoteFile`s.
  """
  def new(files \\ []) do
    Enum.reduce(files, %__MODULE__{}, &put(&2, &1))
  end

  @doc """
  Extract the `Notoriety.Note` and file name from a `Notoriety.NoteFile` to
  insert it into the `NoteDb`.
  """
  def put(%__MODULE__{} = db, %NoteFile{} = file) do
    file_name = NoteFile.file_name(file)
    note = NoteFile.note(file)

    updated = Map.put(db.db, file_name, note)
    %{db | db: updated}
  end

  @doc """
  Get a `Notoriety.Note` out of the `NoteDb` per the given file name.
  """
  def get(%__MODULE__{} = db, file_name) do
    Map.get(db.db, file_name)
  end
end
