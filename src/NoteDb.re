open Ops;

type t = Belt.Map.t(FileName.t, Note.t, FileName.Comparator.identity);
type entry = (FileName.t, Note.t);

let make = Array.of_list >> Belt.Map.fromArray(~id=(module FileName.Comparator));

let get = (name, db) => Belt.Map.get(db, name);
let set = ((name, note), db) => Belt.Map.set(db, name, note);
