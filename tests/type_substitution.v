Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Module Sig.
  Record signature {t : Set} : Set := {
    t := t;
    v : t;
  }.
End Sig.

Reserved Notation "'foo".

Inductive single : Set :=
| C : 'foo string -> single

where "'foo" := (fun (t_a : Set) =>
  t_a * int * {_ : unit @ Sig.signature (t := t_a)}).

Definition foo := 'foo.
