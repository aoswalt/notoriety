defmodule Notoriety.NoteFileTest do
  use ExUnit.Case, async: true

  alias Notoriety.Note
  alias Notoriety.NoteFile

  setup [:sample]

  test "file_name/1 returns the file name", %{file_name: file_name, note_file: nf} do
    assert NoteFile.file_name(nf) == file_name
  end

  test "note/1 returns the note", %{note: note, note_file: nf} do
    assert NoteFile.note(nf) == note
  end

  defp sample(_) do
    file_name = "fname"
    note = Note.new(text: "text")

    [
      file_name: file_name,
      note: note,
      note_file: NoteFile.new(file_name, note)
    ]
  end
end
