import os
import flag
import lib.restr {String}
import lib.input {str_input}

fn main() {
	mut fprs := flag.new_flag_parser(os.args)
	fprs.application('vcli')
	fprs.version('0.1.0')
	fprs.description('V CLI tool starter')
	fprs.skip_executable()

	mut prjname := fprs.string('name', `n`, '', "Project Name").to_lower()
	version := fprs.string('version', `v`, '0.0.1', "Version")
	desc := fprs.string('desc', `d`, '', "Description")

	additional_args := fprs.finalize()!

	if additional_args.len > 0 {
		println('Unprocessed arguments:\n$additional_args.join_lines()')
	}

	if prjname == '' {
		prjname = str_input('Please enter project name:')
		if input.abort_key == prjname { return }
	}

	os.execute('rm -r dist/*')

	root := 'dist/$prjname'
	os.mkdir(root)!

	vmap := {
		'prjname': prjname
		'version': version
		'desc': desc
	}

	mut text := load_template('main.v', vmap)
	os.write_file('$root/${prjname}.v', text)!

	text = load_template('v.mod', vmap)
	os.write_file('$root/v.mod', text)!

	text = load_template('.gitignore', vmap)
	os.write_file('$root/.gitignore', text)!

	os.execute('cp .editorconfig $root/.editorconfig')
	os.execute('cp .gitattributes $root/.gitattributes')
	os.execute('cp -r lib $root/')
	
	text = '# $prjname\n$desc'
	os.write_file('$root/README.md', text)!
}

fn load_template(file string, vmap map[string]string) string {
	mut text := os.read_file('templates/$file') or {
		panic('failed to read file $file')
	}

	for k in ['prjname', 'version', 'desc'] {
		text = String(text).replace('%$k%', vmap[k])
	}
	return text
}