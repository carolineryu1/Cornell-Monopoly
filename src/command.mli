(** Parsing of player commands. *)

type object_phrase = string list
(** The type [object_phrase] represents the object phrase that can be
    part of a player command. Each element of the list represents a word
    of the object phrase, where a {i word} is defined as a consecutive
    sequence of non-space characters. Thus, no element of the list
    should contain any leading, internal, or trailing spaces. The list
    is in the same order as the words in the original player command.**)

(** The type [command] represents a player command that is decomposed
    into a verb and possibly an object phrase. *)
type command =
  | Roll
  | Quit
  | Properties
  | Instructions
  | Balance
  | WrongCommand

exception Empty
(** Raised when an empty command is parsed. *)

(** Raised when a malformed command is encountered. *)

val parse : string -> command
(** [parse str] parses a player's input into a [command], as follows.
    The first word (i.e., consecutive sequence of non-space characters)
    of [str] becomes the verb. The rest of the words, if any, become the
    object phrase. Examples:

    - [parse "    roll   "] is [Roll]
    - [parse "quit"] is [Quit].

    Requires: [str] contains only alphanumeric (A-Z, a-z, 0-9) and space
    characters (only ASCII character code 32; not tabs or newlines,
    etc.).

    Raises: [Empty] if [str] is the empty string or contains only
    spaces.

    Raises: [Malformed] if the command is malformed. A command is
    {i malformed} if the verb is neither "quit" nor "go", or if the verb
    is "quit" and there is a non-empty object phrase, or if the verb is
    "go" and there is an empty object phrase.*)
