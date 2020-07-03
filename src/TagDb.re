type noteSet = Belt_Set.t(FileName.t, FileName.Comparator.identity);
type t = Belt.Map.t(Tag.t, noteSet, Tag.Comparator.identity);

module NameSet = {
  type t = Belt_Set.t(FileName.t, FileName.Comparator.identity);

  let make = () => Belt.Set.make(~id=(module FileName.Comparator));
};

let get: (Tag.t, t) => option(noteSet) = (tag, db) => Belt.Map.get(db, tag);

let tagNote: (FileName.t, Tag.t, t) => t =
  (name, tag, db) =>
    Belt.Map.update(
      db,
      tag,
      fun
      | Some(set) => set->Belt.Set.add(name)->Some
      | None => NameSet.make()->Belt.Set.add(name)->Some,
    );

let make: list((FileName.t, list(Tag.t))) => t =
  noteTags =>
    noteTags
    ->Belt.List.map(((name, tags)) => List.map(t => (name, t), tags))
    ->List.flatten
    ->Belt.List.reduce(
        Belt.Map.make(~id=(module Tag.Comparator)), (db, (name, tag)) =>
        tagNote(name, tag, db)
      );

let untagNote: (t, (FileName.t, Tag.t)) => t =
  (db, (name, tag)) =>
    Belt.Map.update(
      db,
      name,
      fun
      | Some(set) => set->Belt.Set.remove(tag)->Some
      | None => Some(NameSet.make()),
    );

let hasTag: (FileName.t, Tag.t, t) => bool =
  (name, tag, db) =>
    db
    ->Belt.Map.get(name)
    ->(
        fun
        | Some(set) => Belt.Set.has(set, tag)
        | None => false
      );
