module Tag: {
  type t;

  let make: string => t;
} = {
  type t = string;

  let make = tag => tag;
};

module Note: {
  type t;

  let make: (~title: string, ~tags: list(Tag.t), ~text: string) => t;
  let text: t => string;
} = {
  type t = {
    meta,
    text: string,
  }
  and meta = {
    title: string,
    tags: list(Tag.t),
  };

  let make = (~title, ~tags, ~text) => {
    meta: {
      title,
      tags,
    },
    text,
  };

  let text = note => note.text;
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
