module main

import os
import flag
import regex {regex_opt}
import input {from_input, abort_key}

fn main() {
	mut fprs := flag.new_flag_parser(os.args)
	fprs.application('vcli')
	fprs.version('0.0.1')
	fprs.description('V CLI tool starter')
	fprs.skip_executable()

	mut prjname := fprs.string('name', `n`, '', "Project Name").to_lower()
	version := fprs.string('version', `v`, '0.0.3', "Version")
	desc := fprs.string('desc', `d`, '', "Description")

	additional_args := fprs.finalize()!

	if additional_args.len > 0 {
		println('Unprocessed arguments:\n$additional_args.join_lines()')
	}

	if prjname == '' {
		prjname = from_input('project name')
		if abort_key == prjname { return }
	}

	os.execute('rm -r dist/*')

	root := 'dist/$prjname'
	os.mkdir(root)!

	vmap := {
		'prjname': prjname
		'version': version
		'desc': desc
	}

	mut lines := load_template('main.v', vmap)
	os.write_file('$root/${prjname}.v', lines)!

	lines = load_template('v.mod', vmap)
	os.write_file('$root/v.mod', lines)!

	os.execute('cp .editorconfig $root/.editorconfig')
	os.execute('cp .gitattributes $root/.gitattributes')
	os.execute('cp .gitignore $root/.gitignore')
	os.execute('cp -r lib $root/')
	
	lines = '# $prjname\n$desc'
	os.write_file('$root/README.md', lines)!
}

fn load_template(file string, vmap map[string]string) string {
	mut lines := os.read_file('templates/$file') or {
		panic('failed to read file $file')
	}

	mut re := regex.RE{}
	for k in ['prjname', 'version', 'desc'] {
		re = regex_opt('%$k%') or { panic('this is so wrong') }
		lines = re.replace(lines, vmap[k])
	}
	return lines
}