defmodule Notoriety.TagDbTest do
  use ExUnit.Case, async: true

  alias Notoriety.Note
  alias Notoriety.NoteFile
  alias Notoriety.TagDb

  setup [:sample_data]

  test "storing file names by tag", %{db: db} = ctx do
    [t2_1] = ctx.tags2
    assert TagDb.get(db, t2_1) |> MapSet.size() == 2

    [t3_1, t3_2] = ctx.tags3
    assert TagDb.get(db, t3_1) |> MapSet.size() == 2
    assert TagDb.get(db, t3_2) |> MapSet.size() == 1

    [t4_1] = ctx.tags4
    assert TagDb.get(db, t4_1) |> MapSet.size() == 1
    refute TagDb.get(db, t4_1) |> Enum.member?(ctx.fn4)

    db = TagDb.insert(db, ctx.f4)

    assert TagDb.get(db, t4_1) |> MapSet.size() == 2
    assert TagDb.get(db, t4_1) |> Enum.member?(ctx.fn4)
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

    db = TagDb.new([f1, f2, f3])

    [
      fn1: fn1,
      note1: note1,
      f1: f1,
      fn2: fn2,
      tags2: tags2,
      note2: note2,
      f2: f2,
      fn3: fn3,
      tags3: tags3,
      note3: note3,
      f3: f3,
      fn4: fn4,
      tags4: tags4,
      note4: note4,
      f4: f4,
      db: db
    ]
  end
end
