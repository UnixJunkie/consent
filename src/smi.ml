
(* read one molecule from a SMILES file *)
let read_one (input: in_channel): string =
  (input_line input) ^ "\n"

let get_name smiles_line =
  let _smiles, name = BatString.split smiles_line ~by:"\t" in
  name
