open Board
open Player

type t = {
  board : Board.t;
  players : (player_id * Player.t) list;
  mutable current_turn : int;
}

let state0_init players board = { board; players; current_turn = 1 }

let manual_current_turn int players board =
  { board; players; current_turn = int }

let get_cur_turn state = state.current_turn
let get_cur_player state p_id = List.assoc p_id state.players

let switch_turn state =
  if state.current_turn + 1 <= List.length state.players then
    { state with current_turn = state.current_turn + 1 }
  else { state with current_turn = 1 }
