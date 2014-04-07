Require Import CoqOfOCaml.

Local Open Scope Z_scope.
Import ListNotations.
Set Implicit Arguments.

Definition t0 : unit := tt.

Definition t1 : ascii * string := ("c" % char, "one" % string).

Definition t2 : Z * Z * Z * bool * bool := (1, 2, 3, false, true).

Definition f {A711 : Type} (x : A711) : A711 * A711 := (x, x).

Definition t3 : Z * Z := f 12.
