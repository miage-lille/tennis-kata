(* TYPES *)
type player =
  | Player_one
  | Player_two

(* Surely not the best choice *)
type point = int

type points_data =
  { player_one : point
  ; player_two : point
  }

(* Surely incomplete *)
type score =
  | Points of points_data
  | Deuce
  | Game of player

(* TOOLING FUNCTIONS *)

let string_of_player player =
  match player with
  | Player_one -> "Player 1"
  | Player_two -> "Player 2"


let other_player player =
  match player with
  | Player_one -> Player_two
  | Player_two -> Player_one


let string_of_point : point -> string =
 fun point ->
  match point with
  | _ -> "replace this with your code"


let string_of_score : score -> string =
 fun score ->
  match score with
  | _ -> "replace this with your code"


(* An exemple how to use option to avoid null values *)
let increment_point : point -> point option =
 fun point ->
  match point with
  | 0 -> Some 15
  | 15 -> Some 30
  | 30 -> Some 40
  | _ -> None


(* An exemple how to extract values from 'a option value*)
let read_from_option_point : point option -> point =
 fun optinal_point ->
  match optinal_point with
  | Some a -> a
  | None -> 0


(* TRANSITION FUNCTIONS *)
let score_when_deuce : player -> score =
 fun winner -> raise @@ Failure "not implemented"


let score_when_advantage : player -> player -> score =
 fun advantagedPlayer winner -> raise @@ Failure "not implemented"


let score_when_forty : 'a -> player -> score =
 fun current_forty winner -> raise @@ Failure "not implemented"


let score_when_game : player -> score =
 fun winner -> raise @@ Failure "not implemented"


let score_when_point : 'a -> player -> score =
 fun current winner -> raise @@ Failure "not implemented"


let score : score -> player -> score =
 fun currentScore winner -> raise @@ Failure "not implemented"
