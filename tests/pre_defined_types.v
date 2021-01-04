Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Definition u : unit := tt.

Definition l1 {A : Set} : list A := nil.

Definition l2 : list int := [ 1 ].

Definition l3 : list int := [ 1; 5; 7; 32; 15 ].

Definition o1 {A : Set} : option A := None.

Definition o2 : option int := Some 12.

Definition c : ascii := "g" % char.

Definition s1 : string := "bla".

Definition s2 : string := "\""".
