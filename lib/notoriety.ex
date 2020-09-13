defmodule Notoriety do
  @moduledoc """
  Generate an index of notes grouped by their tags.
  """

  alias Notoriety.Index
  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.NoteFile
  alias Notoriety.TagDb

  @doc """
  Read files per the given path and generate an index file of notes grouped by
  tags.

  Uses the `Notoriety.Source` specified by the `:source` config key.

  Options:
    * `:input_path` (required) - the path pattern to read files from
    * `:output_file` (required) - the path to save the resulting index
    * `:list_files` - override the `list_files/2` function from the configured `Notoriety.Source`
    * `:save_index` - override the `save_index/2` function from the configured `Notoriety.Source`
  """
  def generate_index(opts) do
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

  @doc false
  def parse({file_name, content}) do
    note = Note.parse(content)
    NoteFile.new(file_name, note)
  end
end
