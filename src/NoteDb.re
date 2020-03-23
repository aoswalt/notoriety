open Ops;

type t = Belt.Map.t(FileName.t, Note.t, FileName.Comparator.identity);
type entry = (FileName.t, Note.t);

let get: (FileName.t, t) => option(Note.t) = flip(Belt.Map.get);
let set: (entry, t) => t = ((name, note), db) => Belt.Map.set(db, name, note);

let make: list(entry) => t =
  Belt.List.reduce(
    _,
    Belt.Map.make(~id=(module FileName.Comparator)),
    flip(set),
  );
