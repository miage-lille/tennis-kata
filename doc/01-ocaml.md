## Meet OCaml

[OCaml](https://ocaml.org/) is a general purpose programming language with an emphasis on expressiveness and safety.

### Houston ! We have a problem

Since you may be not an expert of OCaml you will sometime need help. Good to you, there is lot of resources. Any time you encounter a difficulty, you should :

1. Take a look at OCaml tutorials : https://ocaml.org/learn/tutorials/
2. Read the manual : https://ocaml.org/releases/4.10/htmlman/index.html
3. Take a look at this book : https://dev.realworldocaml.org/
4. Browse the forum : https://discuss.ocaml.org/
5. Join the discord and ask : https://discord.com/invite/cCYQbqN

### Warm up tour

Open the [try site](https://try.ocamlpro.com/) and try each code bellow in the OCaml box, step by step

#### Binding

Variable declaration and assignement use `let` binding :

```OCaml
(* This is a comment *)
let greeting: string = "hello"
let score: int = 10
```

Bidings are immutables but you can wrap it with a reference, which is like a box whose content can change.
The reference itself is immutable but you can change the refered value with `:=` operator and you can access its value with a dereference operator `!`

```OCaml
let mut_score: int ref = ref 10
let () = mut_score := 5
let five: int = !mut_score
let string_five: string = string_of_int five
let () = print_endline string_five (*OCaml function's call doesn't need parenthesis*)
```

However, you may create a new binding of the same name which shadows the previous binding :

```OCaml
let greeting: string = "hello"
let () = print_endline greeting
let greeting: string =  "bye"
let () = print_endline greeting
```

#### Types

The type system is completely "sound". This means that, as long as your code compiles fine, every type guarantees that it's not lying about itself. In a conventional, best-effort type system, just because the type says it's e.g. "an integer that's never null", doesn't mean it's actually never null. In contrast, a pure OCaml program has no null or undefined bugs.

OCaml types can be inferred. The type system deduces the types for you even if you don't manually write them down.

```OCaml
let greeting = "hello"
let score = 10
```

will infer

```OCaml
val greeting : string = "hello"
val score : int = 10
```

Alias types can refer to a type by a different name. They'll be equivalent:

```OCaml
type scoreType = int
let score : scoreType = 10
```

OCaml provides two list primitives : List and Array

```OCaml
(* Lists are homogeneous, immutable, fast at prepending items *)
let top_players : string list = ["Djokovic"; "Nadal"; "Thiem"]
let more_players = "Federer" :: top_players (* create a new list preprend by "Federer" *)

(* Arrays are mutable, fast at random access & updates, fix-sized on native *)
let top_players_array : string array = [|"Djokovic"; "Nadal"; "Thiem"|]
let novac : string = Array.get top_players_array 0 (* get "Djokovic" *)
let _ = Array.set top_players_array 0 "Federer" (* mutate top_players_array replacing "Djokovic" by  "Federer" *)
```

Product types

```OCaml
(* Tuples are immutable, ordered, fix-sized at creation time heterogeneous *)
let name_and_points: (string * int) = ("Djokovic", 11260 )

type coord_3d = (int * int * int)
let warehouse_coord: coord_3d = (1, 4, 18)

(* Records are immutable by default and fixed in field names and types *)
type player_atp = {
  points: int;
  name: string;
  }
let raphael = { points = 9850; name = "Nadal"}
let name =  "Federer"
let roger = { name; points = 6630 } (* punning ! Same as let roger = { name = name ; points = 6630}   *)
```

Variant types

```OCaml
type stateVariant =
  | Ready of player_atp
  | Injuried
  | Retired

let how_is_federer = Ready roger
let how_is_pete_sampras = Retired
```

Ready, Injuried and Retired are called "constructors" (or "tag"). The | bar separates each constructor. A variant's constructors need to be capitalized. Type constructor may have parameters

Algebraic data types come with one of the most important features : **pattern matching**

```Ocaml
let get_grunt how_are_you =
  match how_are_you with
  | Injuried -> "Outch !"
  | Ready p -> "Great ! " ^ p.name ^ " grunt : Aaaaaaah ! while hitting shots"
  | Retired -> "!!!"

let grunt = get_grunt how_is_federer
```

#### Options

OCaml itself doesn't have the notion of null or undefined. This is a great thing, as it wipes out an entire category of bugs. No more undefined is not a function, and cannot access foo of undefined!

We represent the existence and nonexistence of a value by wrapping it with the option type. Here's its definition from the standard library:

```Ocaml
type 'a option =
  | None
  | Some of 'a
```

It means "a value of type option is either None (nothing) or that actual value wrapped in a Some".

Exemple :

```Ocaml
type gear = string option
let is_equiped w =
  match w with
  | None  -> "not dangerous"
  | Some a -> "is equiped with a " ^ a
let unequiped: gear = None
let racket: gear = Some "racket"
(* OCaml isn't pure and that's fine *)
let () = print_endline (is_equiped unequiped)
let () = print_endline (is_equiped racket)
```

#### Functions

Functions are declared with an expression

```OCaml
(* 4 syntaxes produces the same bytecode ! *)
let add: int -> int -> int = fun x y  -> x + y (* Functions are lambas binded with let *)
let add: int -> int -> int  = fun x  -> fun y  -> x + y (* OCaml auto-curry functions as suggested by function type *)
let add (x:int) (y:int) : int = x + y (* shorter syntax *)
let add x y = x + y (* shorter syntax with type inference *)

let () = let four = add 1 3 in print_endline (string_of_int four)
```

For readablity, OCaml developers perfer the first version `let add: int -> int -> int = fun x y -> x + y` when they must explicit the function's type, or the last one `let add x y = x + y ` when type inference works which is often the case when you have a real implementation.

Functions does not need parentheses to be applied but they are evaluated left-to-right, so you may need parentheses to delimitate an expression. In the exemple above, `print_endline` take a string but `string_of_int` has type `int -> string` but `string_of_int four` has type `string`. You can reduce the need of parentheses with the use of application operator `@@`

```OCaml
let () = let four = add 1 3 in print_endline @@ string_of_int four
```

OCaml function are auto-curried.

```OCaml
let multiply x y = x * y
```

So OCaml functions can automatically be partially called.

```OCaml
let multiply2 = multiply 2
let ten = multiply2 5
```

Another great feature is the pipe opertator which can compose function by piping them

```OCaml
let twenty = (multiply2 5) |> multiply2
(* same as *)
let twenty2 = multiply2 (multiply2 5)
(* same as *)
let twenty3 = multiply2 @@ multiply2 5

let () = twenty |> string_of_int |> print_endline (* same as print_endline(string_of_int(twenty)) *)
```

#### Binding effects

You may notice some `let () = ...` : this means we are binding the expression to the unit value `()`. Unit is a type that have only one value `()` which represent the absence of value (similar to `void` in C-like langs). Pure effect expression, like `print_endline "hello world"` returns `unit` type.

It a good practice to bind this kind of expressions to `()`. So we can write `let () = print_endline "hello world"`.

Sometime you may bind an expression that you will not use the result latter.
In thoose cases, the good practice is to bind the expressoin to `_`. `_` means "I know there is something here and I explicitly say I will not use it, so I don't name it". Notice that `_`  can be used in a pattern as a wildcard: it matches values of any type and does not bind any name.

```Ocaml
let () = print_endline "Welcome Mr. Djokovic" (* there is a type check that ensure print_endline "Welcome Mr. Djokovic" returns unit value *)
let _ =  print_endline "Welcome Mr. Djokovic" (* works but the compiler will not validate that the right part returns unit *)
let _ = "Djokovic"
let (player, _) : (string * int) = ("Djokovic", 11260 ) (* binds "Djokovic" to the identifier player and checks the type is string ; drop 11260 *)
```
 
#### Modules

OCaml incorporates a modular programming system. Modules provide an encapsulation mechanism and allow code to be organized into logical units, providing useful namespaces when using them.

In OCaml all the code is encapsulated in modules. If we put the whole code in a `game.ml` file, it automatically defines a `Game` module.

Module's names start with an upper character.

As an exemple we define a module Number which manage int and float numbers

```ocaml
module Number = struct
  type t =
    | Int of int
    | Float of float

  let add a1 a2 =
    match (a1, a2) with
    | Int x, Int y -> Int (x + y)
    | Float x, Float y -> Float (x +. y)
    | Float x, Int y -> Float (x +. float_of_int y)
    | Int x, Float y -> Float (float_of_int x +. y)


  let ( +~ ) = add

  let string_of_number num =
    match num with
    | Int i -> string_of_int i
    | Float f -> string_of_float f
end
```

You can access module content with the namespace :

```ocaml
let one = Number.Int 1
```

or open it in a global scope :

```ocaml
open Number (* opened for the whole scope below *)

let four = Int 1 +~ Int 3
```

or open it in a local scope :

```ocaml

let four =
  let open Number in
  let one = Int 1 in
  one +~ Int 3 (* opened for this binding *)
```

or open it in an expression :

```ocaml
let four = Number.(Int 1 +~ Int 3) (* opened only for this expression *)
```

There is much more amazing features to know in OCaml, we just focus here in those that you should use to solve the tennis kata (￣^￣)ゞ

Let's go to [The tennis kata](./02-kata.md)
