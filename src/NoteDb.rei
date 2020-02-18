type t;
type entry = (FileName.t, Note.t);

let make: array(entry) => t;
let get: (FileName.t, t) => option(Note.t);
let set: (entry, t) => t;
