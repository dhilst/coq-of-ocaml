(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.

Definition proposal := (|Protocol_hash|).(S.HASH.t).

Inductive ballot : Set :=
| Yay : ballot
| Nay : ballot
| Pass : ballot.

Parameter ballot_encoding : Data_encoding.t ballot.
