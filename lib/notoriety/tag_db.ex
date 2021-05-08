defmodule Notoriety.TagDb do
  @moduledoc """
  A collection of tags to sets of file names
  """
  # TODO(adam): how useful is this for the future? could it be mostly eliminated?

  alias Notoriety.Note
  alias Notoriety.NoteFile

  defstruct db: %{}

  @doc """
  Construct a `TagDb` given a list of `Notoriety.NoteFile`s.
  """
  def new(files \\ []) do
    Enum.reduce(files, %__MODULE__{}, &insert(&2, &1))
  end

  @doc """
  Extract the file name and tags from a `Notoriety.NoteFile` and insert the file
  name under each of the tags.
  """
  def insert(%__MODULE__{} = db, %NoteFile{} = file) do
    file_name = NoteFile.file_name(file)

    file
    |> NoteFile.note()
    |> Note.tags()
    |> case do
      [] -> [:untagged]
      tags -> tags
    end
    |> Enum.reduce(db, &tag_note(&2, file_name, &1))
  end

  @doc """
  Return all stored tags to file names from the `TagDb`.

  Options:
  * `:untagged` - whether to include untagged notes
      * `:include` - include untagged notes
      * `:only` - only return untagged notes
  """
  def all(%__MODULE__{} = db, opts \\ []) do
    case Keyword.get(opts, :untagged) do
      :include -> db.db
      :only -> Map.take(db.db, [:untagged])
      _ -> Map.delete(db.db, :untagged)
    end
  end

  @doc """
  Get the list of file names for the given tag from the `TagDb`.
  """
  def get(%__MODULE__{} = db, tag) do
    Map.get(db.db, tag, [])
  end

  defp tag_note(%__MODULE__{} = db, file_name, tag) do
    updated = Map.update(db.db, tag, MapSet.new([file_name]), &MapSet.put(&1, file_name))
    %{db | db: updated}
  end
end
