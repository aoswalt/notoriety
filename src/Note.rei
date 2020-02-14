type t;

let make: (~title: string, ~tags: list(Tag.t), ~text: string) => t;

let text: t => string;
let hasTag: (Tag.t, t) => bool;
