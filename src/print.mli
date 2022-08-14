(**This module includes functions for printing messages the terminal for
   the players of Cornellopy to read. *)

val print_welcome : unit -> unit
(**[print_welcome ()] prints the welcome message to the terminal. *)

val print_instructions : unit -> unit
(**[print_instructions ()] prints the instructions of the game to the
   terminal.*)

val print_invalid_message : unit -> unit
(**[print_invalid_message ()] prints an invalid input message to the
   terminal when the input is invalid. *)

val print_enter_player_name : unit -> unit
(**[print_enter_player_name ()] prints the message to the terminal to
   prompt the user to enter their name. *)

val print_enter_symbol : unit -> unit
(**[print_enter_symbol ()] prints the message to the terminal to prompt
   the user to enter their symbol of choice. *)

val print_enter_new_symbol : unit -> unit
(**[print_enter_new_symbol ()] prompts the players to enter a new
   symbol.*)

val print_turn : string -> unit
(**[print_turn pl_name] prints to the terminal whose turn it is and
   prompts them to enter a command.*)

val print_roll_die : string -> unit
(**[print_roll_die s] prints s to the terminal, the number resulting
   from a die roll*)

val print_property_current_loc : string -> unit
(**[print_property_current_loc s] prints s to the terminal, the property
   at the current location.*)

val print_go_to_duff : unit -> unit
(**[print_go_to_duff ()] prints a go to jail message*)

val print_property_already_owned : unit -> unit
(**[print_property_already_owned ()] prints to the terminal the message
   stating that the property is already owned.*)

val print_purchase_property_prompt : Board.property -> unit
(**[print_purchase_property_prompt prop_cost] prints to the terminal the
   prompt asking if the player would like to purchase the property.]*)

val print_property_acquisition : Player.t -> unit
(**[print_property_acquisition p] prints to the terminal message
   alerting the player their property purchase was successful and
   displays their remaining balance.*)

val print_fine : int -> unit
(**[print_fine i] prints the fine amount to the terminal*)

val print_balance : Player.t -> unit
(**[print_balance p] prints the balance of the player to the terminal*)

val print_duff_message : unit -> unit
(**[print_duff_message ()] prints the message once a player is in jail.*)

val print_incorrect_response : unit -> unit
(**[print_incorrect_response ()] prints to the terminal that the player
   inputted an incorrect response when purchasing property.*)

val print_chance_card : unit -> unit
(**[print_chance card ()] prints the stated message when player lands on
   a chance card*)

val print_insufficient_balance : unit -> unit
(**[print_insufficient_balance ()] prints a message stating that the
   player has insufficient balance for action. *)
