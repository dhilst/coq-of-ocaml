(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Set Primitive Projections.
Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Require Import Tezos.Environment.
Import Environment.Notations.
Require Tezos.Constants_storage.
Require Tezos.Contract_repr.
Require Tezos.Cycle_repr.
Require Tezos.Level_repr.
Require Tezos.Level_storage.
Require Tezos.Manager_repr.
Require Tezos.Nonce_storage.
Require Tezos.Raw_context.
Require Tezos.Roll_storage.
Require Tezos.Storage_mli. Module Storage := Storage_mli.
Require Tezos.Storage_sigs.
Require Tezos.Tez_repr.

Inductive balance : Set :=
| Contract : Contract_repr.t -> balance
| Rewards :
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> Cycle_repr.t ->
  balance
| Fees :
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> Cycle_repr.t ->
  balance
| Deposits :
  (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) -> Cycle_repr.t ->
  balance.

Definition balance_encoding : Data_encoding.encoding balance :=
  (let arg := Data_encoding.def "operation_metadata.alpha.balance" in
  fun eta => arg None None eta)
    (Data_encoding.union None
      [
        Data_encoding.__case_value "Contract" None (Data_encoding.Tag 0)
          (Data_encoding.obj2
            (Data_encoding.req None None "kind"
              (Data_encoding.constant "contract"))
            (Data_encoding.req None None "contract"
              Contract_repr.encoding))
          (fun function_parameter =>
            match function_parameter with
            | Contract c => Some (tt, c)
            | _ => None
            end)
          (fun function_parameter =>
            let '(_, c) := function_parameter in
            Contract c);
        Data_encoding.__case_value "Rewards" None (Data_encoding.Tag 1)
          (Data_encoding.obj4
            (Data_encoding.req None None "kind"
              (Data_encoding.constant "freezer"))
            (Data_encoding.req None None "category"
              (Data_encoding.constant "rewards"))
            (Data_encoding.req None None "delegate"
              (|Signature.Public_key_hash|).(S.SPublic_key_hash.encoding))
            (Data_encoding.req None None "cycle" Cycle_repr.encoding))
          (fun function_parameter =>
            match function_parameter with
            | Rewards d l => Some (tt, tt, d, l)
            | _ => None
            end)
          (fun function_parameter =>
            let '(_, _, d, l) := function_parameter in
            Rewards d l);
        Data_encoding.__case_value "Fees" None (Data_encoding.Tag 2)
          (Data_encoding.obj4
            (Data_encoding.req None None "kind"
              (Data_encoding.constant "freezer"))
            (Data_encoding.req None None "category"
              (Data_encoding.constant "fees"))
            (Data_encoding.req None None "delegate"
              (|Signature.Public_key_hash|).(S.SPublic_key_hash.encoding))
            (Data_encoding.req None None "cycle" Cycle_repr.encoding))
          (fun function_parameter =>
            match function_parameter with
            | Fees d l => Some (tt, tt, d, l)
            | _ => None
            end)
          (fun function_parameter =>
            let '(_, _, d, l) := function_parameter in
            Fees d l);
        Data_encoding.__case_value "Deposits" None (Data_encoding.Tag 3)
          (Data_encoding.obj4
            (Data_encoding.req None None "kind"
              (Data_encoding.constant "freezer"))
            (Data_encoding.req None None "category"
              (Data_encoding.constant "deposits"))
            (Data_encoding.req None None "delegate"
              (|Signature.Public_key_hash|).(S.SPublic_key_hash.encoding))
            (Data_encoding.req None None "cycle" Cycle_repr.encoding))
          (fun function_parameter =>
            match function_parameter with
            | Deposits d l => Some (tt, tt, d, l)
            | _ => None
            end)
          (fun function_parameter =>
            let '(_, _, d, l) := function_parameter in
            Deposits d l)
      ]).

Inductive balance_update : Set :=
| Debited : Tez_repr.t -> balance_update
| Credited : Tez_repr.t -> balance_update.

Definition balance_update_encoding : Data_encoding.encoding balance_update :=
  (let arg := Data_encoding.def "operation_metadata.alpha.balance_update" in
  fun eta => arg None None eta)
    (Data_encoding.obj1
      (Data_encoding.req None None "change"
        (Data_encoding.conv
          (fun function_parameter =>
            match function_parameter with
            | Credited v => Tez_repr.to_mutez v
            | Debited v => Int64.neg (Tez_repr.to_mutez v)
            end)
          (Data_encoding.Json.wrap_error
            (fun v =>
              if
                (|Compare.Int64|).(Compare.S.op_lt) v
                  (* ❌ Constant of type int64 is converted to int *)
                  0 then
                match Tez_repr.of_mutez (Int64.neg v) with
                | Some v => Debited v
                | None => Pervasives.failwith "Qty.of_mutez"
                end
              else
                match Tez_repr.of_mutez v with
                | Some v => Credited v
                | None => Pervasives.failwith "Qty.of_mutez"
                end)) None Data_encoding.__int64_value))).

Definition balance_updates : Set := list (balance * balance_update).

Definition balance_updates_encoding
  : Data_encoding.encoding (list (balance * balance_update)) :=
  (let arg := Data_encoding.def "operation_metadata.alpha.balance_updates" in
  fun eta => arg None None eta)
    (Data_encoding.__list_value None
      (Data_encoding.merge_objs balance_encoding balance_update_encoding)).

Definition cleanup_balance_updates {A : Set}
  (balance_updates : list (A * balance_update)) : list (A * balance_update) :=
  List.filter
    (fun function_parameter =>
      match function_parameter with
      | (_, (Credited update | Debited update)) =>
        Pervasives.not (Tez_repr.equal update Tez_repr.zero)
      end) balance_updates.

Module frozen_balance.
  Record record : Set := Build {
    deposit : Tez_repr.t;
    fees : Tez_repr.t;
    rewards : Tez_repr.t }.
  Definition with_deposit deposit (r : record) :=
    Build deposit r.(fees) r.(rewards).
  Definition with_fees fees (r : record) :=
    Build r.(deposit) fees r.(rewards).
  Definition with_rewards rewards (r : record) :=
    Build r.(deposit) r.(fees) rewards.
End frozen_balance.
Definition frozen_balance := frozen_balance.record.

Definition frozen_balance_encoding : Data_encoding.encoding frozen_balance :=
  Data_encoding.conv
    (fun function_parameter =>
      let '{|
        frozen_balance.deposit := deposit;
          frozen_balance.fees := fees;
          frozen_balance.rewards := rewards
          |} := function_parameter in
      (deposit, fees, rewards))
    (fun function_parameter =>
      let '(deposit, fees, rewards) := function_parameter in
      {| frozen_balance.deposit := deposit; frozen_balance.fees := fees;
        frozen_balance.rewards := rewards |}) None
    (Data_encoding.obj3
      (Data_encoding.req None None "deposit" Tez_repr.encoding)
      (Data_encoding.req None None "fees" Tez_repr.encoding)
      (Data_encoding.req None None "rewards" Tez_repr.encoding)).

