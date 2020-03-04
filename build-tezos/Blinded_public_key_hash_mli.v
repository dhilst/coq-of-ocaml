(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Storage_description.

Parameter Included_HASH :
  {'[t, __Set_t, Map_t] : [Set ** Set ** Set -> Set] &
    S.HASH.signature t __Set_t Map_t}.

Definition t := (|Included_HASH|).(S.HASH.t).

Definition name : string := (|Included_HASH|).(S.HASH.name).

Definition title : string := (|Included_HASH|).(S.HASH.title).

Definition pp : Format.formatter -> t -> unit := (|Included_HASH|).(S.HASH.pp).

Definition pp_short : Format.formatter -> t -> unit :=
  (|Included_HASH|).(S.HASH.pp_short).

Definition op_eq : t -> t -> bool := (|Included_HASH|).(S.HASH.op_eq).

Definition op_ltgt : t -> t -> bool := (|Included_HASH|).(S.HASH.op_ltgt).

Definition op_lt : t -> t -> bool := (|Included_HASH|).(S.HASH.op_lt).

Definition op_lteq : t -> t -> bool := (|Included_HASH|).(S.HASH.op_lteq).

Definition op_gteq : t -> t -> bool := (|Included_HASH|).(S.HASH.op_gteq).

Definition op_gt : t -> t -> bool := (|Included_HASH|).(S.HASH.op_gt).

Definition compare : t -> t -> int := (|Included_HASH|).(S.HASH.compare).

Definition equal : t -> t -> bool := (|Included_HASH|).(S.HASH.equal).

Definition max : t -> t -> t := (|Included_HASH|).(S.HASH.max).

Definition min : t -> t -> t := (|Included_HASH|).(S.HASH.min).

Definition hash_bytes : option MBytes.t -> list MBytes.t -> t :=
  (|Included_HASH|).(S.HASH.hash_bytes).

Definition hash_string : option string -> list string -> t :=
  (|Included_HASH|).(S.HASH.hash_string).

Definition zero : t := (|Included_HASH|).(S.HASH.zero).

Definition size : int := (|Included_HASH|).(S.HASH.size).

Definition to_bytes : t -> MBytes.t := (|Included_HASH|).(S.HASH.to_bytes).

Definition of_bytes_opt : MBytes.t -> option t :=
  (|Included_HASH|).(S.HASH.of_bytes_opt).

Definition of_bytes_exn : MBytes.t -> t :=
  (|Included_HASH|).(S.HASH.of_bytes_exn).

Definition to_b58check : t -> string := (|Included_HASH|).(S.HASH.to_b58check).

Definition to_short_b58check : t -> string :=
  (|Included_HASH|).(S.HASH.to_short_b58check).

Definition of_b58check_exn : string -> t :=
  (|Included_HASH|).(S.HASH.of_b58check_exn).

Definition of_b58check_opt : string -> option t :=
  (|Included_HASH|).(S.HASH.of_b58check_opt).

Definition b58check_encoding : Base58.encoding t :=
  (|Included_HASH|).(S.HASH.b58check_encoding).

Definition encoding : Data_encoding.t t := (|Included_HASH|).(S.HASH.encoding).

Definition rpc_arg : RPC_arg.t t := (|Included_HASH|).(S.HASH.rpc_arg).

Definition to_path : t -> list string -> list string :=
  (|Included_HASH|).(S.HASH.to_path).

Definition of_path : list string -> option t :=
  (|Included_HASH|).(S.HASH.of_path).

Definition of_path_exn : list string -> t :=
  (|Included_HASH|).(S.HASH.of_path_exn).

Definition prefix_path : string -> list string :=
  (|Included_HASH|).(S.HASH.prefix_path).

Definition path_length : int := (|Included_HASH|).(S.HASH.path_length).

Definition __Set := existT (fun _ => _) tt (|Included_HASH|).(S.HASH.__Set).

Definition Map := existT (fun _ => _) tt (|Included_HASH|).(S.HASH.Map).

Parameter activation_code : Set.

Parameter activation_code_encoding : Data_encoding.t activation_code.

Parameter of_ed25519_pkh :
  activation_code ->
  (|Ed25519|).(S.SIGNATURE.Public_key_hash).(S.SPublic_key_hash.t) -> t.

Parameter activation_code_of_hex : string -> activation_code.

Parameter Index : {_ : unit & Storage_description.INDEX.signature t}.