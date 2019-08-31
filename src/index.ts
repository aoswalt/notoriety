import matter from 'gray-matter'

// NOTE(adam): from https://ctidd.com/2018/typescript-result-type
type Result<T> = T | Error

export function ok<T>(r: Result<T>): r is T {
  return !(r instanceof Error)
}

type FileName = string

// type Tag = string

interface Meta {
  readonly title: string
  readonly tags: string[]
  readonly createdAt: Date
  readonly modifiedAt: Date
}

interface Note {
  readonly meta: Meta
  readonly text: string
}

// interface NoteFile {
//   readonly fileName: FileName
//   readonly contents: string
// }

interface NoteEntry {
  readonly fileName: FileName
  readonly note: Note
}

interface NoteDb {
  [fileName: string]: Note
}

// interface TagDb {
//   [tag: string]: FileName
// }

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