(* ❌ Structure item `typext` not handled. *)
(* type_extension *)

(* ❌ Top-level evaluations are ignored *)
(* top_level_evaluation *)

Definition link
  (c : (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.context))
  (contract :
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.key))
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let=? balance :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.get) c
      contract in
  let=? c := Roll_storage.Delegate.add_amount c delegate balance in
  let= c :=
    (|Storage.Contract.Delegated|).(Storage_sigs.Data_set_storage.add)
      (c, (Contract_repr.implicit_contract delegate)) contract in
  Error_monad.__return c.

Definition unlink
  (c : (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.context))
  (contract :
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t
    (Error_monad.tzresult
      (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.context)) :=
  let=? balance :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.get) c
      contract in
  let=? function_parameter :=
    (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.get_option)
      c contract in
  match function_parameter with
  | None => Error_monad.__return c
  | Some delegate =>
    let=? c := Roll_storage.Delegate.remove_amount c delegate balance in
    let= c :=
      (|Storage.Contract.Delegated|).(Storage_sigs.Data_set_storage.del)
        (c, (Contract_repr.implicit_contract delegate)) contract in
    Error_monad.__return c
  end.

Definition known
  (c : (|Storage.Contract.Manager|).(Storage_sigs.Indexed_data_storage.context))
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult bool) :=
  let=? function_parameter :=
    (|Storage.Contract.Manager|).(Storage_sigs.Indexed_data_storage.get_option)
      c (Contract_repr.implicit_contract delegate) in
  match function_parameter with
  | (None | Some (Manager_repr.Hash _)) => Error_monad.return_false
  | Some (Manager_repr.Public_key _) => Error_monad.return_true
  end.

