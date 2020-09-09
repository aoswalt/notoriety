defmodule Notoriety.NoteTest do
  use ExUnit.Case, async: true

  alias Notoriety.Note

  test "title/1 returns the given title" do
    title = "this title"
    note = Note.new(text: "", title: title)

    assert Note.title(note) == title
  end

  test "title/1 returns first empty text line without title" do
    title = "text title"
    text = "\n\n#{title}"
    note = Note.new(text: text)

    assert Note.title(note) == title
  end

  test "text/1 returns the text" do
    text = "some text"
    note = Note.new(text: text)

    assert Note.text(note) == text
  end

  test "tags/1 returns the tags" do
    tags = ["a", "b", "c"]
    note = Note.new(text: "text", tags: tags)

    assert Note.tags(note) == tags
  end

  test "has_tag?/2 tests if the note has the given tag" do
    tags = ["a", "b", "c"]
    note = Note.new(text: "text", tags: tags)

    assert Note.has_tag?(note, "a")
    refute Note.has_tag?(note, "d")
  end

  describe "parse/1" do
    test "constructs a note from a bare file" do
      raw = """
      # Bare

      this is a bare markdown file
      """

      assert %Note{} = Note.parse(raw)
    end

    test "constructs a note from a file with front-matter" do
      raw = """
      ---
      some: value
      ---
      # Matter

      this markdown file has front-matter
      """

      assert %Note{} = note = Note.parse(raw)
      assert note |> Note.tags() |> length() == 0
    end

    test "constructs a note from a file with tags" do
      raw = """
      ---
      tags:
        - abc
        - def
      ---
      # Tagged

      a tagged note
      """

      assert %Note{} = note = Note.parse(raw)
      assert note |> Note.tags() |> Enum.member?("abc")
      assert note |> Note.tags() |> Enum.member?("def")

      raw = """
      ---
      tags: [abc]
      ---
      # Also Tagged

      a note also tagged
      """

      assert %Note{} = note = Note.parse(raw)
      assert note |> Note.tags() |> Enum.member?("abc")

      raw = """
      ---
      tags: def
      ---
      # Non-List

      a note with tags that isn't a list
      """

      assert %Note{} = note = Note.parse(raw)
      assert note |> Note.tags() |> Enum.member?("def")
    end

    test "gracefully handles malformed frontmatter" do
      malformed_internal = """
      ---
      tags: [bad, front, matter
      ---
      # Malformed Internals

      a note with malformed internals
      """

      assert %Note{} = note = Note.parse(malformed_internal)
      assert Note.tags(note) == []

      malformed_delimiters = """
      ----
      tags: [bad, front, matter]
      ---
      # Malformed Delimiters

      a note with malformed delimiters
      """

      assert %Note{} = note = Note.parse(malformed_delimiters)
      assert Note.tags(note) == []
    end
  end
end
