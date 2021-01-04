Require Import OCaml.OCaml.

Set Primitive Projections.
Set Printing Projections.
Open Scope string_scope.
Open Scope Z_scope.
Open Scope type_scope.
Import ListNotations.

Parameter t : Set.

Parameter foo : t.

Parameter arg : forall (a b : Set), Set.

Parameter x : forall {a b : Set}, a -> b -> arg a b.

Module M.
  Inductive l (a : Set) : Set :=
  | Nil : l a
  | Cons : a -> l a -> l a.
  
  Arguments Nil {_}.
  Arguments Cons {_}.
  
  Parameter b : bool.
End M.
