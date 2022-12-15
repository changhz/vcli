module main

import os
import flag

fn main() {
  mut fprs := flag.new_flag_parser(os.args)
  fprs.application('vcli')
  fprs.version('0.0.1')
  fprs.description('Boilerplate for making V CLI tools')
  fprs.skip_executable()

  mut prjname := fprs.string('name', `n`, '', "Project Name").to_lower()

  if prjname == '' {
    prjname = get_input()
    if 'c' == prjname {
      return
    }
  }

  println("Nice, your project is called '$prjname' !")
}

fn get_input() string {
  for true {
    input_str := (os.input_opt('Please enter project name:\n') or { '' }).to_lower()
    
    if 'c' == input_str {
      return 'c'
    }

    if '' == input_str {
      println("Invalid name (enter 'c' to abort)")
      continue
    }

    return input_str
  }
  return 'c'
}