defmodule Notoriety.Index do
  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.TagDb

  def generate(%TagDb{} = tag_db, %NoteDb{} = note_db) do
    tag_db
    |> TagDb.all()
    |> Enum.map(&create_section(&1, note_db))
    |> Enum.join("\n")
  end

  defp create_section({tag, file_names}, note_db) do
    links =
      file_names
      |> Enum.map(fn name ->
        note = NoteDb.get(note_db, name)
        create_link(name, note)
      end)
      |> Enum.map(&"  * #{&1}")
      |> Enum.join("\n")

    "* #{tag}\n" <> links
  end

  defp create_link(file_name, %Note{} = note) do
    "[#{Note.title(note)}](#{file_name})"
  end
end
