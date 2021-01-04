Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Definition option_value {a : Set} (x : option a) (default : a) : a :=
  match x with
  | Some x => x
  | None => default
  end.

Definition option_zero : option int -> int := fun x_1 => option_value x_1 0.

Definition option_value_bis {A : Set} : option A -> A -> A := option_value.
