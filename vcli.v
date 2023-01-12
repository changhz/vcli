module main

import os
import flag

const abort_key = 'q'

fn main() {
  mut fprs := flag.new_flag_parser(os.args)
  fprs.application('vcli')
  fprs.version('0.0.1')
  fprs.description('Boilerplate for making V CLI tools')
  fprs.skip_executable()

  mut prjname := fprs.string('name', `n`, '', "Project Name").to_lower()
  mut version := fprs.string('version', `v`, '0.0.1', "Version")
  mut desc := fprs.string('desc', `d`, '', "Description")

  if prjname == '' {
    prjname = from_input('project name')
    if abort_key == prjname {
      return
    }
  }

  mut lines := ("
module main

import os
import flag

const abort_key = 'q'

fn main() {
  mut fprs := flag.new_flag_parser(os.args)
  fprs.application('$prjname')
  fprs.version('$version')
  fprs.description('$desc')
  fprs.skip_executable()

  mut p1 := fprs.string('strparam', `s`, 'default value', 'String Parameter').to_lower()
  mut p2 := fprs.int('intparam', `n`, 0, 'Integer Parameter')
}
  ")

	if os.exists(prjname) {
    println('Sorry, I Refuse to proceed: folder named "$prjname" exists already')
    return
  }
  os.mkdir(prjname)!
  os.write_file('$prjname/${prjname}.v', lines)!

  lines = ("
Module {
  name: '$prjname'
  description: '$desc'
  version: '$version'
  license: 'MIT'
  dependencies: []
}
  ")
  os.write_file('$prjname/v.mod', lines)!
  
  lines = ("
[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true

[*.v]
indent_style = space
indent_size = 4
  ")
  os.write_file('$prjname/.editorconfig', lines)!
  
  lines = ("
* text=auto eol=lf
*.bat eol=crlf

**/*.v linguist-language=V
**/*.vv linguist-language=V
**/*.vsh linguist-language=V
**/v.mod linguist-language=V
  ")
  os.write_file('$prjname/.gitattributes', lines)!
  
  lines = ("
# Binaries for programs and plugins
main
vcli
*.exe
*.exe~
*.so
*.dylib
*.dll

# Ignore binary output folders
bin/

# Ignore common editor/system specific metadata
.DS_Store
.idea/
.vscode/
*.iml
  ")
  os.write_file('$prjname/.gitignore', lines)!
  
  lines = '# $prjname'
  os.write_file('$prjname/README.md', lines)!
}

fn from_input(name string) string {
  for true {
    input_str := (os.input_opt('Please enter $name:\n') or { '' }).to_lower()
    
    if abort_key == input_str {
      return abort_key
    }

    if '' == input_str {
      println("Invalid input (enter '$abort_key' to abort)")
      continue
    }

    return input_str
  }
  return abort_key
}