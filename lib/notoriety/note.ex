defmodule Notoriety.Note.Meta do
  @moduledoc false

  defstruct title: nil, tags: []
end

defmodule Notoriety.Note do
  @moduledoc """
  A `Note` is the focal point of Notoriety, representing a markdown file with
  any tags parsed out of yaml front matter.

  """

  alias Notoriety.Note.Meta

  @doc """
  A parsed `Note` is a set of its contents and metadata to be created and
  manipulated via the `Notoriety.Note` module.
  """
  defstruct meta: %Meta{}, text: nil

  @doc """
  Construct a new `Note` using the given options.

  Options:
    * `:text` (required) - the contents of the note without the front matter
    * `:tags` - any tags for the note
    * `:title` - the specific title for the note, computed from the text if not
      given
  """
  def new(opts) do
    text = Keyword.fetch!(opts, :text)
    tags = Keyword.get(opts, :tags, []) |> List.wrap()
    title = Keyword.get_lazy(opts, :title, get_title(text))

    %__MODULE__{
      meta: %Meta{
        title: title,
        tags: tags
      },
      text: text
    }
  end

  defp get_title(text) do
    fn ->
      text
      |> String.split("\n", trim: true)
      |> List.first()
      |> String.replace(~r/#+\s+/, "")
    end
  end

  # TODO(adam): compute missing title on the fly instead of at construction?
  @doc """
  Return the `Note`'s title.
  """
  def title(%__MODULE__{meta: meta}), do: meta.title

  @doc """
  Return the `Note`'s text.
  """
  def text(%__MODULE__{text: text}), do: text

  @doc """
  Return the `Note`'s tags.
  """
  def tags(%__MODULE__{meta: meta}), do: meta.tags

  @doc """
  Check if the note has the given tag.
  """
  def has_tag?(%__MODULE__{meta: meta}, tag), do: Enum.member?(meta.tags, tag)

  @doc """
  Parse a markdown file into a `Note`, extracting any tags given in the front
  matter if available.

  Currently returns a `Note` in _all_ cases; if the front matter fails to parse,
  it is simply included as a part of the text instead of being trimmed.
  """
  def parse(raw) do
    case YamlFrontMatter.parse(raw) do
      {:ok, front_matter, body} ->
        tags = Map.get(front_matter, "tags", []) |> List.wrap()
        new(text: body, tags: tags)

      # TODO(adam): consider checking for attempted front matter
      {:error, :invalid_front_matter} ->
        new(text: raw)
    end
  end
end
