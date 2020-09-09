defmodule Notoriety do
  alias Notoriety.Index
  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.NoteFile
  alias Notoriety.TagDb

  def generate_index(opts \\ []) do
    path = Keyword.get(opts, :path, "notes/**/*.md")
    list_files = Keyword.get(opts, :list_files, &source().list_files/1)
    save_index = Keyword.get(opts, :save_index, &source().save_index/1)

    files =
      path
      |> list_files.()
      |> Enum.map(&parse/1)

    tag_db = TagDb.new(files)
    note_db = NoteDb.new(files)

    tag_db
    |> Index.generate(note_db)
    |> save_index.()
  end

  defp source() do
    Application.get_env(:notoriety, :source)
  end

  def parse({file_name, content}) do
    note = Note.parse(content)
    NoteFile.new(file_name, note)
  end
end
