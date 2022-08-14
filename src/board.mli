(** Representation of board data. This module represents the data stored
    in the board file including the tiles, properties, chance cards, and
    other unqiue tile types. It handles loading the data from a JSON as
    well as parsing the data. *)

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

val parse : Yojson.Basic.t -> t
(**[parse b] parses.*)

val from_json : Yojson.Basic.t -> t
(** [from_json j] is the board that [j] represents. Requires: [j] is a
    valid JSON board representation. *)

val tiles : t -> tile list
(**[tiles board] returns a list of the tiles from [board]*)

val get_prop_name : tile_id -> t -> string
(**[get_prop_name tile_id board] returns the name of the property on
   [tile_id] in [board]. *)

val return_tile_position : tile -> tile list -> int
(**[return_tile_position t t_lst] returns the position of the tile*)

val get_prop_from_tile : t -> tile_id -> property
(**[get_prop_from_tile board tile_id] returns the property on [tile_id]
   from [board].*)

val get_owner : property -> int
(**[get_owner property] returns the owner of [property].*)

val get_prop_cost : property -> int
(**[get_prop_cost property] returns the cost of [property] *)

val set_owner : property -> int -> unit
(**[set_owner property] sets the owner of [property].*)

val get_prop_rent : property -> int
(**[get_prop_rent property] returns the rent of [property] *)

val get_name : property -> string
(**[get_name prop] returns name of [prop]*)

val get_id : property -> property_id
(**[get_id property] returns the id of [property].*)
