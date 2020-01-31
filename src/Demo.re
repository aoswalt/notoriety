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

type metaData = {
  title: option(string),
  tags: option(array(string)),
  createdAt: option(Js.Date.t),
  modifiedAt: option(Js.Date.t),
};

type parseResult = {
  content: string,
  data: metaData,
};

[@bs.module] external matter: string => parseResult = "gray-matter";

let fn = (n: int) : int => n * 2;

Js.log(
  matter(""),
);
