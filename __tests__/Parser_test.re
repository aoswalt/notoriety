let validOneLine = {|First line|};

let validMultiLine = {|First line
Another line

And some more text
|};

let validFrontMatterWithTags = {|---
tags: [abc]
---
First line
|};

open Jest;

let extractText =
  fun
  | Ok({Demo.Note.text}) => text
  | Error(_) => "error";

describe("Parsing without front matter", () => {
  Expect.(
    test("works with one line", () => {
      validOneLine->Demo.Parser.parse->extractText->expect
      |> toEqual("First line")
    })
  )
});
