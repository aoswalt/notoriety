type tag = string;

type meta = {
  title: string,
  tags: array(tag),
  createdAt: Js.Date.t,
  modifiedAt: Js.Date.t,
};

type note = {
  meta,
  text: string,
};

type fileName = string;

// type noteFile = {
//   fileName: fileName,
//   contents: string
// }

type noteEntry = {
  fileName,
  note,
};

module FileNameComparator =
  Belt.Id.MakeComparable({
    type t = string;
    let cmp = compare;
  });

type noteDb = Belt.Map.t(fileName, note, FileNameComparator.identity);
/* let noteDb = Belt.Map.make(~id=(module FileNameComparator)); */

// type tagDb = {
//   [tag: string]: fileName
// }

Js.log("Hello, BuckleScript and Reason!");
