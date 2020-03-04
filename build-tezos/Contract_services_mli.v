(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Alpha_context.
Require Tezos.Michelson_v1_primitives.
Require Tezos.Script_expr_hash.

Import Alpha_context.

Parameter __list_value : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a ->
  Lwt.t (Error_monad.shell_tzresult (list Alpha_context.Contract.t)).

Module info.
  Record record : Set := Build {
    balance : Alpha_context.Tez.t;
    delegate : option Alpha_context.public_key_hash;
    counter : option Alpha_context.counter;
    script : option Alpha_context.Script.t }.
  Definition with_balance balance (r : record) :=
    Build balance r.(delegate) r.(counter) r.(script).
  Definition with_delegate delegate (r : record) :=
    Build r.(balance) delegate r.(counter) r.(script).
  Definition with_counter counter (r : record) :=
    Build r.(balance) r.(delegate) counter r.(script).
  Definition with_script script (r : record) :=
    Build r.(balance) r.(delegate) r.(counter) script.
End info.
Definition info := info.record.

Parameter info_encoding : Data_encoding.t info.

Parameter __info_value : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult info).

Parameter balance : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Tez.t).

Parameter manager_key : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.public_key_hash ->
  Lwt.t (Error_monad.shell_tzresult (option Alpha_context.public_key)).

Parameter delegate : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.public_key_hash).

Parameter delegate_opt : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult (option Alpha_context.public_key_hash)).

Parameter counter : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.public_key_hash ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.counter).

Parameter script : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Script.t).

Parameter script_opt : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult (option Alpha_context.Script.t)).

Parameter storage : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Script.expr).

Parameter entrypoint_type : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t -> string ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Script.expr).

Parameter list_entrypoints : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t
    (Error_monad.shell_tzresult
      (list (list Michelson_v1_primitives.prim) *
        list (string * Alpha_context.Script.expr))).

Parameter storage_opt : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Lwt.t (Error_monad.shell_tzresult (option Alpha_context.Script.expr)).

Parameter big_map_get : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Z.t -> Script_expr_hash.t ->
  Lwt.t (Error_monad.shell_tzresult Alpha_context.Script.expr).

Parameter contract_big_map_get_opt : forall {G a b c i o q : Set},
  ((RPC_service.t RPC_context.t RPC_context.t q i o -> a -> q -> i ->
  Lwt.t (Error_monad.shell_tzresult o)) *
    ((RPC_service.t RPC_context.t (RPC_context.t * a) q i o -> a -> a -> q ->
    i -> Lwt.t (Error_monad.shell_tzresult o)) *
      ((RPC_service.t RPC_context.t ((RPC_context.t * a) * b) q i o -> a -> a ->
      b -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) *
        ((RPC_service.t RPC_context.t (((RPC_context.t * a) * b) * c) q i o ->
        a -> a -> b -> c -> q -> i -> Lwt.t (Error_monad.shell_tzresult o)) * G))))
    * G * a -> a -> Alpha_context.Contract.t ->
  Alpha_context.Script.expr * Alpha_context.Script.expr ->
  Lwt.t (Error_monad.shell_tzresult (option Alpha_context.Script.expr)).

Parameter register : unit -> unit.