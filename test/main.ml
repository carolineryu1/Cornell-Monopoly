open OUnit
open Game
open Die
open Command
open Board
open Player
open State

(** Test Plan: We created our OUnit test suite as we were implementing
    our game, mainly focused on glass-box testing. This gave us the
    ability to test different functions and modules during our
    development of our text-based Monopoly game titled 'Cornellopy'.

    We first started testing our program by checking if the commands are
    parsed correctly—namely, if the user input is malformed, it produces
    “Wrong Command,” and correctly parses even if there are spaces in
    between.

    Due to the fact that some of the player attributes are mutable (i.e.
    balance, properties, location, in_duff, skip_turn_status, and
    is_bankrupt), we decided to create a new player to test each part.
    For many tests, we constructed an OUnit test that asserts the
    quality of the expected output with the input which in our case is
    the function that we want to test with desired input. Most of the
    player are tested by OUnit test suite using getter functions from
    our player.ml, as well as in state.ml to check if the initial state
    condition is what we expect and to see if they change as we proceed
    with the game.

    We made the assumption that the board was parsed correctly, as we
    first load that into our test file and run created player’s location
    based on the tile (player3 and player4, with arbitrarily set roll
    results).

    The remaining parts of the test were tested manually. We tested
    moving to all tiles on the board and tested whether or not heir
    functionalities were correct. We also tested how players were sent
    to duff after landing on the Go to Duff tile. We tested all chance
    cards to make sure they were functioning properly such as checking
    the balance after they won a chance card the rewards them with a
    certain amount, as well as bankruptcy. We were able to hold multiple
    rounds of the game with a couple of our friends to see if the
    functionalities are working correctly, such as by checking
    properties and balance after every turn.

    With every aspect of our functionalities covered (die roll, player
    attributes, board parsing, state changes, and working game) with
    manual and OUnit testing, we strongly believe our extensive testing
    approach demonstrates the correctness of our program. *)

let command_test (name : string) input expected_output : test =
  name >:: fun _ -> assert_equal expected_output input

let bool_test (name : string) (result : bool) (expected_output : bool) :
    test =
  name >:: fun _ -> assert (result = expected_output)

let int_test (name : string) (result : int) (expected_output : int) :
    test =
  name >:: fun _ -> assert (result = expected_output)

let string_test
    (name : string)
    (result : string)
    (expected_output : string) : test =
  name >:: fun _ -> assert (result = expected_output)

(* Command.ml *)

let parse_exception_test
    (name : string)
    (str : string)
    (expected_output : exn) : test =
  name >:: fun _ ->
  (*the [printer} tells OUnit how to convert the output to a string*)
  assert_raises expected_output (fun () -> Command.parse str)

let command_tests =
  [
    command_test "parse removes whitespace, parse roll"
      (Command.parse "    roll  ")
      Roll;
    command_test "parse quit" (Command.parse "  quit  ") Quit;
    command_test "parse properties"
      (Command.parse "properties")
      Properties;
    command_test "parse instructions"
      (Command.parse "instructions")
      Instructions;
    command_test "parse balance" (Command.parse "    balance  ") Balance;
    command_test "parse incorrect input" (Command.parse "dfdfd")
      WrongCommand;
    parse_exception_test "empty input" "" Empty;
    parse_exception_test "empty input white space" "   " Empty;
  ]

(* Board.ml *)

(** Loading the json file (baby2.json) to test *)
let baby2 = from_json (Yojson.Basic.from_file "./data/baby2.json")

let tiles = baby2.tiles

(**let board_tests = []*)

(* Die.ml *)

(** [roll_die_test name expected_output] constructs an OUnit test named
    [name] that prints a random integer in between 2 and 12. *)
let roll_die_test (name : string) (expected_output : bool) : test =
  name >:: fun _ ->
  assert_equal expected_output (roll_die () <= 12 && roll_die () >= 2)

let roll_die_tests = [ roll_die_test "first initial test" true ]

(* Player.ml *)

(* Creating 2 arbitrary characters *)

let player1 =
  create_new_player 1 "Carlos" (convert_to_symbol "umbrella")

