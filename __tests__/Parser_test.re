let firstLine = "First line";

let multiLine = firstLine ++ {|
Another line

And some more text
|};

let frontMatterWithTags = {|---
tags: [abc]
---
|};

open Jest;

let extractText =
  fun
  | Ok({Demo.Note.text}) => text
  | Error(_) => "error";

describe("Parsing without front matter", () => {
  Expect.(
    test("gets text with one line", () => {
      firstLine->Parser.parse->extractText->expect |> toEqual(firstLine)
    })
  );

  Expect.(
    test("gets text with multiple lines", () => {
      multiLine->Parser.parse->extractText->expect |> toEqual(multiLine)
    })
  );
});

describe("Parsing with front matter", () => {
  let frontMatterWithSingleLine = frontMatterWithTags ++ firstLine;

  Expect.(
    test("gets text with one line", () => {
      frontMatterWithSingleLine->Parser.parse->extractText->expect
      |> toEqual(firstLine)
    })
  );

  let frontMatterWithMultiLine = frontMatterWithTags ++ multiLine;

  Expect.(
    test("gets text with multiple lines", () => {
      frontMatterWithMultiLine->Parser.parse->extractText->expect
      |> toEqual(multiLine)
    })
  );
});
