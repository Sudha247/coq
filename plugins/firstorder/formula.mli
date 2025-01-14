(************************************************************************)
(*         *   The Coq Proof Assistant / The Coq Development Team       *)
(*  v      *         Copyright INRIA, CNRS and contributors             *)
(* <O___,, * (see version control and CREDITS file for authors & dates) *)
(*   \VV/  **************************************************************)
(*    //   *    This file is distributed under the terms of the         *)
(*         *     GNU Lesser General Public License Version 2.1          *)
(*         *     (see LICENSE file for the text of the license)         *)
(************************************************************************)

open Names
open Constr
open EConstr

type flags = {
  qflag : bool;
  reds : CClosure.RedFlags.reds;
}

val (=?) : ('a -> 'a -> int) -> ('b -> 'b -> int) ->
  'a -> 'a -> 'b -> 'b -> int

val (==?) : ('a -> 'a -> 'b ->'b -> int) -> ('c -> 'c -> int) ->
  'a -> 'a -> 'b -> 'b -> 'c ->'c -> int

type ('a,'b) sum = Left of 'a | Right of 'b

type counter = bool -> metavariable

val construct_nhyps : Environ.env -> pinductive -> int array

val ind_hyps : Environ.env -> Evd.evar_map -> int -> pinductive ->
  constr list -> EConstr.rel_context array

type atom = private { atom : EConstr.t }

type atoms = { positive:atom list; negative:atom list }

type side = Hyp | Concl | Hint

val dummy_id: GlobRef.t

val build_atoms : flags:flags -> Environ.env -> Evd.evar_map -> counter ->
  side -> constr -> bool * atoms

type right_pattern =
    Rarrow
  | Rand
  | Ror
  | Rfalse
  | Rforall
  | Rexists of metavariable*constr*bool

type left_arrow_pattern=
    LLatom
  | LLfalse of pinductive*constr list
  | LLand of pinductive*constr list
  | LLor of pinductive*constr list
  | LLforall of constr
  | LLexists of pinductive*constr list
  | LLarrow of constr*constr*constr

type left_pattern=
    Lfalse
  | Land of pinductive
  | Lor of pinductive
  | Lforall of metavariable*constr*bool
  | Lexists of pinductive
  | LA of constr*left_arrow_pattern

type t= private {id: GlobRef.t;
        constr: constr;
        pat: (left_pattern,right_pattern) sum;
        atoms: atoms}

val build_formula : flags:flags -> Environ.env -> Evd.evar_map -> side -> GlobRef.t -> types ->
  counter -> (t, atom) sum
