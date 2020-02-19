open Ops;

type t =
  Belt.Map.t(
    Tag.t,
    Belt_Set.t(FileName.t, FileName.Comparator.identity),
    Tag.Comparator.identity,
  );
type entry = (FileName.t, Tag.t);

module NameSet = {
  type t = Belt_Set.t(FileName.t, FileName.Comparator.identity);

  let make = () => Belt.Set.make(~id=(module FileName.Comparator));
};

let tagNote: (entry, t) => t = ((name, tag), db) =>
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

let untagNote = ((name, tag), db) =>
  Belt.Map.update(
    db,
    name,
    fun
    | Some(set) => set |> Belt.Set.remove(_, tag) |> (s => Some(s))
    | None => Some(NameSet.make()),
  );

let hasTag = (name, tag, _db) =>
  Belt.Map.get(name)
  >> (
    fun
    | Some(set) => Belt.Set.has(set, tag)
    | None => false
  );

let notesWithTag = tag =>
  Belt.Map.toList
  >> Belt.List.keep(_, ((_k, v)) => Belt.Set.has(v, tag))
  >> Belt.List.map(_, ((k, _v)) => k);
