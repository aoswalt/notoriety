let (>>) = (f, g, x) => g(f(x));
let (<<) = (f, g, x) => f(g(x));
let peek = a => {
  Js.log(a);
  a;
};

module Tag = {
  type t = string;
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

module Parser = {
  type metaData = {tags: array(string)};

  type matterResult = {
    content: string,
    data: metaData,
    excerpt: string,
  };

  // NOTE(adam): built-in excerpt option requires mutability
  let setExcerptFromContent = result => {
    let excerpt =
      result.content
      ->Js.String.split("\n", _)
      ->Js.Array.shift
      ->Belt.Option.getWithDefault("");

    {...result, excerpt};
  };

  let matter: string => matterResult = [%bs.raw {|
    function (raw) {
      var matter = require('gray-matter');

      var result = matter(raw);

      var rawTags = result.data.tags;

      function toArray(rawT) {
        switch(typeof rawT) {
          case "string":
            return [rawT];
          case "object":
            return Array.isArray(rawTags) ? rawTags : [];
          default:
            return [];
        }
      }

      var tagsArray = toArray(rawTags).filter(t => typeof t === "string");

      return {
        ...result,
        data: {
          ...result.data,
          tags: tagsArray
        }
      }
    }
  |}];

  let handleMatter = (raw: string): Belt.Result.t(matterResult, string) =>
    switch (matter(raw)) {
    | exception (Js.Exn.Error(err)) =>
      switch (Js.Exn.message(err)) {
      | Some(message) => Error(message)
      | None => Error("Unknown error")
      }
    | result => result->setExcerptFromContent->Ok
    };

  let resultToNote = (result: matterResult): Note.t => {
    let tagList = Belt.List.fromArray(result.data.tags);

    let meta: Meta.t = {title: result.excerpt, tags: tagList};

    {meta, text: result.content};
  };

  let parse = handleMatter >> Belt.Result.map(_, resultToNote);
};

Js.log(
  Parser.parse(
    "---\ntitle: stuff\ntags: abc\n---\na subject\nthis is content",
  ),
);
