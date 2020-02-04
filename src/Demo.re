/**
  string -> { meta or incomplete, content }
  incomplete meta -> fields may be null
  */
module Tag = {
  type t = string;

  let isTag = (tag): bool => Js.typeof(tag) == "string";
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
      (result.content |> Js.String.split("\n"))
      ->Js.Array.shift
      ->Belt.Option.getWithDefault("");

    {...result, excerpt};
  };

  [@bs.module] external matter: string => matterResult = "gray-matter";

  module Tags = {
    type arr =
      | Arr(array(string));

    let handleOption = Js.Option.getWithDefault([||]);

    /* causes a type unification error */
    /* let ensureArray = tags => */
    /*   switch (Js.typeof(tags)) { */
    /*   | "string" => [|tags|] */
    /*   | "object" => Js.Array.isArray(tags) ? tags : [||] */
    /*   | _ => [||] */
    /*   }; */

    let ensureArray = tags =>
      switch (Js.typeof(tags)) {
      | "string" => Arr(tags)
      | "object" => Js.Array.isArray(tags) ? Arr(tags) : Arr([||])
      | _ => Arr([||])
      };

    let unwrapArr = (ar: arr): array(string) =>
      switch (ar) {
      | Arr(a) => a
      };

    let ensureTags = Js.Array.filter(Tag.isTag);

    let parseTags = (result: matterResult): matterResult => {
      let parsedTags =
        result.data.tags->handleOption->ensureArray->unwrapArr->ensureTags;

      {
        ...result,
        data: {
          tags: Some(parsedTags),
        },
      };
    };
  };

  let parse = (raw: string): Belt.Result.t(matterResult, string) =>
    switch (matter(raw)) {
    | exception (Js.Exn.Error(err)) =>
      switch (Js.Exn.message(err)) {
      | Some(message) => Error(message)
      | None => Error("Unknown error")
      }
    | parsed => parsed->Tags.parseTags->setExcerpt->Ok
    };
};

Js.log(Parser.parse("---\ntitle: stuff\n---\na subject\nthis is content"));
