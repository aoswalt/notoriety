open Jest;

let firstLine = "First line";

let multiLine = firstLine ++ {|
Another line

And some more text
|};

let frontMatterWithTags = {|---
tags: [abc]
---
|};

let malformedFrontMatter = {|---
tags:
---
|};

describe("Parsing without front matter", () => {
  open Expect;

  test("gets text with one line", () => {
    firstLine |> Parser.parse |> Note.text |> expect |> toEqual(firstLine)
  });

  test("gets text with multiple lines", () => {
    multiLine |> Parser.parse |> Note.text |> expect |> toEqual(multiLine)
  });
});

describe("Parsing with front matter", () => {
  open Expect;

  let frontMatterWithSingleLine = frontMatterWithTags ++ firstLine;

  test("gets text with one line", () => {
    frontMatterWithSingleLine
    |> Parser.parse
    |> Note.text
    |> expect
    |> toEqual(firstLine)
  });

  let frontMatterWithMultiLine = frontMatterWithTags ++ multiLine;

  test("gets text with multiple lines", () => {
    frontMatterWithMultiLine
    |> Parser.parse
    |> Note.text
    |> expect
    |> toEqual(multiLine)
  });

  let tag = Tag.make("abc");

  test("has the tag specified", () => {
    frontMatterWithMultiLine
    |> Parser.parse
    |> Note.hasTag(tag)
    |> expect
    |> toBe(true)
  });

  test("handles malformed front matter", () => {
    malformedFrontMatter ++ multiLine
    |> Parser.parse
    |> Note.text
    |> expect
    |> toBe(multiLine)
  })
});