Definition registered
  (c : (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.context))
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult bool) :=
  let=? function_parameter :=
    (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.get_option)
      c (Contract_repr.implicit_contract delegate) in
  match function_parameter with
  | Some current_delegate =>
    Error_monad.__return
      ((|Signature.Public_key_hash|).(S.SPublic_key_hash.equal) delegate
        current_delegate)
  | None => Error_monad.return_false
  end.

Definition init
  (ctxt :
    (|Storage.Contract.Manager|).(Storage_sigs.Indexed_data_storage.context))
  (contract :
    (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.key))
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let=? known_delegate := known ctxt delegate in
  let=? '_ := Error_monad.fail_unless known_delegate extensible_type_value in
  let=? is_registered := registered ctxt delegate in
  let=? '_ := Error_monad.fail_unless is_registered extensible_type_value in
  let=? ctxt :=
    (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.init) ctxt
      contract delegate in
  link ctxt contract delegate.

Definition get
  : Raw_context.t -> Contract_repr.t ->
  Lwt.t
    (Error_monad.tzresult
      (option (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))) :=
  Roll_storage.get_contract_delegate.

Definition set
  (c : (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.context))
  (contract :
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.key))
  (delegate : option (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  match delegate with
  | None =>
    let delete (function_parameter : unit)
      : Lwt.t (Error_monad.tzresult Raw_context.t) :=
      let '_ := function_parameter in
      let=? c := unlink c contract in
      let= c :=
        (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.remove)
          c contract in
      Error_monad.__return c in
    match Contract_repr.is_implicit contract with
    | Some pkh =>
      let=? is_registered := registered c pkh in
      if is_registered then
        Error_monad.fail extensible_type_value
      else
        delete tt
    | None => delete tt
    end
  | Some delegate =>
    let=? known_delegate := known c delegate in
    let=? registered_delegate := registered c delegate in
    let self_delegation :=
      match Contract_repr.is_implicit contract with
      | Some pkh =>
        (|Signature.Public_key_hash|).(S.SPublic_key_hash.equal) pkh delegate
      | None => false
      end in
    if
      Pervasives.op_pipepipe (Pervasives.not known_delegate)
        (Pervasives.not
          (Pervasives.op_pipepipe registered_delegate self_delegation)) then
      Error_monad.fail extensible_type_value
    else
      let=? '_ :=
        let=? function_parameter :=
          (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.get_option)
            c contract in
        match
          (function_parameter,
            match function_parameter with
            | Some current_delegate =>
              (|Signature.Public_key_hash|).(S.SPublic_key_hash.equal) delegate
                current_delegate
            | _ => false
            end) with
        | (Some current_delegate, true) =>
          if self_delegation then
            let=? function_parameter :=
              Roll_storage.Delegate.is_inactive c delegate in
            match function_parameter with
            | true => Error_monad.return_unit
            | false => Error_monad.fail extensible_type_value
            end
          else
            Error_monad.fail extensible_type_value
        | ((None | Some _), _) => Error_monad.return_unit
        end in
      let=? '_ :=
        match Contract_repr.is_implicit contract with
        | Some pkh =>
          let=? is_registered := registered c pkh in
          if Pervasives.op_andand (Pervasives.not self_delegation) is_registered
            then
            Error_monad.fail extensible_type_value
          else
            Error_monad.return_unit
        | None => Error_monad.return_unit
        end in
      let= __exists :=
        (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.mem) c
          contract in
      let=? '_ :=
        Error_monad.fail_when
          (Pervasives.op_andand self_delegation (Pervasives.not __exists))
          extensible_type_value in
      let=? c := unlink c contract in
      let= c :=
        (|Storage.Contract.Delegate|).(Storage_sigs.Indexed_data_storage.init_set)
          c contract delegate in
      let=? c := link c contract delegate in
      let=? c :=
        if self_delegation then
          let= c :=
            (|Storage.Delegates|).(Storage_sigs.Data_set_storage.add) c delegate
            in
          let=? c := Roll_storage.Delegate.set_active c delegate in
          Error_monad.__return c
        else
          Error_monad.__return c in
      Error_monad.__return c
  end.

Definition remove
  (ctxt :
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.context))
  (contract :
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t
    (Error_monad.tzresult
      (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.context)) :=
  unlink ctxt contract.

Definition delegated_contracts
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t
    (list (|Storage.Contract.Delegated|).(Storage_sigs.Data_set_storage.elt)) :=
  let contract := Contract_repr.implicit_contract delegate in
  (|Storage.Contract.Delegated|).(Storage_sigs.Data_set_storage.elements)
    (ctxt, contract).

Definition get_frozen_deposit
  (ctxt : Raw_context.t) (contract : Contract_repr.t)
  (cycle :
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t (Error_monad.tzresult Tez_repr.t) :=
  let=? function_parameter :=
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.get_option)
      (ctxt, contract) cycle in
  match function_parameter with
  | None => Error_monad.__return Tez_repr.zero
  | Some frozen => Error_monad.__return frozen
  end.

Definition credit_frozen_deposit
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.key))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? old_amount := get_frozen_deposit ctxt contract cycle in
  let=? new_amount := Lwt.__return (Tez_repr.op_plusquestion old_amount amount)
    in
  let= ctxt :=
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.init_set)
      (ctxt, contract) cycle new_amount in
  let= ctxt :=
    (|Storage.Delegates_with_frozen_balance|).(Storage_sigs.Data_set_storage.add)
      (ctxt, cycle) delegate in
  Error_monad.__return ctxt.

