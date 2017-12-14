(* replace name line in sdf file by name taken from corresponding line
   in another file *)

open Printf

let main () =
  Log.set_log_level Log.DEBUG;
  Log.color_on ();
  let argc, args = CLI.init () in
  if argc = 1 then
    (eprintf "usage:\n\
              %s -i input.sdf -o output.sdf -n names.txt\n"
       Sys.argv.(0);
     exit 1);
  (* options *)
  let input_fn = CLI.get_string ["-i"] args in
  let names_fn = CLI.get_string ["-n"] args in
  let output_fn = CLI.get_string ["-o"] args in
  let names = ref (MyUtils.lines_of_file names_fn) in
  let count = ref 0 in
  MyUtils.with_in_out_file input_fn output_fn (fun input output ->
      try
        while true do
          let line = input_line input in
          if line = "XXX" then (* the tag to replace *)
            let name = List.hd !names in
            names := List.tl !names;
            incr count;
            fprintf output "%s\n" name
          else
            fprintf output "%s\n" line
        done
      with End_of_file ->
        Log.info "read %d molecules" !count
    )

let () = main ()
