module input

pub const abort_key = 'q'

pub fn from_input(name string) string {
	for {
		input_str := (os.input_opt('Please enter $name:\n') or { '' }).to_lower()
		
		if abort_key == input_str { return abort_key }

		if '' == input_str {
			println("Invalid input (enter '$abort_key' to abort)")
			continue
		}

		return input_str
	}
	return abort_key
}