Definition freeze_deposit
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let '{| Level_repr.t.cycle := cycle |} := Level_storage.current ctxt in
  let=? ctxt := Roll_storage.Delegate.set_active ctxt delegate in
  let contract := Contract_repr.implicit_contract delegate in
  let=? balance :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.get) ctxt
      contract in
  let=? new_balance :=
    Lwt.__return
      (Error_monad.record_trace extensible_type_value
        (Tez_repr.op_minusquestion balance amount)) in
  let=? ctxt :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.set) ctxt
      contract new_balance in
  credit_frozen_deposit ctxt delegate cycle amount.

Definition get_frozen_fees
  (ctxt : Raw_context.t) (contract : Contract_repr.t)
  (cycle :
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t (Error_monad.tzresult Tez_repr.t) :=
  let=? function_parameter :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.get_option)
      (ctxt, contract) cycle in
  match function_parameter with
  | None => Error_monad.__return Tez_repr.zero
  | Some frozen => Error_monad.__return frozen
  end.

Definition credit_frozen_fees
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.key))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? old_amount := get_frozen_fees ctxt contract cycle in
  let=? new_amount := Lwt.__return (Tez_repr.op_plusquestion old_amount amount)
    in
  let= ctxt :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.init_set)
      (ctxt, contract) cycle new_amount in
  let= ctxt :=
    (|Storage.Delegates_with_frozen_balance|).(Storage_sigs.Data_set_storage.add)
      (ctxt, cycle) delegate in
  Error_monad.__return ctxt.

