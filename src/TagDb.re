open Ops;

type noteSet = Belt_Set.t(FileName.t, FileName.Comparator.identity);
type t =
  Belt.Map.t(
    Tag.t,
    noteSet,
    Tag.Comparator.identity,
  );
type entry = (FileName.t, Tag.t);

module NameSet = {
  type t = Belt_Set.t(FileName.t, FileName.Comparator.identity);

  let make = () => Belt.Set.make(~id=(module FileName.Comparator));
};

let get: (Tag.t, t) => option(noteSet) = flip(Belt.Map.get);

let tagNote: (entry, t) => t =
  ((name, tag), db) =>
    Belt.Map.update(
      db,
      tag,
      fun
      | Some(set) => set |> Belt.Set.add(_, name) |> (s => Some(s))
      | None => NameSet.make() |> Belt.Set.add(_, name) |> (s => Some(s)),
    );

let make: list(entry) => t =
  Belt.List.reduce(
    _,
    Belt.Map.make(~id=(module Tag.Comparator)),
    flip(tagNote),
  );

let untagNote: (entry, t) => t =
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
