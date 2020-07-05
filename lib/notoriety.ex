defmodule Notoriety do
  alias Notoriety.Index
  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.NoteFile
  alias Notoriety.TagDb

  def generate_index() do
    files =
      source().list_files()
      |> Enum.map(&parse/1)
      |> Enum.reject(&is_nil/1)

    tag_db = TagDb.new(files)
    note_db = NoteDb.new(files)

    Index.generate(tag_db, note_db)
  end

  defp source() do
    Application.get_env(:notoriety, :source)
  end

  defp parse({file_name, content}) do
    case YamlFrontMatter.parse(content) do
      {:ok, front_matter, body} ->
        tags = Map.get(front_matter, "tags", []) |> List.wrap()
        note = Note.new(text: body, tags: tags)
        NoteFile.new(file_name, note)

      {:error, :invalid_front_matter} ->
        nil
    end
  end
end