Definition freeze_fees
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let '{| Level_repr.t.cycle := cycle |} := Level_storage.current ctxt in
  let=? ctxt := Roll_storage.Delegate.add_amount ctxt delegate amount in
  credit_frozen_fees ctxt delegate cycle amount.

Definition burn_fees
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.key))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? old_amount := get_frozen_fees ctxt contract cycle in
  let=? '(new_amount, ctxt) :=
    match Tez_repr.op_minusquestion old_amount amount with
    | Pervasives.Ok new_amount =>
      let=? ctxt := Roll_storage.Delegate.remove_amount ctxt delegate amount in
      Error_monad.__return (new_amount, ctxt)
    | Pervasives.Error _ =>
      let=? ctxt := Roll_storage.Delegate.remove_amount ctxt delegate old_amount
        in
      Error_monad.__return (Tez_repr.zero, ctxt)
    end in
  let= ctxt :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.init_set)
      (ctxt, contract) cycle new_amount in
  Error_monad.__return ctxt.

Definition get_frozen_rewards
  (ctxt : Raw_context.t) (contract : Contract_repr.t)
  (cycle :
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t (Error_monad.tzresult Tez_repr.t) :=
  let=? function_parameter :=
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.get_option)
      (ctxt, contract) cycle in
  match function_parameter with
  | None => Error_monad.__return Tez_repr.zero
  | Some frozen => Error_monad.__return frozen
  end.

Definition credit_frozen_rewards
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.key))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? old_amount := get_frozen_rewards ctxt contract cycle in
  let=? new_amount := Lwt.__return (Tez_repr.op_plusquestion old_amount amount)
    in
  let= ctxt :=
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.init_set)
      (ctxt, contract) cycle new_amount in
  let= ctxt :=
    (|Storage.Delegates_with_frozen_balance|).(Storage_sigs.Data_set_storage.add)
      (ctxt, cycle) delegate in
  Error_monad.__return ctxt.

Definition freeze_rewards
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let '{| Level_repr.t.cycle := cycle |} := Level_storage.current ctxt in
  credit_frozen_rewards ctxt delegate cycle amount.

Definition burn_rewards
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.key))
  (amount : Tez_repr.t) : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? old_amount := get_frozen_rewards ctxt contract cycle in
  let new_amount :=
    match Tez_repr.op_minusquestion old_amount amount with
    | Pervasives.Error _ => Tez_repr.zero
    | Pervasives.Ok new_amount => new_amount
    end in
  let= ctxt :=
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.init_set)
      (ctxt, contract) cycle new_amount in
  Error_monad.__return ctxt.

Definition unfreeze
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t
    (Error_monad.tzresult (Raw_context.t * list (balance * balance_update))) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? deposit := get_frozen_deposit ctxt contract cycle in
  let=? fees := get_frozen_fees ctxt contract cycle in
  let=? rewards := get_frozen_rewards ctxt contract cycle in
  let=? balance :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.get) ctxt
      contract in
  let=? unfrozen_amount := Lwt.__return (Tez_repr.op_plusquestion deposit fees)
    in
  let=? unfrozen_amount :=
    Lwt.__return (Tez_repr.op_plusquestion unfrozen_amount rewards) in
  let=? balance :=
    Lwt.__return (Tez_repr.op_plusquestion balance unfrozen_amount) in
  let=? ctxt :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.set) ctxt
      contract balance in
  let=? ctxt := Roll_storage.Delegate.add_amount ctxt delegate rewards in
  let= ctxt :=
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.remove)
      (ctxt, contract) cycle in
  let= ctxt :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.remove)
      (ctxt, contract) cycle in
  let= ctxt :=
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.remove)
      (ctxt, contract) cycle in
  Error_monad.__return
    (ctxt,
      (cleanup_balance_updates
        [
          ((Deposits delegate cycle), (Debited deposit));
          ((Fees delegate cycle), (Debited fees));
          ((Rewards delegate cycle), (Debited rewards));
          ((Contract (Contract_repr.implicit_contract delegate)),
            (Credited unfrozen_amount))
        ])).

