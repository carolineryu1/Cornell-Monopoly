(** Representation of dynamic Cornellopy state.

    This module represents the state of an Cornellopy as it is being
    played, including the current player, the current turn, and
    functions that cause the state to change. *)

type t
(**[state0_init p b] initializes the state at the beginning of the game. *)
val state0_init : (Player.player_id * Player.t) list -> Board.t -> t

(**[manual_current_turn i p b] returns the players on the board
and the current turn.*)
val manual_current_turn :
  Player.player_id -> (Player.player_id * Player.t) list -> Board.t -> t

(**[get_cur_turn st] returns the player id of the player whose
turn it is in the current [st]*)
val get_cur_turn : t -> Player.player_id
(**[get_cur_player st pl_id] returns the player with
player id [pl_id] in the current state [st].*)
val get_cur_player : t -> Player.player_id -> Player.t
(**[switch_turn st] switches the turn.*)
val switch_turn : t -> t
