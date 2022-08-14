(* Messages *)
open Player

let welcome_message = "Welcome to Cornellopy!\n"
let roll_message = "To roll the dice, enter roll! \n"

let balance_message =
  "To check the balance in your account, enter balance! \n"

let property_message =
  "To check the properties in your account, enter properties! \n"

let invalid_message =
  "Your input is invalid. Please enter a valid command: "

let enter_player_name_message = "Enter player's name: \n"

let enter_symbol_message =
  "Enter your symbol: umbrella, circle, triangle, square, dog, cat, \
   fish, or spider. \n"

let enter_new_symbol_message = "Invalid symbol. Try again. \n"

let go_to_duff_message =
  " You are behind on your studying. Go to Duff, and skip a turn! \n"

let property_already_owned_message = "You already own this property \n"

(* Print Functions *)

let print_welcome () =
  ANSITerminal.(
    print_string [ green ] welcome_message;
    print_string [ blue ]
      "This is a Cornell themed text-based Monopoly game.  \n";
    print_string [ blue ]
      "created for CS3110 at Cornell University by Kyra Watts, \n";
    print_string [ blue ]
      "Artem Ezhov, Caroline Ryu, and Christopher Chan. \n";
    print_string [ blue ] "We have properties that are \n";
    print_string [ blue ]
      "named after some of our favorite locations on campus, \n";

    print_string [ blue ]
      "a jail named after Duffield Hall, every engineer's second home, \n";

    print_string [ blue ]
      "chance cards which have different functions, and fines for \n";

    print_string [ blue ] "when you are behind on your studying. \n";

    print_string [ green ] "Thank you for trying out our game! \n";

    print_string [ green ] "Have fun! \n")

let print_instructions () =
  ANSITerminal.(
    print_string [ white ] "Here are the instructions of the game: \n";
    print_string [ yellow ] roll_message;
    print_string [ cyan ] balance_message;
    print_string [ blue ] property_message)

let print_invalid_message () =
  ANSITerminal.(print_string [ red ] invalid_message)

let print_enter_player_name () =
  ANSITerminal.(print_string [ magenta ] enter_player_name_message)

let print_enter_symbol () =
  ANSITerminal.(print_string [ cyan ] enter_symbol_message)

let print_enter_new_symbol () =
  ANSITerminal.(print_string [ red ] enter_new_symbol_message)

let print_turn pl_name =
  ANSITerminal.(
    print_string [ green ] "It's ";
    print_string [ magenta ] pl_name;
    print_string [ magenta ] "'s";
    print_string [ green ] " turn. ";
    print_string [ red ] "What would you like to do next?";
    print_string [ green ] " Enter command: ")

let print_roll_die die_result =
  ANSITerminal.(
    print_string [ green ] "You rolled a ";
    print_string [ yellow ] die_result;
    print_string [ green ] ".")

let print_property_current_loc prop_current_loc =
  ANSITerminal.(
    print_string [ green ] " You landed on ";
    print_string [ blue ] prop_current_loc;
    print_string [ blue ] ". ")

let print_go_to_duff () =
  ANSITerminal.(print_string [ red ] go_to_duff_message)

let print_property_already_owned () =
  ANSITerminal.(print_string [ red ] property_already_owned_message)

let print_purchase_property_prompt prop =
  ANSITerminal.(
    print_string [ magenta ] (string_of_int (Board.get_prop_cost prop));
    print_string [ green ] "Would you like to purchase this property? (";
    print_string [ green ] "yes";
    print_string [ blue ] "  ";
    print_string [ red ] "no";
    print_string [ green ] ")")

let print_property_acquisition player =
  ANSITerminal.(
    print_string [ blue ]
      "You acquired the property. Remaining balance is: ";
    print_string [ red ]
      (string_of_int (get_player_balance player) ^ "\n"))

let print_fine fine_amt =
  ANSITerminal.(
    print_string [ cyan ] "You are being fined! $";
    print_string [ red ] (string_of_int fine_amt);
    print_string [ cyan ] " has been deducted from your balance")

let print_balance player =
  ANSITerminal.(
    print_string [ yellow ] "Your balance is: ";
    print_string [ cyan ] "$";
    print_string [ cyan ]
      (string_of_int (Player.get_player_balance player));
    print_string [ cyan ] ". ")

let print_duff_message () =
  ANSITerminal.(print_string [ red ] "You're visiting jail.")

let print_incorrect_response () =
  ANSITerminal.(print_string [ red ] "Incorrect response. Try again.")

let print_chance_card () =
  ANSITerminal.(print_string [ cyan ] "You landed on a chance card!")

let print_insufficient_balance () =
  ANSITerminal.(
    print_string [ red ]
      "Insufficient balance to purchase the property.")
