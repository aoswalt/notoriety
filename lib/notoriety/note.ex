defmodule Notoriety.Note.Meta do
  @moduledoc false

  defstruct title: nil, tags: []
end

defmodule Notoriety.Note do
  alias Notoriety.Note.Meta

  defstruct meta: %Meta{}, text: nil

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

  def title(%__MODULE__{meta: meta}), do: meta.title

  def text(%__MODULE__{text: text}), do: text

  def tags(%__MODULE__{meta: meta}), do: meta.tags

  def has_tag?(%__MODULE__{meta: meta}, tag), do: Enum.member?(meta.tags, tag)
end
