module Comparator =
  Belt.Id.MakeComparable({
    type t = FileName.t;
    let cmp = compare;
  });

type t = Belt.Map.t(FileName.t, Note.t, Comparator.identity);
type entry = (FileName.t, Note.t);

let make = Belt.Map.fromArray(~id=(module Comparator));

let get = (name, db) => Belt.Map.get(db, name);
let set = ((name, note), db) => Belt.Map.set(db, name, note);
