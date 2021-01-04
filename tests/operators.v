Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Definition op_plusplusplus (x : int) (y : int) : int := Z.add x y.

Definition op_tildetilde (x : int) : int := Z.opp x.

Definition z : int := op_plusplusplus (op_tildetilde 12) 14.
