module File = {
  type t = {
    fileName: FileName.t,
    contents: string,
  };
};

/* module TagDB = { */
/*   module Comparator = */
/*     Belt.Id.MakeComparable({ */
/*       type t = Tag.t; */
/*       let cmp = compare; */
/*     }); */

/*   type t = Belt.Map.t(Tag.t, File.name, Comparator.identity); */
/*   /1*   let make = Belt.Map.make(~id=(module Comparator)); *1/ */
/* }; */
