open Ops;

type t =
  Belt.Map.t(
    Tag.t,
    Belt_Set.t(FileName.t, Tag.Comparator.identity),
    Tag.Comparator.identity,
  );
type entry = (FileName.t, Tag.t);

let make = Array.of_list >> Belt.Map.fromArray(~id=(module Tag.Comparator));

let tagNote = ((name, tag), db) =>
  Belt.Map.update(
    db,
    name,
    fun
    | Some(set) => set |> Belt.Set.add(_, tag) |> (s => Some(s))
    | None =>
      Belt.Set.make(~id=(module Tag.Comparator))
      |> Belt.Set.add(_, tag)
      |> (s => Some(s)),
  );

let untagNote = ((name, tag), db) =>
  Belt.Map.update(
    db,
    name,
    fun
    | Some(set) => set |> Belt.Set.remove(_, tag) |> (s => Some(s))
    | None => Belt.Set.make(~id=(module Tag.Comparator)) |> (s => Some(s)),
  );

let hasTag = (name, tag, db) =>
  Belt.Map.get(name)
  >> (
    fun
    | Some(set) => Belt.Set.has(set, tag)
    | None => false
  );

let notesWithTag = (tag, db) =>
  Belt.Map.toList
  >> Belt.List.keep(_, ((_k, v)) => Belt.Set.has(v, tag))
  >> Belt.List.map(_, ((k, _v)) => k);
