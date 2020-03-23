module Comparator =
  Belt.Id.MakeComparable({
    type t = string;
    let cmp = compare;
  });

type t = Comparator.t;

let make: string => t = name => name;
