(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.

Inductive n : Set :=
| Natural_tag : n.

Inductive z : Set :=
| Integer_tag : z.

Definition num (t : Set) := Z.t.

Definition compare (x : Z.t) (y : Z.t) : Z := Z.compare x y.

Definition zero : Z.t := Z.zero.

Definition zero_n : Z.t := Z.zero.

Definition to_string (x : Z.t) : string := Z.to_string x.

Definition of_string (s : string) : option Z.t :=
  (* ❌ Try-with are not handled *)
  try (Some (Z.of_string s)).

Definition to_int64 (x : Z.t) : option int64 :=
  (* ❌ Try-with are not handled *)
  try (Some (Z.to_int64 x)).

Definition of_int64 (n : int64) : Z.t := Z.of_int64 n.

Definition to_int (x : Z.t) : option Z :=
  (* ❌ Try-with are not handled *)
  try (Some (Z.to_int x)).

Definition of_int (n : Z) : Z.t := Z.of_int n.

Definition of_zint {A : Set} (x : A) : A := x.

Definition to_zint {A : Set} (x : A) : A := x.

Definition add (x : Z.t) (y : Z.t) : Z.t := Z.add x y.

Definition sub (x : Z.t) (y : Z.t) : Z.t := Z.sub x y.

Definition mul (x : Z.t) (y : Z.t) : Z.t := Z.mul x y.

Definition ediv (x : Z.t) (y : Z.t) : option (Z.t * Z.t) :=
  (* ❌ Try-with are not handled *)
  try
    (let '(q, r) := Z.ediv_rem x y in
    Some (q, r)).

Definition add_n : Z.t -> Z.t -> Z.t := add.

Definition mul_n : Z.t -> Z.t -> Z.t := mul.

Definition ediv_n : Z.t -> Z.t -> option (Z.t * Z.t) := ediv.

Definition abs (x : Z.t) : Z.t := Z.abs x.

Definition is_nat (x : (|Compare.Z|).(Compare.S.t))
  : option (|Compare.Z|).(Compare.S.t) :=
  if (|Compare.Z|).(Compare.S.op_lt) x Z.zero then
    None
  else
    Some x.

Definition neg (x : Z.t) : Z.t := Z.neg x.

Definition int {A : Set} (x : A) : A := x.

Definition shift_left (x : Z.t) (y : Z.t) : option Z.t :=
  if (|Compare.Int|).(Compare.S.op_gt) (Z.compare y (Z.of_int 256)) 0 then
    None
  else
    let y := Z.to_int y in
    Some (Z.shift_left x y).

Definition shift_right (x : Z.t) (y : Z.t) : option Z.t :=
  if (|Compare.Int|).(Compare.S.op_gt) (Z.compare y (Z.of_int 256)) 0 then
    None
  else
    let y := Z.to_int y in
    Some (Z.shift_right x y).

Definition shift_left_n : Z.t -> Z.t -> option Z.t := shift_left.

Definition shift_right_n : Z.t -> Z.t -> option Z.t := shift_right.

Definition logor (x : Z.t) (y : Z.t) : Z.t := Z.logor x y.

Definition logxor (x : Z.t) (y : Z.t) : Z.t := Z.logxor x y.

Definition logand (x : Z.t) (y : Z.t) : Z.t := Z.logand x y.

Definition lognot (x : Z.t) : Z.t := Z.lognot x.
