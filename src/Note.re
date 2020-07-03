type t = {
  meta,
  text: string,
}
and meta = {
  title: string,
  tags: list(Tag.t),
};

let make: (~title: string, ~tags: list(Tag.t), ~text: string) => t =
  (~title, ~tags, ~text) => {
    meta: {
      title,
      tags,
    },
    text,
  };

let text: t => string = note => note.text;

let hasTag: (t, Tag.t) => bool =
  (note, tag) => List.mem(tag, note.meta.tags);
