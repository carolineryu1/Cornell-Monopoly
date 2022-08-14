open Yojson.Basic.Util
open Board

exception NoTile

let roll_die () =
  Random.self_init ();
  2 + Random.int 11