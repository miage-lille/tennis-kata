# Tennis Kata

_This Kata is an adaptation to OCaml of [Mark Seeman's serie of articles about property-based testing](http://blog.ploeh.dk/2016/02/10/types-properties-software/). Most of his article's exemples are un F#. I highly recommand the reading of his blog if you're interested by functional programming._

## About type systems

[Hindley–Milner type systems](https://en.wikipedia.org/wiki/Hindley%E2%80%93Milner_type_system) implemented in ML languages such as ocamlML, OCaml, Haskell or F#, offers more safety from static typing alone.

With the algebraic data types available in OCaml, you can design your types so that illegal states are unrepresentable. You can see this as "free" tests for your application.

We will illustrate it by the Tennis Kata

## Draw your racket

#### Code

Library code must be in [lib/game.ml](../lib/game.ml)

#### Developing

```sh
git clone <this-repo>
esy install
esy build
```

#### Running Binary

After building the project, you can run the main binary that is produced.

```sh
# Runs the "start" command in `package.json`.
esy start
```

#### Running Tests

```sh
# Runs the "test" command in `package.json`.
esy test
```

## Tennis

A tennis match consists of multiple sets that again are played as several games, in the kata, you only have to implement the scoring system for a single game:

- Each player can have either of these points in one game: Love, 15, 30, 40.
- If you have 40 and you win the ball, you win the game. There are, however, special rules.
- If both have 40, the players are deuce.
- If the game is in deuce, the winner of a ball will have advantage and game ball.
- If the player with advantage wins the ball, (s)he wins the game.
- If the player without advantage wins, they are back at deuce.

This problem is easy enough that it's fun to play with, but difficult enough that it's fun to play with.
<br/>(∩ ｀-´)⊃━ ☆ .\*･｡ﾟ

Along this Kata we will iterate on the implementation of the game and the associated unit tests.

### Type Driven Development

#### Players

In tennis, there are two players, which we can easily model with a discriminated union (a variant) :

```ocaml
type player =
  | Player_one
  | Player_two
```

#### Points

##### Naive point attempt with a type alias

```ocaml
type point = int
```

This easily enables you to model some of the legal point values:

```ocaml
let p1 : point = 15
let p2 : point = 30
```

It looks good so far, but how do you model love? It's not really an integer.

> Love would be a derivative of the french expression for an egg `L'oeuf` which sounds close to Love for english people because an egg looks like 0

Both players start with love, so it's intuitive to try to model love as 0 ...It's a hack, but it works. But your illegal values are not unrepresentable :

```ocaml
let p3 : point = 1000
let p4 : point = -20
```

For a 32-bit integer, this means that we have four legal representations (0, 15, 30, 40), and 4,294,967,291 illegal representations of a tennis point. Clearly this doesn't meet the goal of making illegal states unrepresentable. ლ(ಠ_ಠლ)

##### Second point attempt with a variant

You may see that love, 15, 30, and 40 aren't numbers, but rather labels. No arithmetic is performed on them. It's easy to constrain the domain of points with a variant

```ocaml
type point =
  | Love
  | Fifteen
  | Thirty
  | Forty
```

A Point value isn't a score. A score is a representation of a state in the game, with a point to each player. You can model this with a record:

```ocaml
type points_data =
  { player_one : point
  ; player_two : point
  }
```

You can experiment with this type:

```ocaml
let s1 = { player_one = Love; player_two = Love }
let s2 = { player_one = Fifteen; player_two = Love }
let s3 = { player_one = Thirty; player_two = Love }
```

What happens if players are evenly matched?

```ocaml
let even = { player_one = Forty; player_two = Forty }
```

_Forty-Forty_ isn't a valid tennis score; it's called _Deuce_.

If you're into [Domain-Driven Design](https://www.infoq.com/minibooks/domain-driven-design-quickly), you prefer using the ubiquitous language of the domain. When the tennis domain language says that it's not called forty-forty, but deuce, the code should reflect that.

##### Final attempt at a point type

The love-love, fifteen-love, etc. values that you can represent with the above PointsData type are all valid. Only when you approach the boundary value of forty do problems appear. A solution is to remove the offending Forty case from Point. (⊙_☉)

At this point, it may be helpful to recap what we have :

```ocaml
type player =
  | Player_one
  | Player_two

type point =
  | Love
  | Fifteen
  | Thirty

type points_data =
  { player_one : point
  ; player_two : point
  }
```

While this enables you to keep track of the score when both players have less than forty points, the following phases of a game still remain:

- One of the players have forty points.
- Deuce.
- Advantage to one of the players.
- One of the players won the game.

You can design the first of these with another record type:

```ocaml
type forty_data = {
  player: player (* The player who have forty points *)
  ;other_point: point (* Points of the other player *)
}
```

For instance, this value indicates that Player_one has forty points, and Player_two has Love :

```ocaml
let fd : forty_data = { player = Player_one; other_point = Love }
```

This is a legal score. Other values of this type exist, but none of them are illegal.

#### Score

Now you have two distinct types, PointsData and FortyData, that keep track of the score at two different phases of a tennis game. You still need to model the remaining three phases, and somehow turn all of these into a single type. This is an undertaking that can be surprisingly complicated in C# or Java, but is trivial to do with a variant:

```ocaml
type score =
  | Points of points_data
  | Forty of forty_data
  | Deuce
  | Advantage of player
  | Game of player
```

As an example, the game starts with both players at love:

```ocaml
let start_score : score = Points { player_one = Love; player_two = Love }
```

PlayerOne has forty points, and PlayerTwo has thirty points, you can create this value:

```ocaml
let another_score : score = Forty { player = Player_two; other_point = Thirty }
```

This model of the tennis score system enables you to express all legal values, while making illegal states unrepresentable.

These types govern what can be stated in the domain, but they don't provide any rules for how values can transition from one state to another.

### Exercice 1

Develop 2 functions : `string_of_point`, `string_of_score` that return string from a data of type player, point or score.

## Transitions

While the types defined in the previously make illegal states unrepresentable, they don't enforce any rules about how to transition from one state into another. A state transition should be a function that takes a current Score and the winner of a ball and returns a new Score. More formally, it should have the type `score -> player -> score`.

### Test Driven Development

We will apply Test-Driven Development following the Red/Green/Refactor cycle, using [Alcotest](https://github.com/mirage/alcotest).

We will define a smaller function for each case, and test the properties of each of these functions.

Test framework is already setup :

- [test/game_test.ml](../test/game_test.ml) : contains tests and test sets
- [test/framework.ml](../test/framework.ml) : bootstrap the test suite
- [test-runner/runner.ml](../test/framework.ml) : executable to run tests

### Deuce property

The case of deuce is special, because there's no further data associated with the state; when the score is deuce, it's deuce. This means that when calling scoreWhenDeuce, you don't have to supply the current state of the game.

In [game_test.ml](../test/game_test.ml) :

```ocaml
let given_deuce_when_player_one_wins () =
  Alcotest.(check score)
    "score is Advantage Player_one"
    (Advantage Player_one)
    (score_when_deuce Player_one)
```

The test fails because we don't have implement the function `scoreWhenDeuce` yet :

```ocaml
let score_when_deuce: player -> score = fun _ -> Advantage Player_one
```

Just in case, we will test the opposite

```ocaml
let given_deuce_when_player_two_wins () =
  Alcotest.(check score)
    "score is Advantage Player_two"
    (Advantage Player_two)
    (score_when_deuce Player_two)
```

Ooops we need to fix our function

```ocaml
let score_when_deuce: player -> score = fun winner -> Advantage winner
```

or since we can now infer the type of `score_when_deuce`

```ocaml
let score_when_deuce winner = Advantage winner
```

Now the test pass ! (•̀ᴗ•́)و

### Winning the game

#### Advantage

When one of the players have the advantage in tennis, the result can go one of two ways: either the player with the advantage wins the ball, in which case he or she wins the game, or the other player wins, in which case the next score is deuce.

We will add a new test :

```ocaml
let given_advantage_when_advantaged_player_wins () =
  let advantaged_player = Player_one in
  let winner = advantaged_player in
  Alcotest.(check score)
    "score is Game advantaged_player"
    (Game advantaged_player)
    (score_when_advantage advantaged_player winner)

```

The test fails because we don't have implement the function `score_when_advantage` yet :

```ocaml
let score_when_advantage : player -> player -> score =
 fun _advantagedPlayer winner -> Game winner
```

Now the test pass ! (•̀ᴗ•́)و

Add a new test :

```ocaml
let given_advantage_when_other_player_wins () =
  let advantaged_player = Player_one in
  let winner = other_player advantaged_player in
  Alcotest.(check score)
    "score is Deuce"
    Deuce
    (score_when_advantage advantaged_player winner)
```

The test fails again (⊙_☉)

The above implementation of `score_when_advantage` is obviously incorrect, because it always claims that the advantaged player wins the game, regardless of who wins the ball.

```ocaml
let score_when_advantage advantagedPlayer winner =
  if advantagedPlayer = winner then Game winner else Deuce
```

Now the test pass ! (•̀ᴗ•́)و

#### Forty

When one of the players have forty points, there are three possible outcomes of the next ball:

1. If the player with forty points wins the ball, (s)he wins the game.
2. If the other player has thirty points, and wins the ball, the score is deuce.
3. If the other player has less than thirty points, and wins the ball, his or her points increases to the next level (from love to fifteen, or from fifteen to thirty).

The first property is the easiest :

```ocaml
let given_player_one_at_40_when_player_one_wins () =
  let forty_thirty = { player = Player_one; other_point = Thirty } in
  let winner = forty_thirty.player in
  Alcotest.(check score)
    "score is Deuce"
    (* to change when we will know how represent Advantage *)
    (Game Player_one)
    (score_when_forty forty_thirty winner)
```

The test fails, now add an implementation :

```ocaml
let score_when_forty cucurrent_forty winner = Game winner;
```

Now the test pass ! (•̀ᴗ•́)و

Add a test for the second :

```ocaml
let given_player_one_at_40_other_at_30_when_other_wins () =
  let forty_thirty = { player = Player_one; other_point = Thirty } in
  let winner = other_player forty_thirty.player in
  Alcotest.(check score)
    "score is Deuce"
    Deuce
    (score_when_forty forty_thirty winner)
```

And add a test for the third property :

```ocaml
let given_player_one_at_40_other_at_15_when_other_wins () =
  let forty_love = { player = Player_one; other_point = Love } in
  let forty_thirty = { player = Player_one; other_point = Thirty } in
  let winner = other_player forty_thirty.player in
  Alcotest.(check score)
    "score is 40 / 30"
    Forty forty_thirty
    (score_when_forty forty_love winner)
```

Iterate our implementation of `score_when_forty` to make the tests pass ! (•̀ᴗ•́)و

First create a tooling function

```ocaml
let increment_point point =
  match point with
  | Love -> Some Fifteen
  | Fifteen -> Some Thirty
  | Thirty -> None
```

Now we can use pattern matching to implement our function :

```ocaml
let score_when_forty current_forty winner =
  if current_forty.player = winner
  then Game winner
  else
    match increment_point current_forty.other_point with
    | None -> Deuce
    | Some p -> Forty { player = current_forty.player; other_point = p }
```

Now the test pass ! (ﾉ ◕ ヮ ◕)ﾉ\*:・ﾟ ✧

#### Points

##### Exercice

Implement some tests for points :

```ocaml
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
```

Then implemente `score_when_point` :

```ocaml
let score_when_point : points_data -> player -> score =
 fun current_point winner -> ...
```

Now the test pass ! (ﾉ ◕ ヮ ◕)ﾉ\*:・ﾟ ✧

### Composing the general function

What you need to implement is a state transition of the type `score -> score -> player`.

What you have so far are the following functions:

- score_when_point : `points_data -> Player -> Score`
- score_when_forty : `forty_data -> player -> score`
- score_when_deuce : `player -> score`
- score_when_advantage : `player -> player -> Score`

You can implement the desired function by clicking the pieces together:

```ocaml
let score current winner =
  match current with
  | Points p -> score_when_point p winner
  | Forty f -> score_when_forty f winner
  | Deuce -> score_when_deuce winner
  | Advantage a -> score_when_advantage a winner
  | Game g -> score_when_game g
```

You can notice we add a new function `score_when_game`. It's because a pattern matching must be exaustive. We should also use `_` which mean _default_. In our case, `current` type is `score` so its value may also be `Game` but when score is Game it means a playe win the game, score will no more change. Add the implementation :

```ocaml
let score_when_game winner = Game winner
```

Finally you can initialize a new Game :

```ocaml
let new_game = Points {player_one = Love; player_two = Love}
```

## Take away

Everything we did in this Kata is achievable in any language that can represent an ADT !

It should be the prefered way to encode state machine.

## Take away

Since we use OCaml we also would have code the state machine with GADT
