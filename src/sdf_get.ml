
(* extract SDF molecules with given names *)

open Printf

let main () =
  Log.set_log_level Log.INFO;
  Log.set_output stderr;
  Log.color_on ();
  (* mandatory options *)
  let input_fn = ref "" in
  let names = ref "" in
  let usage_message =
    sprintf "usage:\n%s -i molecules.sdf -names \"mol1,mol2,mol10\"\n"
      Sys.argv.(0) in
  let argc = Array.length Sys.argv in
  if argc = 1 then
    let () = eprintf "%s" usage_message in
    let _ = exit 1 in
    () (* for typing *)
  else
    Arg.parse
      ["-i", Arg.Set_string input_fn,
       "<filename> where to read molecules from";
       "-names", Arg.Set_string names,
       "name1[,name2[,...]] which molecules to get"]
      (fun arg -> raise (Arg.Bad ("Bad argument: " ^ arg)))
      usage_message;
  let names = BatString.nsplit !names ~by:"," in
  let count = ref 0 in
  MyUtils.with_in_file !input_fn (fun input ->
      try
        while true do
          let m = Sdf.read_one input in
          if List.exists (fun name ->
              BatString.exists m name
            ) names then
            (Printf.printf "%s" m;
             incr count)
        done
      with End_of_file ->
        Printf.eprintf "found %d\n" !count
    )

let () = main ()
