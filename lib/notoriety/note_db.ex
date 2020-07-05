defmodule Notoriety.NoteDb do
  @moduledoc """
  A collection of file names to their files
  """

  alias Notoriety.NoteFile

  defstruct db: %{}

  def new(files \\ []) do
    Enum.reduce(files, %__MODULE__{}, &put(&2, &1))
  end

  def put(%__MODULE__{} = db, %NoteFile{} = file) do
    file_name = NoteFile.file_name(file)
    note = NoteFile.note(file)

    updated = Map.put(db.db, file_name, note)
    %{db | db: updated}
  end

  def get(%__MODULE__{} = db, file_name) do
    Map.get(db.db, file_name)
  end
end
