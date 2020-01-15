(** A [PathName.t], eventually followed by accesses inside first-class modules. *)
open SmartPrint
open Monad.Notations

(** [Access] corresponds to projections from first-class modules. *)
type t =
  | Access of t * PathName.t * bool
  | PathName of PathName.t

(** Shortcut to introduce new local variables for example. *)
let of_name (name : Name.t) : t =
  PathName (PathName.of_name [] name)

let rec of_path_aux (path : Path.t)
  : (Path.t * (Path.t * string) list) Monad.t =
  match path with
  | Papply _ -> failwith "Unexpected path application"
  | Pdot (path', field_string, _) ->
    of_path_aux path' >>= fun (namespace_path, fields) ->
    (* Get the module declaration of the current [path'] to check if it refers
        to a first-class module. *)
    get_env >>= fun env ->
    begin match Env.find_module path' env with
    | module_declaration ->
      let { Types.md_type; _ } = module_declaration in
      IsFirstClassModule.is_module_typ_first_class md_type >>= fun is_first_class ->
      begin match is_first_class with
      | IsFirstClassModule.Found signature_path ->
        return (
          namespace_path,
          (signature_path, field_string) :: fields
        )
      | IsFirstClassModule.Not_found _ -> return (path, [])
      end
    | exception _ -> raise (path, []) NotFound ("Module '" ^ Path.name path' ^ "' not found")
    end
  | Pident _ -> return (path, [])

(** The current environment must include the potential first-class module signature
    definition of the corresponding projection in the [path]. *)
let of_path
  (is_value : bool)
  (path : Path.t)
  (long_ident : Longident.t option)
  : t Monad.t =
  of_path_aux path >>= fun (path', fields) ->
  let path_name = PathName.of_path_without_convert is_value path' in
  match fields with
  | [] ->
    begin match PathName.try_convert path_name with
    | None ->
      begin match long_ident with
      | None -> return (PathName path_name)
      | Some long_ident -> return (PathName (PathName.of_long_ident is_value long_ident))
      end
    | Some path_name -> return (PathName path_name)
    end
  | _ :: _ ->
    get_scoping_env >>= fun scoping_env ->
    let is_local =
      match scoping_env with
      | None -> false
      | Some scoping_env ->
        begin match Env.find_module path' scoping_env with
        | _ -> false
        | exception _ -> true
        end in
    let (mixed_path, _) =
      List.fold_left
        (fun (mixed_path, is_local) (signature_path, field_string) ->
          let field_name = Name.of_string is_value field_string in
          let field_path_name = PathName.of_path_and_name_with_convert signature_path field_name in
          (Access (mixed_path, field_path_name, is_local), true)
        )
        (PathName (PathName.convert path_name), is_local)
        (List.rev fields) in
    return mixed_path

let rec to_coq (path : t) : SmartPrint.t =
  match path with
  | Access (path, field_path_name, is_local) ->
    to_coq path ^-^ !^ "." ^-^
    (if is_local then parens else brakets) (PathName.to_coq field_path_name)
  | PathName path_name -> PathName.to_coq path_name
