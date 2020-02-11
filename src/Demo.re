module File = {
  type name = string;

  type t = {
    fileName: name,
    contents: string,
  };
};

/* module NoteDB = { */
/*   module Comparator = */
/*     Belt.Id.MakeComparable({ */
/*       type t = File.name; */
/*       let cmp = compare; */
/*     }); */

/*   type t = Belt.Map.t(File.name, Note.t, Comparator.identity); */
/*   /1*   let make = Belt.Map.make(~id=(module Comparator)); *1/ */
/* }; */

/* module TagDB = { */
/*   module Comparator = */
/*     Belt.Id.MakeComparable({ */
/*       type t = Tag.t; */
/*       let cmp = compare; */
/*     }); */

/*   type t = Belt.Map.t(Tag.t, File.name, Comparator.identity); */
/*   /1*   let make = Belt.Map.make(~id=(module Comparator)); *1/ */
/* }; */
