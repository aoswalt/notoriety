open Ops;

type noteSet = Belt_Set.t(FileName.t, FileName.Comparator.identity);
type t =
  Belt.Map.t(
    Tag.t,
    noteSet,
    Tag.Comparator.identity,
  );

module NameSet = {
  type t = Belt_Set.t(FileName.t, FileName.Comparator.identity);

  let make = () => Belt.Set.make(~id=(module FileName.Comparator));
};

let get: (Tag.t, t) => option(noteSet) = flip(Belt.Map.get);

let tagNote: (FileName.t, Tag.t, t) => t =
  (name, tag, db) =>
    Belt.Map.update(
      db,
      tag,
      fun
      | Some(set) => set |> Belt.Set.add(_, name) |> (s => Some(s))
      | None => NameSet.make() |> Belt.Set.add(_, name) |> (s => Some(s)),
    );

let make: list((FileName.t, list(Tag.t))) => t = noteTags =>
  noteTags
  |> List.map(((name, tags)) => List.map(t => (name, t), tags))
  |> List.flatten
  |> Belt.List.reduce(
    _,
    Belt.Map.make(~id=(module Tag.Comparator)),
    (db, (name, tag)) => tagNote(name, tag, db),
  );

let untagNote: ((FileName.t, Tag.t), t) => t =
  ((name, tag), db) =>
    Belt.Map.update(
      db,
      name,
      fun
      | Some(set) => set |> Belt.Set.remove(_, tag) |> (s => Some(s))
      | None => Some(NameSet.make()),
    );

let hasTag: (FileName.t, Tag.t, t) => bool =
  (name, tag, db) =>
    db
    |> Belt.Map.get(_, name)
    |> (
      fun
      | Some(set) => Belt.Set.has(set, tag)
      | None => false
    );
