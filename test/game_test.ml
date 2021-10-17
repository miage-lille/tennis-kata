open Tennis.Game

(* We define Alcotest.TESTABLE for Tennis.Game types *)
let player =
  Alcotest.testable (Fmt.using Tennis.Game.string_of_player Fmt.string) ( = )


let score =
  Alcotest.testable (Fmt.using Tennis.Game.string_of_score Fmt.string) ( = )


(* We define our test case below *)

(* TESTS for tooling functions *)
let given_Player_one_when_string_of_player () =
  Alcotest.(check string)
    "Player_one is Player 1"
    "Player 1"
    (string_of_player Player_one)


let given_Player_one_when_other_player () =
  Alcotest.(check player)
    "other_player is Player_two"
    Player_two
    (other_player Player_one)


let given_Player_one_when_string_of_player () =
  Alcotest.(check string)
    "Player_one is Player 1"
    "Player 1"
    (string_of_player Player_one)


(* TEST SET for tooling functions *)
let tooling_set =
  let open Alcotest in
  [ test_case
      (* text display in the console for the test *)
      "Given Player_one then string_of_player is Player 1"
      (* always use `Quick mode *)
      `Quick
      (* the test define above *)
      given_Player_one_when_string_of_player
  ; test_case
      "Given Player_one then other player is Player_two"
      `Quick
      given_Player_one_when_other_player
  ]


(* TESTS for transition functions *)
let given_deuce_when_player_one_wins () =
  Alcotest.(check score)
    "score is Advantage Player_one"
    (* to change when we will know how represent Advantage *)
    (raise @@ Failure "How represent Advantage Value")
    (score_when_deuce Player_one)


let given_deuce_when_player_two_wins () =
  Alcotest.(check score)
    "score is Advantage Player_two"
    (raise @@ Failure "How represent Advantage Value")
    (score_when_deuce Player_two)


let given_advantage_when_advantaged_player_wins () =
  let advantaged_player = Player_one in
  let winner = advantaged_player in
  Alcotest.(check score)
    "score is Game advantaged_player"
    (Game advantaged_player)
    (score_when_advantage advantaged_player winner)


let given_advantage_when_other_player_wins () =
  let advantaged_player = Player_one in
  let winner = other_player advantaged_player in
  Alcotest.(check score)
    "score is Deuce"
    Deuce
    (score_when_advantage advantaged_player winner)


let given_player_one_at_40_when_player_one_wins () =
  Alcotest.(check score)
    "score is Game for Player_one"
    (Game Player_one)
    (raise @@ Failure "How to code score_when_forty")


let given_player_one_at_40_other_at_30_when_other_wins () =
  Alcotest.(check score)
    "score is Deuce"
    Deuce
    (raise @@ Failure "How to code score_when_forty")


let given_player_one_at_40_other_at_15_when_other_wins () =
  Alcotest.(check score)
    "score is 40 / 30"
    Deuce
    (raise @@ Failure "How to code score_when_forty")


let given_player_one_at_15_other_at_15_when_player_one_wins () =
  Alcotest.(check score)
    "score is 30 / 15"
    (raise @@ Failure "You turn to code the expected result")
    (raise @@ Failure "You turn to code the test")


let given_player_one_at_0_other_at_15_when_other_wins () =
  Alcotest.(check score)
    "score is 0 / 30"
    (raise @@ Failure "You turn to code the expected result")
    (raise @@ Failure "You turn to code the test")


let given_player_one_at_30_other_at_15_when_player_one_wins () =
  Alcotest.(check score)
    "score is 40 / 15"
    (raise @@ Failure "You turn to code the expected result")
    (raise @@ Failure "You turn to code the test")


(* TEST SET for transition functions *)
let transitions_set =
  let open Alcotest in
  [ test_case
      "Given Deuce when Player_one wins then score is Advantage Player_one"
      `Quick
      given_deuce_when_player_one_wins
  ; test_case
      "Given Deuce when Player_two wins then score is Advantage Player_two"
      `Quick
      given_deuce_when_player_two_wins
  ; test_case
      "Given Advantage when advantaged player wins then score is Game \
       advantaged_player"
      `Quick
      given_advantage_when_advantaged_player_wins
  ; test_case
      "Given Advantage when other player wins then score is Deuce"
      `Quick
      given_advantage_when_other_player_wins
  ; test_case
      "Given Player_one at 40 when Player_one wins then score is Game \
       Player_one"
      `Quick
      given_player_one_at_40_when_player_one_wins
  ; test_case
      "Given Player_one at 40 | other at 30 when other wins then score is Deuce"
      `Quick
      given_player_one_at_40_other_at_30_when_other_wins
  ; test_case
      "Given Player_one at 40 | other at 0 when other wins then score is 40 / \
       30"
      `Quick
      given_player_one_at_40_other_at_15_when_other_wins
  ; test_case
      "Given Player_one at 15 | other at 15 when other wins then score is 30 / \
       15"
      `Quick
      given_player_one_at_15_other_at_15_when_player_one_wins
  ; test_case
      "Given Player_one at 0 | other at 15 when other wins then score is 0 / 30"
      `Quick
      given_player_one_at_0_other_at_15_when_other_wins
  ; test_case
      "Given Player_one at 30 | other at 15 when Player_one wins then score is 40 / \
       15"
      `Quick
      given_player_one_at_30_other_at_15_when_player_one_wins
  ]