let player2 = create_new_player 2 "Juan" (convert_to_symbol "square")
let state0_init_p1_p2 = state0_init [ (1, player1); (2, player2) ] baby2

(** [get_player_name_test name player expected_output] constructs an
    OUnit test named [name] that asserts the quality of
    [expected_output] with [get_player_name player]. *)

let get_player_name_test
    (name : string)
    (player : Player.t)
    (expected_output : player_name) : test =
  name >:: fun _ ->
  assert_equal expected_output (get_player_name player)

(** [get_player_id_test name player expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output] with
    [get_player_id player]. *)
let get_player_id_test
    (name : string)
    (player : Player.t)
    (expected_output : player_id) : test =
  name >:: fun _ -> assert_equal expected_output (get_player_id player)

(** [get_player_loc_test name player expected_output] constructs an
    OUnit test named [name] that asserts the quality of
    [expected_output] with [get_player_loc player]. *)
let get_player_loc_test
    (name : string)
    (player : Player.t)
    (expected_output : int) : test =
  name >:: fun _ ->
  assert_equal expected_output (get_player_loc player)
    ~printer:string_of_int

(** [get_player_balance_test name player expected_output] constructs an
    OUnit test named [name] that asserts the quality of
    [expected_output] with [get_player_balance player]. *)
let get_player_balance_test
    (name : string)
    (player : Player.t)
    (expected_output : int) : test =
  name >:: fun _ ->
  assert_equal expected_output
    (get_player_balance player)
    ~printer:string_of_int

(** [get_player_properties_test name player expected_output] constructs
    an OUnit test named [name] that asserts the quality of
    [expected_output] with [get_player_properties player]. *)
let get_player_properties_test
    (name : string)
    (player : Player.t)
    (expected_output : property list) : test =
  name >:: fun _ ->
  assert_equal expected_output (get_player_properties player)

(** [get_player_symbol_test name player expected_output] constructs an
    OUnit test named [name] that asserts the quality of
    [expected_output] with [get_player_symbol player]. *)
let get_player_symbol_test
    (name : string)
    (player : Player.t)
    (expected_output : symbol) : test =
  name >:: fun _ ->
  assert_equal expected_output (get_player_symbol player)

(** [state0_init_test name player board expected_output] constructs an
    OUnit test named [name] that asserts the quality of
    [expected_output] with [state0_init players board]. *)
let state0_init_test
    (name : string)
    (players : (player_id * Player.t) list)
    (board : Board.t)
    (expected_output : State.t) : test =
  name >:: fun _ ->
  assert_equal expected_output (state0_init players board)

