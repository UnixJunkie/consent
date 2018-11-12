
(* read one molecule from a SMILES file *)
let read_one (input: in_channel): string =
  input_line input

let get_name mol_lines =
  let _miles, name = S.split mol_lines ~by:"\t" in
  name
