
(* extract SDF molecules with given names *)

open Printf
open Lbvs_consent

module DB = Dokeysto_camltc.Db_camltc.RW

let db_name_of fn =
  fn ^ ".db"

type mol_name_provider = On_cli of string
                       | From_file of string

let main () =
  Log.set_log_level Log.INFO;
  Log.set_output stderr;
  Log.color_on ();
  let argc, args = CLI.init () in
  if argc = 1 then
    (eprintf "usage:\n\
              %s -i molecules.sdf \
              {-names \"mol1,mol2,...\"|-f names_file}\n"
       Sys.argv.(0);
     exit 1);
  let input_fn = CLI.get_string ["-i"] args in
  let names_provider =
    match CLI.get_string_opt ["-names"] args with
    | Some names -> On_cli names
    | None ->
      let fn = CLI.get_string ["-f"] args in
      From_file fn in
  (* is there a DB already? *)
  let db_fn = db_name_of input_fn in
  let db_exists, db =
    if Sys.file_exists db_fn then
      let () = Log.info "creating %s" db_fn in
      (true, DB.open_existing db_fn)
    else
      let () = Log.info "opening %s" db_fn in
      (false, DB.create db_fn) in
  let count = ref 0 in
  if not db_exists then
    MyUtils.with_in_file input_fn (fun input ->
        try
          while true do
            let m = Sdf.read_one input in
            let name = Sdf.get_fst_line m in
            DB.add db name m;
            incr count;
            if (!count mod 10_000) = 0 then
              eprintf "read %d\r%!" !count;
          done
        with End_of_file ->
          DB.sync db
      );
  let names = match names_provider with
    | On_cli names -> BatString.nsplit names ~by:","
    | From_file fn -> MyUtils.lines_of_file fn in
  List.iter (fun name ->
      try
        let m = DB.find db name in
        printf "%s" m
      with Not_found ->
        Log.warn "not found: %s" name
    ) names;
  DB.close db

let () = main ()
