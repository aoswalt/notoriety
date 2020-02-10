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
