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

describe("Parsing without front matter", () => {
  open Expect;

  test("gets text with one line", () => {
    firstLine
    ->Parser.parse
    ->Belt.Result.map(Note.text)
    ->Belt.Result.getWithDefault("error")
    ->expect
    |> toEqual(firstLine)
  });

  test("gets text with multiple lines", () => {
    multiLine
    ->Parser.parse
    ->Belt.Result.map(Note.text)
    ->Belt.Result.getWithDefault("error")
    ->expect
    |> toEqual(multiLine)
  });
});

describe("Parsing with front matter", () => {
  open Expect;

  let frontMatterWithSingleLine = frontMatterWithTags ++ firstLine;

  test("gets text with one line", () => {
    frontMatterWithSingleLine
    ->Parser.parse
    ->Belt.Result.map(Note.text)
    ->Belt.Result.getWithDefault("error")
    ->expect
    |> toEqual(firstLine)
  });

  let frontMatterWithMultiLine = frontMatterWithTags ++ multiLine;

  test("gets text with multiple lines", () => {
    frontMatterWithMultiLine
    ->Parser.parse
    ->Belt.Result.map(Note.text)
    ->Belt.Result.getWithDefault("error")
    ->expect
    |> toEqual(multiLine)
  });
});
