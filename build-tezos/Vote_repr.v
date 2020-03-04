(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.

Definition proposal : Set := (|Protocol_hash|).(S.HASH.t).

Inductive ballot : Set :=
| Yay : ballot
| Nay : ballot
| Pass : ballot.

Definition ballot_encoding : Data_encoding.encoding ballot :=
  let of_int8 (function_parameter : int) : ballot :=
    match function_parameter with
    | 0 => Yay
    | 1 => Nay
    | 2 => Pass
    | _ => Pervasives.invalid_arg "ballot_of_int8"
    end in
  let to_int8 (function_parameter : ballot) : int :=
    match function_parameter with
    | Yay => 0
    | Nay => 1
    | Pass => 2
    end in
  Data_encoding.splitted
    (Data_encoding.string_enum [ ("yay", Yay); ("nay", Nay); ("pass", Pass) ])
    (Data_encoding.conv to_int8 of_int8 None Data_encoding.int8).