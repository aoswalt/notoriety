import { ok, parseNote } from '../src'

const sampleValidNote = `---
title: A sample valid note
tags: []
createdAt: 2019-08-31
modifiedAt: 2019-08-31
---
This is the content
`

const sampleInvalidNote = `---
title: A sample inavlid note
---
This is the content
`

describe('the api', () => {
  test('note parsing', () => {
    const validResult = parseNote(sampleValidNote)
    expect(ok(validResult)).toBe(true)
    if (ok(validResult)) {
      expect(validResult.text).toMatch(/content/)
    }

    const errorResult = parseNote(sampleInvalidNote)
    expect(ok(errorResult)).toBe(false)
  })
})
