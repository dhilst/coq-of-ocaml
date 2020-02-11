(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Storage_description.

Definition t := int32.

Definition cycle := t.

Definition encoding : Data_encoding.encoding int32 :=
  Data_encoding.__int32_value.

Definition rpc_arg : RPC_arg.arg int32 :=
  let construct := Int32.to_string in
  let destruct (str : string) : Pervasives.result int32 string :=
    let 'cycle := Int32.of_string str in
    Pervasives.Ok cycle in
  RPC_arg.make (Some "A cycle integer") "block_cycle" destruct construct tt.

Definition pp (ppf : Format.formatter) (cycle : int32) : unit :=
  Format.fprintf ppf
    (CamlinternalFormatBasics.Format
      (CamlinternalFormatBasics.Int32 CamlinternalFormatBasics.Int_d
        CamlinternalFormatBasics.No_padding
        CamlinternalFormatBasics.No_precision
        CamlinternalFormatBasics.End_of_format) "%ld") cycle.

Definition op_eq := (|Compare.Int32|).(Compare.S.op_eq).

Definition op_ltgt := (|Compare.Int32|).(Compare.S.op_ltgt).

Definition op_lt := (|Compare.Int32|).(Compare.S.op_lt).

Definition op_lteq := (|Compare.Int32|).(Compare.S.op_lteq).

Definition op_gteq := (|Compare.Int32|).(Compare.S.op_gteq).

Definition op_gt := (|Compare.Int32|).(Compare.S.op_gt).

Definition compare := (|Compare.Int32|).(Compare.S.compare).

Definition equal := (|Compare.Int32|).(Compare.S.equal).

Definition max := (|Compare.Int32|).(Compare.S.max).

Definition min := (|Compare.Int32|).(Compare.S.min).

Definition Map :=
  Map.Make
    (existT (A := Set) _ _
      {|
        Compare.COMPARABLE.compare := (|Compare.Int32|).(Compare.S.compare)
      |}).

Definition root : int32 :=
  (* ❌ Constant of type int32 is converted to int *)
  0.

Definition succ : int32 -> int32 := Int32.succ.

Definition pred (function_parameter : int32) : option int32 :=
  match function_parameter with
  |
    (* ❌ Constant of type int32 is converted to int *)
    0 => None
  | i => Some (Int32.pred i)
  end.

Definition add (c : int32) (i : (|Compare.Int|).(Compare.S.t)) : int32 :=
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  Int32.add c (Int32.of_int i).

Definition sub (c : int32) (i : (|Compare.Int|).(Compare.S.t)) : option int32 :=
  (* ❌ Sequences of instructions are ignored (operator ";") *)
  (* ❌ instruction_sequence ";" *)
  let r := Int32.sub c (Int32.of_int i) in
  if
    (|Compare.Int32|).(Compare.S.op_lt) r
      (* ❌ Constant of type int32 is converted to int *)
      0 then
    None
  else
    Some r.

Definition to_int32 {A : Set} (i : A) : A := i.

Definition of_int32_exn (l : (|Compare.Int32|).(Compare.S.t))
  : (|Compare.Int32|).(Compare.S.t) :=
  if
    (|Compare.Int32|).(Compare.S.op_gteq) l
      (* ❌ Constant of type int32 is converted to int *)
      0 then
    l
  else
    Pervasives.invalid_arg "Level_repr.Cycle.of_int32".

Definition depends_on_storage_description : unit -> unit :=
  Storage_description.depends_on_me.

Definition Index :=
  let t := cycle in
  let path_length := 1 in
  let to_path (c : int32) (l : list string) : list string :=
    cons (Int32.to_string (to_int32 c)) l in
  let of_path (function_parameter : list string) : option int32 :=
    match function_parameter with
    | cons s [] =>
      (* ❌ Try-with are not handled *)
      try (Some (Int32.of_string s))
    | _ => None
    end in
  existT (A := unit) (fun _ => _) tt
    {|
      Storage_description.INDEX.path_length := path_length;
      Storage_description.INDEX.to_path := to_path;
      Storage_description.INDEX.of_path := of_path;
      Storage_description.INDEX.rpc_arg := rpc_arg;
      Storage_description.INDEX.encoding := encoding;
      Storage_description.INDEX.compare := compare
    |}.
