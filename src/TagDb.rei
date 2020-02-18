type t;
type entry = (FileName.t, Tag.t);

let make: list(entry) => t;
let tagNote: (entry, t) => t;
let untagNote: (entry, t) => t;
let hasTag: (FileName.t, Tag.t, t) => bool;
let notesWithTag: (Tag.t, t) => list(FileName.t);
