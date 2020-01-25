(** A structure represents the contents of a ".ml" file. *)
open Typedtree
open SmartPrint
open Monad.Notations

(** A value is a toplevel definition made with a "let". *)
module Value = struct
  type t = Exp.t option Exp.Definition.t

  (** Pretty-print a value definition to Coq. *)
  let to_coq (value : t) : SmartPrint.t =
    match value.Exp.Definition.cases with
    | [] -> empty
    | _ :: _ ->
      separate (newline ^^ newline) (value.Exp.Definition.cases |> List.mapi (fun index (header, e) ->
        let firt_case = index = 0 in
        nest (
          begin if firt_case then
            begin if Recursivity.to_bool value.Exp.Definition.is_rec then
              !^ "Fixpoint"
            else
              !^ "Definition"
            end
          else
            !^ "with"
          end ^^
          let { Exp.Header.name; typ_vars; args; typ } = header in
          Name.to_coq name ^^
          begin match typ_vars with
          | [] -> empty
          | _ :: _ ->
            braces @@ group (separate space (List.map Name.to_coq typ_vars) ^^
            !^ ":" ^^ Pp.set)
          end ^^
          group (separate space (args |> List.map (fun (x, t) ->
            parens @@ nest (Name.to_coq x ^^ !^ ":" ^^ Type.to_coq None None t)
          ))) ^^
          (if Recursivity.to_bool value.Exp.Definition.is_rec then
            match args with
            | [] -> empty
            | (x, _) :: _ -> braces (nest (!^ "struct" ^^ Name.to_coq x))
          else
            empty
          ) ^^
          begin match typ with
          | None -> empty
          | Some typ -> !^ ": " ^-^ Type.to_coq None None typ
          end ^-^
          !^ (match typ with None -> ":=" | _ -> " :=") ^^
          begin match e with
          | None -> !^ "axiom"
          | Some e -> Exp.to_coq false e
          end
        )
      )) ^-^ !^ "."
end

(** A structure. *)
type t =
  | Value of Value.t
  | AbstractValue of Name.t * Name.t list * Type.t
  | TypeDefinition of TypeDefinition.t
  | Open of Open.t
  | Module of Name.t * t list
  | ModuleInclude of PathName.t
  | ModuleSynonym of Name.t * PathName.t
  | Signature of Name.t * Signature.t
  | Error of string
  | ErrorMessage of string * t

let error_message
  (structure : t)
  (category : Error.Category.t)
  (message : string)
  : t list Monad.t =
  raise [ErrorMessage (message, structure)] category message

let simple_value (name : Name.t) (e : Exp.t) : t =
  Value {
    is_rec = Recursivity.New false;
    cases = [
      (
        {
          name;
          typ_vars = [];
          args = [];
          typ = None
        },
        Some e
      )
    ]
  }

let top_level_evaluation_error : t list Monad.t =
  error_message
    (Error "top_level_evaluation")
    SideEffect
    "Top-level evaluations are not handled"

