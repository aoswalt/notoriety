defmodule Notoriety.Index do
  @moduledoc """
  Generation of an markdown index of tags to note links
  """

  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.TagDb

  require EEx

  # TODO(adam): what about this taking a simple list of the files instead?
  @doc """
  Produce a markdown index from a `Notoriety.TagDb` and `Notoriety.NoteDb`
  """
  def generate(%TagDb{} = tag_db, %NoteDb{} = note_db) do
    tag_db
    |> build_tags(note_db)
    |> index_or_message()
    |> generate_index_file()
  end

  @doc false
  def build_tags(tag_db, note_db) do
    tag_db
    |> TagDb.all()
    |> Map.new(&get_link_data(&1, note_db))
  end

  defp get_link_data({tag, file_names}, note_db) do
    links =
      file_names
      |> Enum.map(fn name ->
        title = note_db |> NoteDb.get(name) |> Note.title()

        %{title: title, path: name}
      end)
      |> Enum.sort_by(& &1.title)

    {tag, links}
  end

  defp index_or_message(data) when map_size(data) == 0, do: "No tagged notes found\n"
  defp index_or_message(data), do: generate_index(data)

  EEx.function_from_file(:def, :generate_index, "lib/index.md.eex", [:tags], trim: true)

  EEx.function_from_file(:def, :generate_index_file, "lib/index_file.md.eex", [:index], trim: true)
end