(** [get_player_jail_status_test name player board expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with [is_player_in_duff player]. *)
let get_player_jail_status_test
    (name : string)
    (player : Player.t)
    (expected_output : bool) : test =
  name >:: fun _ ->
  assert_equal expected_output (is_player_in_duff player)

(** [get_player_skip_turn_status_test name player expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with [skip_turn_status player]. *)
let get_player_skip_turn_status_test
    (name : string)
    (player : Player.t)
    (expected_output : bool) : test =
  name >:: fun _ ->
  assert_equal expected_output (skip_turn_status player)

(** [test_set_owner name prop id expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output] with
    [prop.owner = id]. *)
let test_set_owner
    (name : string)
    (prop : property)
    (id : int)
    (expected_output : bool) : test =
  set_owner prop id;
  name >:: fun _ -> assert_equal expected_output (prop.owner = id)

(** [get_owner_test name prop expected_output] constructs an OUnit test
    named [name] that asserts the quality of [get_owner prop] with
    [prop.owner]. *)
let get_owner_test
    (name : string)
    (prop : property)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal (get_owner prop) prop.owner

(** [get_cost_test name prop expected_output] constructs an OUnit test
    named [name] that asserts the quality of [get_prop_cost prop] with
    [ prop.cost]. *)
let get_cost_test
    (name : string)
    (prop : property)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal (get_prop_cost prop) prop.cost

(** [get_rent_test name prop expected_output] constructs an OUnit test
    named [name] that asserts the quality of [get_rent_test prop] with
    [ List.hd prop.rent]. *)
let get_rent_test
    (name : string)
    (prop : property)
    (expected_output : bool) : test =
  name >:: fun _ ->
  assert_equal (get_prop_rent prop) (List.hd prop.rent)

(** [get_cur_turn_test name state expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output] with
    [get_cur_turn state]. *)
let get_cur_turn_test
    (name : string)
    (state : State.t)
    (expected_output : player_id) : test =
  name >:: fun _ -> assert_equal expected_output (get_cur_turn state)

(** [get_cur_player_test name state player_id expected_output]
    constructs an OUnit test named [name] that asserts the quality of
    [expected_output] with [et_cur_player state player_id]. *)
let get_cur_player_test
    (name : string)
    (state : State.t)
    (player_id : player_id)
    (expected_output : Player.t) : test =
  name >:: fun _ ->
  assert_equal expected_output (get_cur_player state player_id)

(** [switch_turn_test name state expected_output] constructs an OUnit
    test named [name] that asserts the quality of [expected_output] with
    [switch_turn_test state]. *)
let switch_turn_test
    (name : string)
    (state : State.t)
    (expected_output : State.t) : test =
  name >:: fun _ -> assert_equal expected_output (switch_turn state)

let state01_p1_p2 =
  State.manual_current_turn 2 [ (1, player1); (2, player2) ] baby2

let get_prop_name_test
    (name : string)
    (prop : property)
    (expected_output : bool) : test =
  name >:: fun _ ->
  assert_equal (Board.get_name prop = prop.name) expected_output

let get_prop_id_test
    (name : string)
    (prop : property)
    (expected_output : bool) : test =
  name >:: fun _ -> assert_equal (get_id prop = prop.id) expected_output

(* Suppose one turn has been made, and player1 has rolled a 5 and
   player2 rolled a 2 (arbitrarily set) *)

let (fake_prop : property) =
  {
    id = "property_id";
    name = "fake property";
    cost = 200;
    rent = [ 2 ];
    owner = 2;
  }

let (medium_expensive_property : property) =
  {
    id = "more_exp_property_id";
    name = "more expensive property";
    cost = 300;
    rent = [ 10 ];
    owner = -1;
  }

let (more_expensive_property : property) =
  {
    id = "more_exp_property_id";
    name = "more expensive property";
    cost = 500;
    rent = [ 20 ];
    owner = -1;
  }

let player_basic_tests =
  [
    get_player_name_test "player1's name" player1 "Carlos";
    get_player_name_test "player2's name" player2 "Juan";
    get_player_id_test "player1's id" player1 1;
    get_player_id_test "player2's id" player2 2;
    get_player_loc_test "player1's initial loc" player1 0;
    get_player_loc_test "player2's initial loc" player2 0;
    get_player_symbol_test "testing player1's symbol" player1
      (Player.convert_to_symbol "umbrella");
    get_player_symbol_test "testing player2's symbol" player2
      (Player.convert_to_symbol "square");
    get_player_balance_test "playerf1's initial balance" player1 1500;
    get_player_jail_status_test "player1's initial jail status" player1
      false;
    get_player_jail_status_test "player2's initial jail status" player2
      false;
    test_set_owner "changing a property's owner" fake_prop 1 true;
    get_owner_test "getter function for property owner" fake_prop true;
    get_cost_test "getter function for property cost" fake_prop true;
    get_rent_test "getter function for property rent" fake_prop true;
    get_player_properties_test "player1 has no properties" player1 [];
    get_player_properties_test "player2 has no properties" player2 [];
    get_cur_turn_test "getting the initial current turn"
      state0_init_p1_p2 1;
    get_cur_player_test "getting the intial current player"
      state0_init_p1_p2 1 player1;
    switch_turn_test "switching the turns" state01_p1_p2
      state0_init_p1_p2;
    get_prop_name_test "getter function for property name" fake_prop
      true;
    get_prop_id_test "getter function for property id" fake_prop true;
    bool_test "check if initiall bankrupt = false" false
      (is_bankrupt player1);
  ]

(** done with initial tests, now actual movement *)

(* player3 = owning one property*)
let player3 =
  create_new_player 1 "Player 3" (convert_to_symbol "triangle")

(* player4 = the other person having one property doesn't affect the
   partner, change jail status*)
let player4 =
  create_new_player 2 "Player 4" (convert_to_symbol "circle")

let player4_in_jail = change_jail_status player4
let p3_first_roll = update_player_loc player3 5 tiles
let p3_bought_prop = add_to_properties player3 fake_prop
let p3_paid_from_balance = deduct_balance player3 fake_prop.cost
let p4_first_roll = update_player_loc player4 2 tiles
let p4_change_skip_turn_status = change_skip_turn_status player4

let player_moving_tests =
  [
    get_player_loc_test
      "testing player3's location after first die roll" player3 5;
    get_player_loc_test
      "testing player4's location after first die roll" player4 2;
    get_player_properties_test
      "testing player3's property list after buying one property"
      player3 [ fake_prop ];
    get_player_balance_test
      "testing player3's deducted balance from the totla amount after \
       purchasing the property"
      player3 1300;
    get_player_jail_status_test "testing player1's initial jail status"
      player3 false;
    test_set_owner "changing a property's owner" fake_prop 1 true;
    get_player_jail_status_test "player4 now in jail" player4 true;
    get_player_skip_turn_status_test
      "player4 now in skipping turns, because the players is in jail"
      player4 true;
    get_player_jail_status_test
      "player4 going to jail has no effect on player3's jail status"
      player3 false;
    get_player_skip_turn_status_test
      "player4 going to jail has no effect on player3's skip turn \
       status"
      player3 false;
  ]

(* player 5 rolls two times, and that they add together *)

(* player 6 deducted balance, owning multiple properties *)
let player5 = create_new_player 1 "Player 5" (convert_to_symbol "dog")
let player6 = create_new_player 2 "Player 6" (convert_to_symbol "cat")
let p5_first_roll = update_player_loc player5 9 tiles
let p5_second_roll = update_player_loc player5 4 tiles

let p6_added_properties =
  add_to_properties player6 fake_prop;
  add_to_properties player6 medium_expensive_property;
  add_to_properties player6 more_expensive_property

let p6_deducted_balance =
  deduct_balance player6 fake_prop.cost;
  deduct_balance player6 medium_expensive_property.cost;
  deduct_balance player6 more_expensive_property.cost

let multiple_turns_tests =
  [
    get_player_loc_test "player5's final loc after 2 turns" player5 13;
    get_player_properties_test "player6 bought 3 new properties" player6
      [ more_expensive_property; medium_expensive_property; fake_prop ];
    get_player_balance_test "player6's balance after buying 3 proerties"
      player6 500;
  ]

(* player 7 manually inputed balance*)
let player7 =
  create_new_player 1 "Player 7" (convert_to_symbol "spider")

let manual_input_of_p7_balance =
  manual_input_of_player_balance player7 3000

let manual_changes_tests =
  [
    get_player_balance_test
      "Testing player7's balance after manually inputting the balance"
      player7 3000;
    get_player_properties_test
      "Testing whether manually changing the abalcne doesn't change \
       other attributes, such as location"
      player7 [];
  ]

let player8 = create_new_player 2 "Player 8" (convert_to_symbol "cat")
let player8_not_bankrupt = deduct_balance player8 800

let player9 =
  create_new_player 2 "Player 9" (convert_to_symbol "circle")

let player9_not_bankrupt = deduct_balance player9 (-800)

let player10 =
  create_new_player 1 "Player 10" (convert_to_symbol "triangle")

let player10_bankrupt = deduct_balance player10 2000

let deduct_bankrupt_tests =
  [
    bool_test "after deducting 800 from 1500, not bankrupt" false
      (is_bankrupt player8);
    bool_test "after deducting -800 from 1500, not bankrupt" false
      (is_bankrupt player9);
    bool_test "after deducting 2000 from 1500, bankrupt" true
      (is_bankrupt player10);
  ]

let suite =
  "test suite for Cornellopy"
  >::: List.flatten
         [
           command_tests;
           roll_die_tests;
           player_basic_tests;
           player_moving_tests;
           multiple_turns_tests;
           manual_changes_tests;
           deduct_bankrupt_tests;
         ]

let _ = run_test_tt_main suite