(** Import an OCaml structure. *)
let rec of_structure (structure : structure) : t list Monad.t =
  let of_structure_item (item : structure_item) : t list Monad.t =
    set_env item.str_env (
    set_loc (Loc.of_location item.str_loc) (
    match item.str_desc with
    | Tstr_value (_, [ {
        vb_pat = {
          pat_desc =
            Tpat_construct (
              _,
              { cstr_res = { desc = Tconstr (path, _, _); _ }; _ },
              _
            );
          _
        };
        _
      } ])
      when PathName.is_unit (PathName.of_path_without_convert false path) ->
      top_level_evaluation_error
    | Tstr_eval _ -> top_level_evaluation_error
    | Tstr_value (is_rec, cases) ->
      Exp.import_let_fun Name.Map.empty true is_rec cases >>= fun def ->
      return [Value def]
    | Tstr_type (_, typs) ->
      TypeDefinition.of_ocaml typs >>= fun def ->
      return [TypeDefinition def]
    | Tstr_exception { ext_id; _ } ->
      error_message (Error ("exception " ^ Ident.name ext_id)) SideEffect (
        "The definition of exceptions is not handled.\n\n" ^
        "Alternative: using sum types (\"option\", \"result\", ...) to " ^
        "represent error cases."
      )
    | Tstr_open open_description ->
      let o = Open.of_ocaml open_description in
      return [Open o]
    | Tstr_module {
        mb_id = name;
        mb_expr = {
          mod_desc = Tmod_structure structure;
          mod_type;
          _
        };
        _
      }
    | Tstr_module {
        mb_id = name;
        mb_expr = {
          mod_desc = Tmod_constraint ({ mod_desc = Tmod_structure structure; _ }, _, _, _);
          mod_type;
          _
        };
        _
      } ->
      let name = Name.of_ident false name in
      of_structure structure >>= fun structures ->
      IsFirstClassModule.is_module_typ_first_class mod_type >>= fun is_first_class ->
      begin match is_first_class with
      | Found md_type_path ->
        Exp.of_structure
          Name.Map.empty
          md_type_path
          mod_type
          structure.str_items >>= fun module_exp ->
        return [simple_value name module_exp]
      | Not_found _ -> return [Module (name, structures)]
      end
    | Tstr_module {
        mb_id = name;
        mb_expr = {
          mod_desc = Tmod_ident (_, long_ident);
          mod_type;
          _
        };
        _
      } ->
      let name = Name.of_ident false name in
      let reference = PathName.of_long_ident false long_ident.txt in
      IsFirstClassModule.is_module_typ_first_class mod_type >>= fun is_first_class ->
      begin match is_first_class with
      | Found _ ->
        return [simple_value name (Exp.Variable (MixedPath.PathName reference))]
      | Not_found _ -> return [ModuleSynonym (name, reference)]
      end
    | Tstr_module {
        mb_id;
        mb_expr = { mod_desc = (Tmod_apply _ | Tmod_functor _); _ } as mb_expr;
        _
      } ->
      let name = Name.of_ident false mb_id in
      Exp.of_module_expr
        Name.Map.empty
        mb_expr
        None >>= fun module_exp ->
      return [simple_value name module_exp]
    | Tstr_module _ ->
      error_message
        (Error "unhandled_module")
        NotSupported
        "This kind of module is not handled."
    | Tstr_modtype { mtd_type = None; _ } ->
      error_message
        (Error "abstract_module_type")
        NotSupported
        "Abstract module types not handled."
    | Tstr_modtype { mtd_id; mtd_type = Some { mty_desc; _ }; _ } ->
      let name = Name.of_ident false mtd_id in
      begin
        match mty_desc with
        | Tmty_signature signature ->
          Signature.of_signature signature >>= fun signature ->
          return [Signature (name, signature)]
        | _ ->
          error_message
            (Error "unhandled_module_type")
            NotSupported
            "This kind of signature is not handled."
      end
    | Tstr_primitive { val_id; val_val = { val_type; _ }; _ } ->
      let name = Name.of_ident true val_id in
      Type.of_typ_expr true Name.Map.empty val_type >>= fun (typ, _, free_typ_vars) ->
      return [AbstractValue (name, Name.Set.elements free_typ_vars, typ)]
    | Tstr_typext _ ->
      error_message
        (Error "type_extension")
        NotSupported
        "Structure item `typext` not handled."
    | Tstr_recmodule _ ->
      error_message
        (Error "recursive_module")
        NotSupported
        "Structure item `recmodule` not handled."
    | Tstr_class _ ->
      error_message
        (Error "class")
        NotSupported
        "Structure item `class` not handled."
    | Tstr_class_type _ ->
      error_message
        (Error "class_type")
        NotSupported
        "Structure item `class_type` not handled."
    | Tstr_include {
        incl_mod = { mod_desc = Tmod_ident (_, long_ident); mod_type; _ };
        _
      }
    | Tstr_include {
        incl_mod = {
          mod_desc = Tmod_constraint ({ mod_desc = Tmod_ident (_, long_ident); _ }, _, _, _);
          mod_type;
          _
        };
        _
      } ->
      let reference = PathName.of_long_ident false long_ident.txt in
      IsFirstClassModule.is_module_typ_first_class mod_type >>= fun is_first_class ->
      begin match is_first_class with
      | IsFirstClassModule.Found mod_type_path ->
        get_env >>= fun env ->
        begin match Mtype.scrape env mod_type with
        | Mty_ident path | Mty_alias (_, path) ->
          error_message
            (Error "include_module_with_abstract_module_type")
            NotSupported
            (
              "Cannot get the fields of the abstract module type `" ^
              Path.name path ^ "` to handle the include."
            )
        | Mty_signature signature ->
          return (
            signature |> Util.List.filter_map (fun signature_item ->
              match signature_item with
              | Types.Sig_value (ident, _) | Sig_type (ident, _, _) ->
                let is_value =
                  match signature_item with
                  | Types.Sig_value _ -> true
                  | _ -> false in
                let name = Name.of_ident is_value ident in
                let field =
                  PathName.of_path_and_name_with_convert mod_type_path name in
                Some (
                  simple_value
                    name
                    (Exp.Variable (
                      MixedPath.Access (
                        MixedPath.PathName reference,
                        field,
                        false
                      )
                    ))
                )
              | _ -> None
            )
          )
        | Mty_functor _ ->
          error_message
            (Error "include_functor")
            Unexpected
            "Unexpected include of functor."
        end
      | IsFirstClassModule.Not_found _ ->
        return [ModuleInclude reference]
      end
    | Tstr_include _ ->
      error_message
        (Error "include")
        NotSupported
        (
          "Cannot include this kind of module expression.\n\n" ^
          "Try to first give a name to this module."
        )
    (* We ignore attribute fields. *)
    | Tstr_attribute _ -> return [])) in
  structure.str_items |> Monad.List.flatten_map of_structure_item

