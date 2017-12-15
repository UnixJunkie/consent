
(* extract SDF molecules with given names *)

open Printf

module Ht = Hashtbl
module StringSet = BatSet.String

let main () =
  Log.set_log_level Log.INFO;
  Log.color_on ();
  (* options *)
  let argc, args = CLI.init () in
  if argc = 1 then
    (eprintf "usage:\n\
              %s -i molecules.sdf [-p] \
              {-names \"mol1,mol2,mol10\"|-n names_file}\n\
              -i <file.sdf>: where to read molecules from\n\
              -names name1,name2,name3: name of molecules to get\n\
              -n <names_file>: names of molecules to get, one per line\n\
              -p: preserve (names) order when writting molecules out\n"
       Sys.argv.(0);
     exit 1);
  let input_fn = CLI.get_string ["-i"] args in
  let names = match CLI.get_string_opt ["-names"] args with
    | None -> ""
    | Some ns -> ns in
  let names_fn = match CLI.get_string_opt ["-n"] args with
    | None -> ""
    | Some fn -> fn in
  let preserve_order = CLI.get_set_bool ["-p"] args in
  let selected_names =
    (* -names and -n are incompatible but one is mandatory *)
    assert(names <> "" || names_fn <> "");
    assert(names = "" || names_fn = "");
    if names <> "" then
      BatString.nsplit ~by:"," names
    else if names_fn <> "" then
      MyUtils.lines_of_file names_fn
    else
      assert(false) in
  let name2rank =
    let res = Ht.create 11 in
    List.iteri (fun i name ->
        assert(not (Ht.mem res name));
        Ht.add res name i
      ) selected_names;
    res in
  let nb_names = Ht.length name2rank in
  let rank2mol = Ht.create nb_names in
  let ok_names = StringSet.of_list selected_names in
  let count = ref 0 in
  MyUtils.with_in_file input_fn (fun input ->
      try
        while true do
          let m = Sdf.read_one input in
          let name, _rest = BatString.split m ~by:"\n" in
          if StringSet.mem name ok_names then
            (if preserve_order then
               let rank = Ht.find name2rank name in
               Ht.add rank2mol rank m
             else
               Printf.printf "%s" m;
             incr count)
        done
      with End_of_file ->
        (if preserve_order then
           for rank = 0 to nb_names - 1; do
             Printf.printf "%s" (Ht.find rank2mol rank)
           done;
         Printf.eprintf "found %d\n" !count)
    )

let () = main ()
