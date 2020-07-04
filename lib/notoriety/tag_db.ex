defmodule Notoriety.TagDb do
  @moduledoc """
  A collection of tags to sets of file names
  """

  alias Notoriety.Note
  alias Notoriety.NoteFile

  defstruct db: %{}

  def new(), do: %__MODULE__{}

  def insert(%__MODULE__{} = db, %NoteFile{} = file) do
    file_name = NoteFile.file_name(file)

    file
    |> NoteFile.note()
    |> Note.tags()
    |> Enum.reduce(db, &tag_note(&2, file_name, &1))
  end

  def get(%__MODULE__{} = db, tag) do
    Map.get(db.db, tag, [])
  end

  defp tag_note(%__MODULE__{} = db, file_name, tag) do
    updated = Map.update(db.db, tag, MapSet.new([file_name]), &MapSet.put(&1, file_name))
    %{db | db: updated}
  end
end
