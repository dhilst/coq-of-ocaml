(** Generated by coq-of-ocaml *)
Require Import OCaml.OCaml.

Local Open Scope string_scope.
Local Open Scope Z_scope.
Local Open Scope type_scope.
Import ListNotations.

Unset Positivity Checking.
Unset Guard Checking.

Require Import Tezos.Environment.
Require Tezos.Bootstrap_storage.
Require Tezos.Commitment_storage.
Require Tezos.Contract_storage.
Require Tezos.Parameters_repr.
Require Tezos.Raw_context.
Require Tezos.Roll_storage.
Require Tezos.Script_repr.
Require Tezos.Seed_storage.
Require Tezos.Storage.
Require Tezos.Vote_storage.

Definition prepare_first_block
  (ctxt : Context.t)
  (typecheck :
    Raw_context.t -> Script_repr.t ->
    Lwt.t
      (Error_monad.tzresult
        ((Script_repr.t * option Contract_storage.big_map_diff) * Raw_context.t)))
  (level : int32) (timestamp : Time.t) (fitness : (|Fitness|).(S.T.t))
  : Lwt.t (Error_monad.tzresult Raw_context.t) :=
  Error_monad.op_gtgteqquestion
    (Raw_context.prepare_first_block level timestamp fitness ctxt)
    (fun function_parameter =>
      let '(previous_protocol, ctxt) := function_parameter in
      Error_monad.op_gtgteqquestion (Storage.Big_map.Next.init ctxt)
        (fun ctxt =>
          match previous_protocol with
          | Raw_context.Genesis param =>
            Error_monad.op_gtgteqquestion
              (Commitment_storage.init ctxt
                param.(Parameters_repr.t.commitments))
              (fun ctxt =>
                Error_monad.op_gtgteqquestion (Roll_storage.init ctxt)
                  (fun ctxt =>
                    Error_monad.op_gtgteqquestion (Seed_storage.init ctxt)
                      (fun ctxt =>
                        Error_monad.op_gtgteqquestion
                          (Contract_storage.init ctxt)
                          (fun ctxt =>
                            Error_monad.op_gtgteqquestion
                              (Bootstrap_storage.init ctxt typecheck
                                param.(Parameters_repr.t.security_deposit_ramp_up_cycles)
                                param.(Parameters_repr.t.no_reward_cycles)
                                param.(Parameters_repr.t.bootstrap_accounts)
                                param.(Parameters_repr.t.bootstrap_contracts))
                              (fun ctxt =>
                                Error_monad.op_gtgteqquestion
                                  (Roll_storage.init_first_cycles ctxt)
                                  (fun ctxt =>
                                    Error_monad.op_gtgteqquestion
                                      (Vote_storage.init ctxt)
                                      (fun ctxt =>
                                        Error_monad.op_gtgteqquestion
                                          (Storage.Block_priority.init ctxt 0)
                                          (fun ctxt =>
                                            Error_monad.op_gtgteqquestion
                                              (Vote_storage.freeze_listings ctxt)
                                              (fun ctxt =>
                                                Error_monad.__return ctxt)))))))))
          | Raw_context.Alpha_previous => Error_monad.__return ctxt
          end)).

Definition prepare
  (ctxt : Context.t) (level : Int32.t) (predecessor_timestamp : Time.t)
  (timestamp : Time.t) (fitness : (|Fitness|).(S.T.t))
  : Lwt.t (Error_monad.tzresult Raw_context.context) :=
  Raw_context.prepare level predecessor_timestamp timestamp fitness ctxt.
