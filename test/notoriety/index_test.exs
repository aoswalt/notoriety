defmodule Notoriety.IndexTest do
  use ExUnit.Case, async: true

  alias Notoriety.Index
  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.NoteFile
  alias Notoriety.TagDb

  setup [:sample_data]

  test "generating an index has the expected notes", ctx do
    index = Index.generate(ctx.tag_db, ctx.note_db, :default)

    refute index =~ Note.title(ctx.note1)
    assert ctx.note2 |> Note.title() |> Regex.compile!() |> Regex.scan(index) |> length() == 1
    assert ctx.note3 |> Note.title() |> Regex.compile!() |> Regex.scan(index) |> length() == 2
    refute index =~ Note.title(ctx.note4)
  end

  test "building tag mapping", ctx do
    mapping = Index.build_tags(ctx.tag_db, ctx.note_db)

    assert mapping["abc"] |> length() == 2
    assert mapping["def"] |> length() == 1
  end

  test "using a different template", ctx do
    index = Index.generate(ctx.tag_db, ctx.note_db, "test/support/test_index_template.md.eex")

    assert index =~ "Test Template"

    refute index =~ Note.title(ctx.note1)
    assert ctx.note2 |> Note.title() |> Regex.compile!() |> Regex.scan(index) |> length() == 1
    assert ctx.note3 |> Note.title() |> Regex.compile!() |> Regex.scan(index) |> length() == 2
    refute index =~ Note.title(ctx.note4)
  end

  defp sample_data(_) do
    fn1 = "file1"
    note1 = Note.new(text: "note text 1")
    f1 = NoteFile.new(fn1, note1)

    fn2 = "file2"
    tags2 = ["abc"]
    note2 = Note.new(text: "note text 2", tags: tags2)
    f2 = NoteFile.new(fn2, note2)

    fn3 = "file3"
    tags3 = ["abc", "def"]
    note3 = Note.new(text: "note text 3", tags: tags3)
    f3 = NoteFile.new(fn3, note3)

    fn4 = "file4"
    tags4 = ["def"]
    note4 = Note.new(text: "note text 4", tags: tags4)
    f4 = NoteFile.new(fn4, note4)

    note_db = NoteDb.new([f1, f2, f3])
    tag_db = TagDb.new([f1, f2, f3])

    [
      note1: note1,
      f1: f1,
      tags2: tags2,
      note2: note2,
      f2: f2,
      tags3: tags3,
      note3: note3,
      f3: f3,
      tags4: tags4,
      note4: note4,
      f4: f4,
      note_db: note_db,
      tag_db: tag_db
    ]
  end
end
