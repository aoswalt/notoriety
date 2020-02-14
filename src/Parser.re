open Ops;

type parseResult = {
  body: string,
  title: string,
  tags: list(string),
};

let delimiter = "---";
let isDelimiter = line => line == delimiter;

let split = Js.String.split("\n") >> Belt.List.fromArray;

let hasFrontMatter = lines => {
  let startsWithDelimiter =
    lines |> Array.of_list |> Js.Array.findIndex(isDelimiter) == 0;

  let atLeast2 = lines |> List.filter(isDelimiter) |> List.length >= 2;

  startsWithDelimiter && atLeast2;
};

let separateFrontMatter =
  fun
  | lines when !hasFrontMatter(lines) => (None, lines)
  | [first, ...lines] when first == delimiter => {
      let secondIndex = lines |> Array.of_list |> Js.Array.indexOf(delimiter);

      switch (Belt.List.splitAt(lines, secondIndex)) {
      | Some((fm, [_, ...contents])) => (Some(fm), contents)
      | Some((fm, contents)) => (Some(fm), contents) // impossible?
      | None => (None, lines)
      };
    }
  | lines => (None, lines);

let toString =
  fun
  | `String(tag) => tag
  | _ => "";

let keepNonEmpty = tag => tag != "";

let getTags =
  fun
  | `Object(pairs) =>
    pairs
    |> List.find_opt(((k, _v)) => k == "tags")
    |> (
      fun
      | Some((_, tags)) => tags
      | None => `Null
    )
  | _ => `Null;

let toTagList =
  fun
  | `Array(tags) => tags |> List.map(toString) |> List.filter(keepNonEmpty)
  | `String(tag) => [tag]
  | _ => [];

let toParseResult = ((fm, lines)) => {
  let tags =
    switch (fm) {
    | None => []
    | Some(fm) =>
      fm
      |> Array.of_list
      |> Js.Array.joinWith("\n")
      |> Yaml.parse
      |> getTags
      |> toTagList
    };

  {
    body: lines |> Array.of_list |> Js.Array.joinWith("\n"),
    title: List.hd(lines),
    tags,
  };
};

let resultToNote = result =>
  Note.make(
    ~title=result.title,
    ~tags=List.map(Tag.make, result.tags),
    ~text=result.body,
  );

let parse = split >> separateFrontMatter >> toParseResult >> resultToNote;
