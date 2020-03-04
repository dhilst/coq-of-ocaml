(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Qty_repr.

Parameter t : Set.

Definition tez : Set := t.

Parameter Included_S : {_ : unit & Qty_repr.S.signature t}.

Definition id : string := (|Included_S|).(Qty_repr.S.id).

Definition zero : t := (|Included_S|).(Qty_repr.S.zero).

Definition one_mutez : t := (|Included_S|).(Qty_repr.S.one_mutez).

Definition one_cent : t := (|Included_S|).(Qty_repr.S.one_cent).

Definition fifty_cents : t := (|Included_S|).(Qty_repr.S.fifty_cents).

Definition one : t := (|Included_S|).(Qty_repr.S.one).

Definition op_minusquestion : t -> t -> Error_monad.tzresult t :=
  (|Included_S|).(Qty_repr.S.op_minusquestion).

Definition op_plusquestion : t -> t -> Error_monad.tzresult t :=
  (|Included_S|).(Qty_repr.S.op_plusquestion).

Definition op_starquestion : t -> int64 -> Error_monad.tzresult t :=
  (|Included_S|).(Qty_repr.S.op_starquestion).

Definition op_divquestion : t -> int64 -> Error_monad.tzresult t :=
  (|Included_S|).(Qty_repr.S.op_divquestion).

Definition to_mutez : t -> int64 := (|Included_S|).(Qty_repr.S.to_mutez).

Definition of_mutez : int64 -> option t := (|Included_S|).(Qty_repr.S.of_mutez).

Definition of_mutez_exn : int64 -> t :=
  (|Included_S|).(Qty_repr.S.of_mutez_exn).

Definition add_exn : t -> t -> t := (|Included_S|).(Qty_repr.S.add_exn).

Definition mul_exn : t -> int -> t := (|Included_S|).(Qty_repr.S.mul_exn).

Definition qty_encoding : Data_encoding.t t :=
  (|Included_S|).(Qty_repr.S.qty_encoding).

Definition to_int64 : t -> int64 := (|Included_S|).(Qty_repr.S.to_int64).

Definition op_eq : t -> t -> bool := (|Included_S|).(Qty_repr.S.op_eq).

Definition op_ltgt : t -> t -> bool := (|Included_S|).(Qty_repr.S.op_ltgt).

Definition op_lt : t -> t -> bool := (|Included_S|).(Qty_repr.S.op_lt).

Definition op_lteq : t -> t -> bool := (|Included_S|).(Qty_repr.S.op_lteq).

Definition op_gteq : t -> t -> bool := (|Included_S|).(Qty_repr.S.op_gteq).

Definition op_gt : t -> t -> bool := (|Included_S|).(Qty_repr.S.op_gt).

Definition compare : t -> t -> int := (|Included_S|).(Qty_repr.S.compare).

Definition equal : t -> t -> bool := (|Included_S|).(Qty_repr.S.equal).

Definition max : t -> t -> t := (|Included_S|).(Qty_repr.S.max).

Definition min : t -> t -> t := (|Included_S|).(Qty_repr.S.min).

Definition pp : Format.formatter -> t -> unit := (|Included_S|).(Qty_repr.S.pp).

Definition of_string : string -> option t :=
  (|Included_S|).(Qty_repr.S.of_string).

Definition to_string : t -> string := (|Included_S|).(Qty_repr.S.to_string).

Parameter encoding : Data_encoding.t t.