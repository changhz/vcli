import os
import flag
import lib.input {str_input, f64_input}

fn main() {
	mut fprs := flag.new_flag_parser(os.args)
	fprs.application('%prjname%')
	fprs.version('%version%')
	fprs.description('%desc%')
	fprs.skip_executable()

	reserve := fprs.bool('reserve', `r`, false, 'Reserve a table')

	mut name := fprs.string('name', `n`, '', 'Your name')
	mut nguests := fprs.int('nguests', `a`, -1, 'Number of guests')

	additional_args := fprs.finalize() or {
		eprintln(err)
		println(fprs.usage())
		return
	}

	if reserve {
		println('Table reservation service.')

		if name == '' {
			name = str_input("What's your name?")
		}

		if nguests == -1 {
			num, abort := f64_input("How many are you?")
			if abort { return }
			nguests = int(num)
		}

		if name == input.abort_key {
			println('You chose not to tell us your name.')
		} else {
			println('Your name is $name and')
		}

		println('you are $nguests.str() persons')
		println('A table has been reserved for you, thank you.')
		return
	}

	println(additional_args.join_lines())
	println(fprs.usage())
}