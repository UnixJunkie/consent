(* extract molecules with given names from a MOL2 or SDF file *)

open Printf
open Lbvs_consent

module CLI = Minicli.CLI
module DB = Dokeysto_camltc.Db_camltc.RW

let db_name_of fn =
  fn ^ ".db"

type mol_name_provider = On_cli of string
                       | From_file of string

let mol_reader_for_file fn =
  match Filename.extension fn with
  | ".mol2" -> (Mol2.read_one_raw, Mol2.get_name)
  | ".sdf" -> (Sdf.read_one, Sdf.get_fst_line)
  | ".smi" -> (Smi.read_one, Smi.get_name)
  | ext -> failwith ("Sdf_get: not mol2 or sdf: " ^ fn)

let main () =
  Log.set_log_level Log.INFO;
  Log.set_output stderr;
  Log.color_on ();
  let argc, args = CLI.init () in
  if argc = 1 then
    (eprintf "usage:\n\
              %s -i molecules.{sdf|mol2|smi} \
              {-names \"mol1,mol2,...\"|-f names_file}\n"
       Sys.argv.(0);
     exit 1);
  let input_fn = CLI.get_string ["-i"] args in
  let read_one_mol, read_mol_name = mol_reader_for_file input_fn in
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
            let m = read_one_mol input in
            let name = read_mol_name m in
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