(** Pretty-print a structure to Coq. *)
let rec to_coq (defs : t list) : SmartPrint.t =
  let rec to_coq_one (def : t) : SmartPrint.t =
    match def with
    | Value value -> Value.to_coq value
    | AbstractValue (name, typ_vars, typ) ->
      !^ "Parameter" ^^ Name.to_coq name ^^ !^ ":" ^^
      (match typ_vars with
      | [] -> empty
      | _ :: _ ->
        !^ "forall" ^^
        nest (parens (separate space (typ_vars |> List.map Name.to_coq) ^^ !^ ":" ^^ Pp.set)) ^-^ !^ ","
      ) ^^
      Type.to_coq None None typ ^-^ !^ "."
    | TypeDefinition typ_def -> TypeDefinition.to_coq typ_def
    | Open o -> Open.to_coq o
    | Module (name, defs) ->
      nest (
        !^ "Module" ^^ Name.to_coq name ^-^ !^ "." ^^ newline ^^
        indent (to_coq defs) ^^ newline ^^
        !^ "End" ^^ Name.to_coq name ^-^ !^ "."
      )
    | ModuleInclude reference ->
      nest (!^ "Include" ^^ PathName.to_coq reference ^-^ !^ ".")
    | ModuleSynonym (name, reference) ->
      nest (!^ "Module" ^^ Name.to_coq name ^^ !^ ":=" ^^ PathName.to_coq reference ^-^ !^ ".")
    | Signature (name, signature) -> Signature.to_coq_definition name signature
    | Error message -> !^ ( "(* " ^ message ^ " *)")
    | ErrorMessage (message, def) ->
      nest (
        Error.to_comment message ^^ newline ^^
        to_coq_one def
      ) in
  separate (newline ^^ newline) (defs |> List.map to_coq_one)