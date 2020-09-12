defmodule Notoriety do
  alias Notoriety.Index
  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.NoteFile
  alias Notoriety.TagDb

  def generate_index(opts \\ []) do
    input_path = Keyword.fetch!(opts, :input_path)
    list_files = Keyword.get(opts, :list_files, &source().list_files/1)
    save_index = Keyword.get(opts, :save_index, &source().save_index/2)
    output_file = Keyword.fetch!(opts, :output_file)

    files =
      input_path
      |> list_files.()
      |> Enum.map(&parse/1)

    tag_db = TagDb.new(files)
    note_db = NoteDb.new(files)

    tag_db
    |> Index.generate(note_db)
    |> save_index.(output_file)
  end

  defp source() do
    Application.get_env(:notoriety, :source)
  end

  def parse({file_name, content}) do
    note = Note.parse(content)
    NoteFile.new(file_name, note)
  end
end
