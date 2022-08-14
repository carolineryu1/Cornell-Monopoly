
open Yojson.Basic.Util
open Game
open Player
open State
open Board
open Command
open Die
open Print

exception UnknownSymbol

let rec symbol () =  print_enter_symbol (); 
  match (read_line()) with 
  | exception End_of_file -> failwith "something went wrong with symbol"
  | "circle" -> Player.convert_to_symbol "circle"
  | "umbrella" -> Player.convert_to_symbol "umbrella"
  | "triangle" -> Player.convert_to_symbol "triangle"
  | "square" -> Player.convert_to_symbol "square"
  | "dog" -> Player.convert_to_symbol "dog"
  | "cat" -> Player.convert_to_symbol "cat"
  | "fish" -> Player.convert_to_symbol "fish"
  | "spider" -> Player.convert_to_symbol "spider"
  | _ -> Print.print_enter_new_symbol (); symbol() 

let players_init n = 
  let rec players_init_rec acc symbols_taken n = 
    match n with 
    | 0 -> acc
    | v -> begin 
      print_enter_player_name ();
      let name = match read_line () with 
      | exception End_of_file -> failwith "something went wrong with name"
      | some_name -> some_name in 
      begin 
      let smbl = symbol () in 
          let player = Player.create_new_player n name smbl in
          players_init_rec ((n, player) :: acc) (smbl :: symbols_taken) (n-1)
        end
      end
  in 
  players_init_rec [] [] n



  let rec game_cycle state board = 
    let cur_player = get_cur_player state (get_cur_turn state) in 
    if is_bankrupt cur_player = true then 
      begin
      print_string "You go bankcrupt. The other player wins!";
      exit 0
      end
    else 
    if Player.is_player_in_duff cur_player = true then 
    begin
      change_jail_status cur_player; game_cycle (switch_turn state) board
    end
    else if Player.skip_turn_status cur_player = true then
    begin
      change_skip_turn_status cur_player; game_cycle (switch_turn state) board
    end 
      else print_turn (get_player_name cur_player);
    match parse (read_line ()) with
    | exception End_of_file -> failwith "something went wrong"
    | Instructions -> Print.print_instructions (); game_cycle state board;
    | Roll -> 
      perform_roll state board cur_player;
      game_cycle (switch_turn state) board
    | Properties -> Player.print_properties cur_player; game_cycle state board;
    | Balance -> Print.print_balance cur_player; game_cycle state board;
    | Quit -> exit 0
    | WrongCommand -> Print.print_invalid_message (); game_cycle state board;
  
   and perform_roll state board cur_player = 

      let roll = roll_die () in
      print_roll_die (string_of_int roll);
  
      (* update location of a current player *)
      update_player_loc cur_player roll (tiles board);
      
      perform_landing state board cur_player
    
    and perform_landing state board player= 
    let new_loc_tile = List.nth (tiles board) (get_player_loc player) in 
    match new_loc_tile with 
    | Property id -> print_property_current_loc (get_prop_name id board);
     ignore(print_endline); perform_buy state board player id;
    | GoToDuff -> Print.print_go_to_duff (); send_to_duff player board
    | Duff -> Print.print_duff_message ();

    | Chance -> Print.print_chance_card (); Player.chance player board;
    | Fine i -> Print.print_fine i; deduct_balance player i

      and perform_buy state board player prop_tile = 
    let prop = get_prop_from_tile board prop_tile in
    if (get_owner prop = -1) then 
      ask_buy board prop player
    else 
      if (get_owner prop = get_player_id player) then
        Print.print_property_already_owned ()
      else
        pay_rent state prop player (get_owner prop)

  and ask_buy board property player = 
        Print.print_purchase_property_prompt property;
        match read_line () with 
        | exception End_of_file -> failwith "Unknown"
        | response when String.equal response "yes"-> 
          acquire property player board
        | response when String.equal response "no" -> ()
        | _ -> Print.print_incorrect_response (); ask_buy board property player
  
  and acquire property player board = 
          (* TODO: 
             1) Check if player has enough balance
                yes -> acquire, print deduction, and current balance
                no -> print not enough money *)
        let prop_cost = get_prop_cost property in
        if (get_player_balance player >= prop_cost) 
          then
            begin
            deduct_balance player prop_cost;
            add_to_properties player property;
            set_owner property (get_player_id player);
            Print.print_property_acquisition player;
            end
         else 
          Print.print_insufficient_balance ();
  and pay_rent state property player owner_id = 
      let owner = get_cur_player state owner_id in 
      let owner_name = get_player_name owner in 
      let payer_name = get_player_name player in
      let rent = get_prop_rent property in 
      deduct_balance player rent;
      deduct_balance owner (rent * (-1));
      print_string (payer_name^ " paid " 
      ^ string_of_int rent ^ "to " ^ owner_name^ "\n");
      print_string (" " ^ payer_name ^ "'s balance is $" ^ 
      string_of_int (get_player_balance player));
      ignore(print_endline);
      print_string (" " ^ owner_name ^ "'s balance is $" ^ 
      string_of_int (get_player_balance owner))

        
let main () =  
  (** TODO: 
      1) Parse board from json 
      2) Print welcoming message
      3) Print instructions 
      4) Initialize player
      5) Intialize state 0
      6) Start game cycle * (recursive) *)

      let board =
        "data/baby2.json" |> Yojson.Basic.from_file |> Board.parse
      in
      Print.print_welcome ();
      Print.print_instructions (); 
      let players = players_init 2 in
      let state0 = State.state0_init players board in
      game_cycle state0 board

      

let () = main ()