Definition cycle_end
  (ctxt : Raw_context.context) (last_cycle : Cycle_repr.cycle)
  (unrevealed : list Nonce_storage.unrevealed)
  : Lwt.t
    (Error_monad.tzresult
      (Raw_context.context * list (balance * balance_update) *
        list
          (|Storage.Active_delegates_with_rolls|).(Storage_sigs.Data_set_storage.elt))) :=
  let preserved := Constants_storage.preserved_cycles ctxt in
  let=? '(ctxt, balance_updates) :=
    match Cycle_repr.pred last_cycle with
    | None => Error_monad.__return (ctxt, nil)
    | Some revealed_cycle =>
      List.fold_left
        (fun acc =>
          fun u =>
            let=? '(ctxt, balance_updates) := acc in
            let=? ctxt :=
              burn_fees ctxt u.(Storage.unrevealed_nonce.delegate)
                revealed_cycle u.(Storage.unrevealed_nonce.fees) in
            let=? ctxt :=
              burn_rewards ctxt u.(Storage.unrevealed_nonce.delegate)
                revealed_cycle u.(Storage.unrevealed_nonce.rewards) in
            let bus :=
              [
                ((Fees u.(Storage.unrevealed_nonce.delegate) revealed_cycle),
                  (Debited u.(Storage.unrevealed_nonce.fees)));
                ((Rewards u.(Storage.unrevealed_nonce.delegate) revealed_cycle),
                  (Debited u.(Storage.unrevealed_nonce.rewards)))
              ] in
            Error_monad.__return (ctxt, (Pervasives.op_at bus balance_updates)))
        (Error_monad.__return (ctxt, nil)) unrevealed
    end in
  match Cycle_repr.sub last_cycle preserved with
  | None => Error_monad.__return (ctxt, balance_updates, nil)
  | Some unfrozen_cycle =>
    let=? '(ctxt, balance_updates) :=
      (|Storage.Delegates_with_frozen_balance|).(Storage_sigs.Data_set_storage.fold)
        (ctxt, unfrozen_cycle) (Pervasives.Ok (ctxt, balance_updates))
        (fun delegate =>
          fun acc =>
            let=? '(ctxt, bus) := Lwt.__return acc in
            let=? '(ctxt, balance_updates) :=
              unfreeze ctxt delegate unfrozen_cycle in
            Error_monad.__return (ctxt, (Pervasives.op_at balance_updates bus)))
      in
    let= ctxt :=
      (|Storage.Delegates_with_frozen_balance|).(Storage_sigs.Data_set_storage.clear)
        (ctxt, unfrozen_cycle) in
    let=? '(ctxt, deactivated) :=
      (|Storage.Active_delegates_with_rolls|).(Storage_sigs.Data_set_storage.fold)
        ctxt (Pervasives.Ok (ctxt, nil))
        (fun delegate =>
          fun acc =>
            let=? '(ctxt, deactivated) := Lwt.__return acc in
            let=? cycle :=
              (|Storage.Contract.Delegate_desactivation|).(Storage_sigs.Indexed_data_storage.get)
                ctxt (Contract_repr.implicit_contract delegate) in
            if Cycle_repr.op_lteq cycle last_cycle then
              let=? ctxt := Roll_storage.Delegate.set_inactive ctxt delegate in
              Error_monad.__return (ctxt, (cons delegate deactivated))
            else
              Error_monad.__return (ctxt, deactivated)) in
    Error_monad.__return (ctxt, balance_updates, deactivated)
  end.

Definition punish
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t (Error_monad.tzresult (Raw_context.t * frozen_balance)) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? deposit := get_frozen_deposit ctxt contract cycle in
  let=? fees := get_frozen_fees ctxt contract cycle in
  let=? rewards := get_frozen_rewards ctxt contract cycle in
  let=? ctxt := Roll_storage.Delegate.remove_amount ctxt delegate deposit in
  let=? ctxt := Roll_storage.Delegate.remove_amount ctxt delegate fees in
  let= ctxt :=
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.remove)
      (ctxt, contract) cycle in
  let= ctxt :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.remove)
      (ctxt, contract) cycle in
  let= ctxt :=
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.remove)
      (ctxt, contract) cycle in
  Error_monad.__return
    (ctxt,
      {| frozen_balance.deposit := deposit; frozen_balance.fees := fees;
        frozen_balance.rewards := rewards |}).

