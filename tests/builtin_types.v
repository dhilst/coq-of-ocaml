Require Import CoqOfOCaml.CoqOfOCaml.
Require Import CoqOfOCaml.Settings.

Definition n : int := 12.

Definition c1 : char := "a" % char.

Definition c2 : char := "010" % char.

Definition c3 : char := "009" % char.

Definition c4 : char := """" % char.

Definition s : string := "hi\n\t:)\""".

Definition b1 : bool := false.

Definition b2 : bool := true.

Definition u : unit := tt.

Definition l1 {A : Set} : list A := nil.

Definition l2 : list int := [ 0; 1; 2; 3 ].

Definition o : option int :=
  if b1 then
    None
  else
    Some n.
