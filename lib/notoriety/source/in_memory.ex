defmodule Notoriety.Source.InMemory do
  @behaviour Notoriety.Source

  @impl Notoriety.Source
  def list_files(_) do
    bare = """
    # Bare

    this is a bare markdown file
    """

    matter = """
    ---
    some: value
    ---
    # Matter

    this markdown file has front-matter
    """

    tagged = """
    ---
    tags:
      - abc
      - def
    ---
    # Tagged

    a tagged note
    """

    also_tagged = """
    ---
    tags: [abc]
    ---
    # Also Tagged

    a note also tagged
    """

    non_list = """
    ---
    tags: def
    ---
    # Non-List

    a note with tags that isn't a list
    """

    malformed = """
    ----
    tags: [bad, front, matter]
    ---
    # Malformed

    a note with malformed front-matter
    """

    [
      {"bare", bare},
      {"matter", matter},
      {"tagged", tagged},
      {"also_tagged", also_tagged},
      {"non_list", non_list},
      {"malformed", malformed}
    ]
  end

  @impl Notoriety.Source
  def save_index(index, _file_name), do: {:ok, index}
end
