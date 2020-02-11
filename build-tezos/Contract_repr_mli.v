(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Contract_hash.
Require Tezos.Storage_description.

Inductive t : Set :=
| Implicit : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> t
| Originated : Contract_hash.t -> t.

Definition contract := t.

Parameter Included_S : {_ : unit & Compare.S.signature contract}.

Definition op_eq := (|Included_S|).(Compare.S.op_eq).

Definition op_ltgt := (|Included_S|).(Compare.S.op_ltgt).

Definition op_lt := (|Included_S|).(Compare.S.op_lt).

Definition op_lteq := (|Included_S|).(Compare.S.op_lteq).

Definition op_gteq := (|Included_S|).(Compare.S.op_gteq).

Definition op_gt := (|Included_S|).(Compare.S.op_gt).

Definition compare := (|Included_S|).(Compare.S.compare).

Definition equal := (|Included_S|).(Compare.S.equal).

Definition max := (|Included_S|).(Compare.S.max).

Definition min := (|Included_S|).(Compare.S.min).

Parameter implicit_contract :
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> contract.

Parameter is_implicit :
  contract -> option (|Signature.Public_key_hash|).(S.SPublic_key_hash.t).

Parameter origination_nonce : Set.

Parameter originated_contract : origination_nonce -> contract.

Parameter originated_contracts :
  origination_nonce -> origination_nonce -> list contract.

Parameter initial_origination_nonce :
  (|Operation_hash|).(S.HASH.t) -> origination_nonce.

Parameter incr_origination_nonce : origination_nonce -> origination_nonce.

Parameter is_originated : contract -> option Contract_hash.t.

(* extensible_type error *)

Parameter to_b58check : contract -> string.

Parameter of_b58check : string -> Error_monad.tzresult contract.

Parameter pp : Format.formatter -> contract -> unit.

Parameter pp_short : Format.formatter -> contract -> unit.

Parameter encoding : Data_encoding.t contract.

Parameter origination_nonce_encoding : Data_encoding.t origination_nonce.

Parameter rpc_arg : RPC_arg.arg contract.

Parameter Index : {_ : unit & Storage_description.INDEX.signature t}.
