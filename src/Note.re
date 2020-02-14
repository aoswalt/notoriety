type t = {
  meta,
  text: string,
}
and meta = {
  title: string,
  tags: list(Tag.t),
};

let make = (~title, ~tags, ~text) => {
  meta: {
    title,
    tags,
  },
  text,
};

let text = note => note.text;

let hasTag = (tag, note) => List.mem(tag, note.meta.tags);
