defmodule Notoriety.NoteDbTest do
  use ExUnit.Case, async: true

  alias Notoriety.Note
  alias Notoriety.NoteDb
  alias Notoriety.NoteFile

  test "storing notes by file_name" do
    fn1 = "file1"
    note1 = Note.new(text: "note text 1")
    f1 = NoteFile.new(fn1, note1)

    fn2 = "file2"
    note2 = Note.new(text: "note text 2")
    f2 = NoteFile.new(fn2, note2)

    fn3 = "file3"
    note3 = Note.new(text: "note text 3")
    f3 = NoteFile.new(fn3, note3)

    db = NoteDb.new([f1, f2])

    assert NoteDb.get(db, fn1) == note1
    assert NoteDb.get(db, fn2) == note2
    refute NoteDb.get(db, fn3) == note3

    db = NoteDb.put(db, f3)

    assert NoteDb.get(db, fn3) == note3
  end
end
