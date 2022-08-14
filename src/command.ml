type object_phrase = string list

type command =
  | Roll
  | Quit
  | Properties
  | Instructions
  | Balance
  | WrongCommand

exception Empty

(** [split_words s] returns a string list of words without spaces] *)
let split_words s : string list =
  s |> String.split_on_char ' ' |> List.filter (fun x -> x <> "")

let verb (string_lst : object_phrase) : string =
  match string_lst with
  | [] -> ""
  | h :: t -> h

let other_words (string_lst : object_phrase) : string list =
  match string_lst with
  | [] -> []
  | h :: t -> t

let parse str =
  match str with
  | "" -> raise Empty
  | str when String.trim str = "" -> raise Empty
  | str
    when verb (split_words str) = "roll"
         && other_words (split_words str) = [] ->
      Roll
  | str
    when verb (split_words str) = "quit"
         && other_words (split_words str) = [] ->
      Quit
  | str
    when verb (split_words str) = "instructions"
         && other_words (split_words str) = [] ->
      Instructions
  | str
    when verb (split_words str) = "properties"
         && other_words (split_words str) = [] ->
      Properties
  | str
    when verb (split_words str) = "balance"
         && other_words (split_words str) = [] ->
      Balance
  | str -> WrongCommand