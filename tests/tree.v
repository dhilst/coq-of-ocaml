Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Inductive tree : Set :=
| Leaf : tree
| Node : tree -> int -> tree -> tree.

Fixpoint find (x : int) (t : tree) : bool :=
  match t with
  | Leaf => false
  | Node t1 x' t2 =>
    if OCaml.Stdlib.lt x x' then
      find x t1
    else
      if OCaml.Stdlib.lt x' x then
        find x t2
      else
        true
  end.
