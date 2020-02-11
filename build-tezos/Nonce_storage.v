(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Cycle_repr.
Require Tezos.Level_repr.
Require Tezos.Level_storage.
Require Tezos.Nonce_hash.
Require Tezos.Raw_context.
Require Tezos.Seed_repr.
Require Tezos.Storage.
Require Tezos.Tez_repr.

Definition t := Seed_repr.nonce.

Definition nonce := t.

Definition encoding : Data_encoding.t Seed_repr.nonce :=
  Seed_repr.nonce_encoding.

(* ❌ Structure item `typext` not handled. *)
(* type_extension *)

(* ❌ Top-level evaluations are ignored *)
(* top_level_evaluation *)

Definition get_unrevealed (ctxt : Raw_context.t) (level : Level_repr.t)
  : Lwt.t (Error_monad.tzresult Storage.Seed.unrevealed_nonce) :=
  let cur_level := Level_storage.current ctxt in
  match Cycle_repr.pred cur_level.(Level_repr.t.cycle) with
  | None => Error_monad.fail extensible_type_value
  | Some revealed_cycle =>
    if Cycle_repr.op_lt revealed_cycle level.(Level_repr.t.cycle) then
      Error_monad.fail extensible_type_value
    else
      if Cycle_repr.op_lt level.(Level_repr.t.cycle) revealed_cycle then
        Error_monad.fail extensible_type_value
      else
        Error_monad.op_gtgteqquestion (Storage.Seed.Nonce.get ctxt level)
          (fun function_parameter =>
            match function_parameter with
            | Storage.Seed.Revealed _ => Error_monad.fail extensible_type_value
            | Storage.Seed.Unrevealed status => Error_monad.__return status
            end)
  end.

Definition record_hash
  (ctxt : Raw_context.t) (unrevealed : Storage.Seed.unrevealed_nonce)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let level := Level_storage.current ctxt in
  Storage.Seed.Nonce.init ctxt level (Storage.Seed.Unrevealed unrevealed).

Definition reveal
  (ctxt : Raw_context.t) (level : Level_repr.t)
  (__nonce_value : Seed_repr.nonce)
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  Error_monad.op_gtgteqquestion (get_unrevealed ctxt level)
    (fun unrevealed =>
      Error_monad.op_gtgteqquestion
        (Error_monad.fail_unless
          (Seed_repr.check_hash __nonce_value
            unrevealed.(Storage.Seed.unrevealed_nonce.nonce_hash))
          extensible_type_value)
        (fun function_parameter =>
          let '_ := function_parameter in
          Error_monad.op_gtgteqquestion
            (Storage.Seed.Nonce.set ctxt level
              (Storage.Seed.Revealed __nonce_value))
            (fun ctxt => Error_monad.__return ctxt))).

Module unrevealed.
  Record record := Build {
    nonce_hash : Nonce_hash.t;
    delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t);
    rewards : Tez_repr.t;
    fees : Tez_repr.t }.
  Definition with_nonce_hash nonce_hash (r : record) :=
    Build nonce_hash r.(delegate) r.(rewards) r.(fees).
  Definition with_delegate delegate (r : record) :=
    Build r.(nonce_hash) delegate r.(rewards) r.(fees).
  Definition with_rewards rewards (r : record) :=
    Build r.(nonce_hash) r.(delegate) rewards r.(fees).
  Definition with_fees fees (r : record) :=
    Build r.(nonce_hash) r.(delegate) r.(rewards) fees.
End unrevealed.
Definition unrevealed := unrevealed.record.

Inductive status : Set :=
| Unrevealed : unrevealed -> status
| Revealed : Seed_repr.nonce -> status.

Definition get
  : Storage.Seed.Nonce.context -> Level_repr.t ->
  Lwt.t (Error_monad.tzresult Storage.Seed.nonce_status) :=
  Storage.Seed.Nonce.get.

Definition of_bytes : MBytes.t -> Error_monad.tzresult Seed_repr.nonce :=
  Seed_repr.make_nonce.

Definition __hash_value : Seed_repr.nonce -> Nonce_hash.t :=
  Seed_repr.__hash_value.

Definition check_hash : Seed_repr.nonce -> Nonce_hash.t -> bool :=
  Seed_repr.check_hash.
