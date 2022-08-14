open Yojson.Basic.Util
open Board
open Printf

exception UnknownSymbol

type player_name = string
type player_id = int

type symbol =
  | Square
  | Circle
  | Umbrella
  | Triangle
  | Dog
  | Cat
  | Fish
  | Spider

type t = {
  id : int;
  name : string;
  symbol : symbol;
  mutable balance : int;
  mutable properties : property list;
  mutable location : int;
  mutable in_duff : bool;
  mutable skip_turn_status : bool;
  mutable is_bankrupt : bool;
}

let convert_to_symbol (symbol : string) : symbol =
  match String.lowercase_ascii symbol with
  | "square" -> Square
  | "circle" -> Circle
  | "umbrella" -> Umbrella
  | "triangle" -> Triangle
  | "dog" -> Dog
  | "cat" -> Cat
  | "fish" -> Fish
  | "spider" -> Spider
  | _ -> raise UnknownSymbol

let create_new_player id (name : string) (symbol : symbol) =
  {
    id;
    name;
    symbol;
    balance = 1500;
    properties = [];
    location = 0;
    in_duff = false;
    skip_turn_status = false;
    is_bankrupt = false;
  }

let manual_input_of_player_balance player manual_balance =
  player.balance <- manual_balance

let get_player_name player = player.name
let get_player_id player = player.id
let get_player_loc player : int = player.location
let get_player_symbol player = player.symbol
let get_player_balance player = player.balance
let get_player_properties player = player.properties

let update_player_loc player roll_num tiles =
  let new_loc = (player.location + roll_num) mod List.length tiles in
  player.location <- new_loc

let send_to_duff player board =
  let duff_tile = List.find (fun (x : tile) -> x = Duff) board.tiles in
  player.in_duff <- true;
  player.location <- return_tile_position duff_tile board.tiles

let is_player_in_duff player = player.in_duff

let change_jail_status player =
  match player.in_duff with
  | true -> player.in_duff <- false
  | false -> player.in_duff <- true

let change_skip_turn_status player =
  match player.skip_turn_status with
  | true -> player.skip_turn_status <- false
  | false -> player.skip_turn_status <- true

let skip_turn_status player = player.skip_turn_status
let skip_turn player = player.skip_turn_status <- true

let rec prop_id_list (properties : property list) : string list =
  match properties with
  | [] -> []
  | h :: t -> h.id :: prop_id_list t

let properties_inventory player = prop_id_list player.properties

let print_properties player =
  if player.properties = [] then
    print_string "You have no properties right now. "
  else List.iter print_string (properties_inventory player)

let check_if_bankrupt player =
  if player.balance <= 0 then player.is_bankrupt <- true else ()

let deduct_balance player (amount : int) =
  player.balance <- player.balance - amount;
  check_if_bankrupt player

let add_to_properties player property =
  player.properties <- property :: player.properties

let chance (p : t) (board : Board.t) =
  Random.self_init ();
  let r = 1 + Random.int 5 in
  if r = 1 then (
    print_string "Congrats! Your chance card says you get $100!";
    p.balance <- p.balance + 100)
  else if r = 2 then (
    print_string "Congrats! Your chance card says you get $250!";
    p.balance <- p.balance + 250)
  else if r = 3 then (
    print_string "Congrats! Your chance card says you get $500!";
    p.balance <- p.balance + 500)
  else if r = 4 then (
    print_string "Congrats! Your chance card says you get $1000!";
    p.balance <- p.balance + 1000)
  else if r = 5 then (
    print_string "Oh no. Your chance card says you're headed to jail.";
    send_to_duff p board)
  else if r = 6 then (
    print_string "Oh no. Your chance card says you must skip a turn.";
    skip_turn p)

let is_bankrupt player = player.is_bankrupt
