module input

import os
import lib.restr {String}

pub const abort_key = ':q'

pub fn f64_input(prompt string) (f64, bool) {
	input_str := str_input(prompt)
	if input_str == abort_key { return 0, true }
	if String(input_str).matches(r'([0-9]+)(\.[0-9]+)?') { return input_str.f64(), false }

	println('Input must be a number')
	return f64_input(prompt)
}

pub fn str_input(prompt string) string {
	for {
		input_str := os.input('$prompt\n').trim(' ')
		
		if ['<EOF>', abort_key].contains(input_str)
			{ return abort_key }

		if '' == input_str {
			println("(press ctrl+d or enter '$abort_key' to abort)")
			continue
		}

		return input_str
	}
	return abort_key
}