Definition has_frozen_balance
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  (cycle :
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.key))
  : Lwt.t (Error_monad.tzresult bool) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? deposit := get_frozen_deposit ctxt contract cycle in
  if Tez_repr.op_ltgt deposit Tez_repr.zero then
    Error_monad.return_true
  else
    let=? fees := get_frozen_fees ctxt contract cycle in
    if Tez_repr.op_ltgt fees Tez_repr.zero then
      Error_monad.return_true
    else
      let=? rewards := get_frozen_rewards ctxt contract cycle in
      Error_monad.__return (Tez_repr.op_ltgt rewards Tez_repr.zero).

Definition frozen_balance_by_cycle_encoding
  : Data_encoding.encoding ((|Cycle_repr.Map|).(S.MAP.t) frozen_balance) :=
  Data_encoding.conv (|Cycle_repr.Map|).(S.MAP.bindings)
    (List.fold_left
      (fun m =>
        fun function_parameter =>
          let '(c, __b_value) := function_parameter in
          (|Cycle_repr.Map|).(S.MAP.add) c __b_value m)
      (|Cycle_repr.Map|).(S.MAP.empty)) None
    (Data_encoding.__list_value None
      (Data_encoding.merge_objs
        (Data_encoding.obj1
          (Data_encoding.req None None "cycle" Cycle_repr.encoding))
        frozen_balance_encoding)).

Definition empty_frozen_balance : frozen_balance :=
  {| frozen_balance.deposit := Tez_repr.zero;
    frozen_balance.fees := Tez_repr.zero;
    frozen_balance.rewards := Tez_repr.zero |}.

Definition frozen_balance_by_cycle
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t ((|Cycle_repr.Map|).(S.MAP.t) frozen_balance) :=
  let contract := Contract_repr.implicit_contract delegate in
  let map {A : Set} : (|Cycle_repr.Map|).(S.MAP.t) A :=
    (|Cycle_repr.Map|).(S.MAP.empty) in
  let= map :=
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) map
      (fun cycle =>
        fun amount =>
          fun map =>
            Lwt.__return
              ((|Cycle_repr.Map|).(S.MAP.add) cycle
                (frozen_balance.with_deposit amount empty_frozen_balance) map))
    in
  let= map :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) map
      (fun cycle =>
        fun amount =>
          fun map =>
            let balance :=
              match (|Cycle_repr.Map|).(S.MAP.find_opt) cycle map with
              | None => empty_frozen_balance
              | Some balance => balance
              end in
            Lwt.__return
              ((|Cycle_repr.Map|).(S.MAP.add) cycle
                (frozen_balance.with_fees amount balance) map)) in
  let= map :=
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) map
      (fun cycle =>
        fun amount =>
          fun map =>
            let balance :=
              match (|Cycle_repr.Map|).(S.MAP.find_opt) cycle map with
              | None => empty_frozen_balance
              | Some balance => balance
              end in
            Lwt.__return
              ((|Cycle_repr.Map|).(S.MAP.add) cycle
                (frozen_balance.with_rewards amount balance) map)) in
  Lwt.__return map.

Definition __frozen_balance_value
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Pervasives.result Tez_repr.t (list Error_monad.__error)) :=
  let contract := Contract_repr.implicit_contract delegate in
  let balance {A : Set} : Pervasives.result Tez_repr.t A :=
    Pervasives.Ok Tez_repr.zero in
  let= balance :=
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) balance
      (fun _cycle =>
        fun amount =>
          fun acc =>
            let=? acc := Lwt.__return acc in
            Lwt.__return (Tez_repr.op_plusquestion acc amount)) in
  let= balance :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) balance
      (fun _cycle =>
        fun amount =>
          fun acc =>
            let=? acc := Lwt.__return acc in
            Lwt.__return (Tez_repr.op_plusquestion acc amount)) in
  let= balance :=
    (|Storage.Contract.Frozen_rewards|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) balance
      (fun _cycle =>
        fun amount =>
          fun acc =>
            let=? acc := Lwt.__return acc in
            Lwt.__return (Tez_repr.op_plusquestion acc amount)) in
  Lwt.__return balance.

