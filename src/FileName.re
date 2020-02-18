type t = string;
type t_ = t;

let make = name => name;

module Comparator =
  Belt.Id.MakeComparable({
    type t = t_;
    let cmp = compare;
  });
