type t = string;
type t_ = t;

let make = tag => tag;

module Comparator =
  Belt.Id.MakeComparable({
    type t = t_;
    let cmp = compare;
  });
