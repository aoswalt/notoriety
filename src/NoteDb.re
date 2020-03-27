type t = Belt.Map.t(FileName.t, Note.t, FileName.Comparator.identity);

let get: (FileName.t, t) => option(Note.t) = (name, db) => Belt.Map.get(db, name);
let set: (FileName.t, Note.t, t) => t = (name, note, db) => Belt.Map.set(db, name, note);

let make: list((FileName.t, Note.t)) => t =
  Belt.List.reduce(
    _,
    Belt.Map.make(~id=(module FileName.Comparator)),
    (db, (name, note)) => set(name, note, db),
  );
