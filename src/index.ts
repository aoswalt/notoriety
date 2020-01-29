import matter from 'gray-matter'


export function buildNoteDb(notes: NoteEntry[]): NoteDb {
  return Object.fromEntries(notes.map(({ fileName, note }) => [fileName, note]))
}

/* eslint-disable @typescript-eslint/no-explicit-any */
function isCompleteMeta(object: any): object is Meta {
  return (
    'title' in object &&
    'tags' in object &&
    'createdAt' in object &&
    'modifiedAt' in object
  )
}
/* eslint-enable @typescript-eslint/no-explicit-any */

export function parseNote(fileContents: string): Result<Note> {
  const { data: meta, content: text } = matter(fileContents)

  return isCompleteMeta(meta) ? { meta, text } : new Error('Meta is incomplete')
}