Definition full_balance
  (ctxt : Raw_context.t)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult Tez_repr.t) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? __frozen_balance_value := __frozen_balance_value ctxt delegate in
  let=? balance :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.get) ctxt
      contract in
  Lwt.__return (Tez_repr.op_plusquestion __frozen_balance_value balance).

Definition deactivated
  : Raw_context.t -> (|Signature.Public_key_hash|).(S.SPublic_key_hash.t) ->
  Lwt.t (Error_monad.tzresult bool) := Roll_storage.Delegate.is_inactive.

Definition grace_period
  (ctxt :
    (|Storage.Contract.Delegate_desactivation|).(Storage_sigs.Indexed_data_storage.context))
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t
    (Error_monad.tzresult
      (|Storage.Contract.Delegate_desactivation|).(Storage_sigs.Indexed_data_storage.value)) :=
  let contract := Contract_repr.implicit_contract delegate in
  (|Storage.Contract.Delegate_desactivation|).(Storage_sigs.Indexed_data_storage.get)
    ctxt contract.

Definition staking_balance
  (ctxt : Raw_context.context)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult Tez_repr.t) :=
  let token_per_rolls := Constants_storage.tokens_per_roll ctxt in
  let=? rolls := Roll_storage.get_rolls ctxt delegate in
  let=? change := Roll_storage.get_change ctxt delegate in
  let rolls := Int64.of_int (List.length rolls) in
  let=? balance := Lwt.__return (Tez_repr.op_starquestion token_per_rolls rolls)
    in
  Lwt.__return (Tez_repr.op_plusquestion balance change).

Definition delegated_balance
  (ctxt : Raw_context.context)
  (delegate : (|Signature.Public_key_hash|).(S.SPublic_key_hash.t))
  : Lwt.t (Error_monad.tzresult Tez_repr.t) :=
  let contract := Contract_repr.implicit_contract delegate in
  let=? staking_balance := staking_balance ctxt delegate in
  let= self_staking_balance :=
    (|Storage.Contract.Balance|).(Storage_sigs.Indexed_data_storage.get) ctxt
      contract in
  let= self_staking_balance :=
    (|Storage.Contract.Frozen_deposits|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) self_staking_balance
      (fun _cycle =>
        fun amount =>
          fun acc =>
            let=? acc := Lwt.__return acc in
            Lwt.__return (Tez_repr.op_plusquestion acc amount)) in
  let=? self_staking_balance :=
    (|Storage.Contract.Frozen_fees|).(Storage_sigs.Indexed_data_storage.fold)
      (ctxt, contract) self_staking_balance
      (fun _cycle =>
        fun amount =>
          fun acc =>
            let=? acc := Lwt.__return acc in
            Lwt.__return (Tez_repr.op_plusquestion acc amount)) in
  Lwt.__return (Tez_repr.op_minusquestion staking_balance self_staking_balance).

Definition fold {A : Set}
  : (|Storage.Delegates|).(Storage_sigs.Data_set_storage.context) -> A ->
  ((|Storage.Delegates|).(Storage_sigs.Data_set_storage.elt) -> A -> Lwt.t A) ->
  Lwt.t A := (|Storage.Delegates|).(Storage_sigs.Data_set_storage.fold).

Definition __list_value
  : (|Storage.Delegates|).(Storage_sigs.Data_set_storage.context) ->
  Lwt.t (list (|Storage.Delegates|).(Storage_sigs.Data_set_storage.elt)) :=
  (|Storage.Delegates|).(Storage_sigs.Data_set_storage.elements).