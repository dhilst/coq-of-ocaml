Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Definition f {A B : Set} (x : A) (y : B) : A := x.

Definition n : int := f 12 3.
