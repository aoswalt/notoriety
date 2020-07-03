type t = Belt.Map.t(FileName.t, Note.t, FileName.Comparator.identity);

let get: (t, FileName.t) => option(Note.t) = (db, name) => Belt.Map.get(db, name);
let set: (t, FileName.t, Note.t) => t = (db, name, note) => Belt.Map.set(db, name, note);

let make: list((FileName.t, Note.t)) => t =
  Belt.List.reduce(
    _,
    Belt.Map.make(~id=(module FileName.Comparator)),
    (db, (name, note)) => set(db, name, note),
  );
