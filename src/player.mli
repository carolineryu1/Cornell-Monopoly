open Board
(*Represents data associated with a player of the game. Includes player
  name and player symbol. *)

type player_name = string
type player_id = int
type symbol

type t = {
  id : int;
  name : string;
  symbol : symbol;
  mutable balance : int;
  mutable properties : property list;
  mutable location : int;
  mutable in_duff : bool;
  mutable skip_turn_status : bool;
  mutable is_bankrupt: bool;
}

val convert_to_symbol : string -> symbol
(**[convert_to_symbol symbol] converts string input to Symbol output.*)

val create_new_player : int -> string -> symbol -> t
(**[create_new_player id name symbol] creates a new player with a unique
   id, name, and symbol*)

val manual_input_of_player_balance : t -> player_id -> unit
(**[create_new_player id name symbol] changes the player's balance with a manual balance *)

val get_player_name : t -> player_name
(**[get_player_name p] returns the [player] name.*)

val get_player_id : t -> player_id
(**[get_player_id p] returns the [player] id.*)

val get_player_loc : t -> int
(**[get_player_loc p] returns the [player] location.*)

val get_player_symbol : t -> symbol
(**[get_player_loc p] returns the [player] symbol.*)

val get_player_balance : t -> int
(**[get_player_balance p] returns the [player] balance*)

val get_player_properties : t -> property list
(**[get_player_properties p] returns the [player] list of properties*)

val update_player_loc : t -> player_id -> tile list -> unit
(**[update_player_loc p new_loc] updates the [player] location.*)

val send_to_duff : t -> Board.t -> unit
(**[send_to_duff player board] sends the [player] to jail. *)

val is_player_in_duff : t -> bool
(**[is_player_in_duff player] checks whether or not the [player]
   location is jail*)

val change_jail_status : t -> unit
(**[change_jail_status player] checks to see if the [player] jail status
   is in jail or not in jail and changes it to the opposite.*)

val change_skip_turn_status : t -> unit
(**[change_skip_turn_status p] changes the skip turn status to the 
negation of true or false.*)
val skip_turn_status : t -> bool
(**[skip_turn_status p] returns true or false depending on whether or not the 
player has to skip their next turn.*)

(**[skip_turn p] changes the state so that the player must skip their next turn.*)
val skip_turn : t -> unit

val print_properties : t -> unit
(**[print_properties player] prints the properties owned by [player] *)

val deduct_balance : t -> int -> unit
(**[deduct_balance player amount] decreases the [player] balance by
   amount [amount]*)

val add_to_properties : t -> property -> unit
(**[add_to_properties player property] adds [property] to properties
   that [player] owns. *)

val chance : t -> Board.t -> unit
(**[chance p] draws a random chance card and what happens is chosen by
   random number generator. *)

(**[is_bankrupt p] is whether a player is bankrupt*)
   val is_bankrupt: t -> bool
   
(**[check_if_bankrupt p] checks if a player is bankrupt*)
   val check_if_bankrupt : t -> unit