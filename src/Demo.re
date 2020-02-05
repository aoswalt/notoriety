let (>>) = (f, g, x) => g(f(x));
let (<<) = (f, g, x) => f(g(x));

module Tag = {
  type t = string;

  let isTag = (tag): bool => Js.typeof(tag) == "string";
};

module Meta = {
  type t = {
    title: string,
    tags: list(Tag.t),
  };
};

module Note = {
  type t = {
    meta: Meta.t,
    text: string,
  };
};

module File = {
  type name = string;

  type t = {
    fileName: name,
    contents: string,
  };
};

module NoteDB = {
  module Comparator =
    Belt.Id.MakeComparable({
      type t = File.name;
      let cmp = compare;
    });

  type t = Belt.Map.t(File.name, Note.t, Comparator.identity);
  /*   let make = Belt.Map.make(~id=(module Comparator)); */
};

module TagDB = {
  module Comparator =
    Belt.Id.MakeComparable({
      type t = Tag.t;
      let cmp = compare;
    });

  type t = Belt.Map.t(Tag.t, File.name, Comparator.identity);
  /*   let make = Belt.Map.make(~id=(module Comparator)); */
};

module TagsArray = {
  let handleOption = Js.Option.getWithDefault([||]);

  type anArray =
    | AnArray(array(string));

  let ensureArray = (tags): anArray =>
    switch (Js.typeof(tags)) {
    | "string" => AnArray(tags)
    | "object" => Js.Array.isArray(tags) ? AnArray(tags) : AnArray([||])
    | _ => AnArray([||])
    };

  let unwrapAnArray = (AnArray(arr): anArray): array(string) => arr;

  let ensureTagsContent = Js.Array.filter(Tag.isTag);

  let parse =
    handleOption >> ensureArray >> unwrapAnArray >> ensureTagsContent;
};

module Parser = {
  // wrap string in array?
  type metaData = {tags: option(array(string))};

  type matterResult = {
    content: string,
    data: metaData,
    excerpt: string,
  };

  // NOTE(adam): built-in excerpt option requires mutability
  let setExcerpt = result => {
    let excerpt =
      result.content
      ->Js.String.split("\n", _)
      ->Js.Array.shift
      ->Belt.Option.getWithDefault("");

    {...result, excerpt};
  };

  [@bs.module] external matter: string => matterResult = "gray-matter";

  let parseTags = (result: matterResult): matterResult => {
    let parsedTags = TagsArray.parse(result.data.tags);

    {
      ...result,
      data: {
        tags: Some(parsedTags),
      },
    };
  };

  let parseMatter = (raw: string): Belt.Result.t(matterResult, string) =>
    switch (matter(raw)) {
    | exception (Js.Exn.Error(err)) =>
      switch (Js.Exn.message(err)) {
      | Some(message) => Error(message)
      | None => Error("Unknown error")
      }
    | parsed => parsed->parseTags->setExcerpt->Ok
    };

  let resultToNote = (result: matterResult): Note.t => {
    let tagList =
      result.data.tags->Belt.Option.getWithDefault([||])->Belt.List.fromArray;

    let meta: Meta.t = {title: result.excerpt, tags: tagList};

    {meta, text: result.content};
  };

  let parse = parseMatter >> Belt.Result.map(_, resultToNote);
};

Js.log(
  Parser.parse(
    "---\ntitle: stuff\ntags: [abc, def]\n---\na subject\nthis is content",
  ),
);
