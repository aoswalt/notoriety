let (>>) = (f, g, x) => g(f(x));
let (<<) = (f, g, x) => f(g(x));

let peek = a => {
  Js.log(a);
  a;
};

let peek2 = (l, a) => {
  Js.log2(l, a);
  a;
};
