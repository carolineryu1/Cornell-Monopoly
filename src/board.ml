open Yojson.Basic.Util

(* defines types for board:*)

type property_id = string
type tile_id = string

type property = {
  id : property_id;
  name : string;
  cost : int;
  rent : int list;
  mutable owner : int;
}

type tile =
  | Property of property_id
  | Fine of int
  | Chance
  | Duff
  | GoToDuff

type t = {
  tiles : tile list;
  properties : property list;
}

let property_of_json (j : Yojson.Basic.t) =
  {
    id = j |> member "id" |> to_string;
    name = j |> member "name" |> to_string;
    cost = j |> member "cost" |> to_int;
    rent = j |> member "rent" |> to_list |> List.map to_int;
    owner = j |> member "owner" |> to_int;
  }

let tile_of_json (j : Yojson.Basic.t) =
  match j |> member "type" |> to_string with
  | "property" -> Property (j |> member "id" |> to_string)
  | "fine" -> Fine (j |> member "amount" |> to_int)
  | "duff" -> Duff
  | "go to duff" -> GoToDuff
  | _ -> failwith "tile_of_json error"

let from_json (j : Yojson.Basic.t) =
  {
    tiles = j |> member "tiles" |> to_list |> List.map tile_of_json;
    properties =
      j |> member "properties" |> to_list |> List.map property_of_json;
  }

let parse (j : Yojson.Basic.t) =
  try from_json j
  with Type_error (s, _) -> failwith ("Parsing error: " ^ s)

let tiles board = board.tiles

let get_prop_name (tile_id : tile_id) (board : t) : string =
  (List.find (fun (x : property) -> x.id = tile_id) board.properties)
    .name

let rec find tile tile_list acc =
  match tile_list with
  | [] -> failwith "empty"
  | h :: t -> if h = tile then acc else find tile t (acc + 1)

let return_tile_position (tile : tile) (tile_list : tile list) =
  find tile tile_list 0

let get_prop_from_tile board t =
  List.find (fun x -> String.equal t x.id) board.properties

let get_owner property = property.owner
let get_prop_cost property = property.cost
let set_owner property p_id = property.owner <- p_id
let get_prop_rent property = List.hd property.rent
let get_name property = property.name
let get_id property : property_id = property.id