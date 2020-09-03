(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Script_repr.

Parameter manager_script_code : Script_repr.lazy_expr.

Parameter add_do :
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Script_repr.lazy_expr -> Script_repr.lazy_expr ->
  Lwt.t (Error_monad.tzresult (Script_repr.lazy_expr * Script_repr.lazy_expr)).

Parameter add_set_delegate :
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Script_repr.lazy_expr -> Script_repr.lazy_expr ->
  Lwt.t (Error_monad.tzresult (Script_repr.lazy_expr * Script_repr.lazy_expr)).

Parameter has_default_entrypoint : Script_repr.lazy_expr -> bool.

Parameter add_root_entrypoint :
  Script_repr.lazy_expr -> Lwt.t (Error_monad.tzresult Script_repr.lazy_expr).