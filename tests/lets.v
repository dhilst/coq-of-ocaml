Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Definition n1 : int :=
  let m := 12 in
  let n1 := m in
  n1.

Definition n2 : int :=
  let p1 {A B C : Set} (c : (A -> B -> A) -> C) : C :=
    c (fun x => fun y => x) in
  let c {A : Set} (f : int -> int -> A) : A :=
    f 12 23 in
  p1 c.
