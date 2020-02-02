/**
  string -> { meta or incomplete, content }
  incomplete meta -> fields may be null
  */
module Tag = {
  type t = string;
};

module Meta = {
  type t = {
    title: string,
    tags: array(Tag.t),
    createdAt: Js.Date.t,
    modifiedAt: Js.Date.t,
  };

  type incomplete = {
    title: option(string),
    tags: option(array(Tag.t)),
    createdAt: option(Js.Date.t),
    modifiedAt: option(Js.Date.t),
  };
};

module Note = {
  type t = {
    meta: Meta.t,
    text: string,
  };

  type incomplete = {
    meta: Meta.incomplete,
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

module NoteEntry = {
  type t = {
    fleName: File.name,
    note: Note.t,
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

// type tagDb = {
//   [tag: string]: fileName
// }

Js.log("Hello, BuckleScript and Reason!");

/* [@bs.val] external fetch: string => Js.Promise.t('a) = "fetch"; */

module Parser = {
  type metaData = {tags: option(array(string))};

  type parseResult = {
    content: string,
    data: metaData,
    excerpt: string,
  };

  // built-in excerpt option requires mutability
  let setExcerpt = result => {
    let excerpt =
      (result.content |> Js.String.split("\n"))
      ->Js.Array.shift
      ->Belt.Option.getWithDefault("");

    {...result, excerpt};
  };

  [@bs.module] external matter: string => parseResult = "gray-matter";

  let parse = (raw: string) => raw->matter->setExcerpt;

  /* let parse = (raw: string): Belt.Result.t(parseResult, string) => */
  /*   switch (matter(raw)) { */
  /*   | exception (Js.Exn.Error(err)) => */
  /*     (err |> Js.Exn.message |> Js.Option.getWithDefault("Some Js Error")) */
  /*     ->Belt.Result.Error */
  /*   | parsed => Belt.Result.Ok(parsed) */
  /*   }; */

  let toString =
    fun
    | Belt.Result.Error(_) => "fail"
    | Belt.Result.Ok(_) => "ok";
};

let fn = (n: int): int => n * 2;

Js.log(Parser.parse("---\ntitle: stuff\n---\na subject\nthis is content"));
