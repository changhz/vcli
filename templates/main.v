module main

import os
import flag

const abort_key = ':q'

fn main() {
  fprs := flag.new_flag_parser(os.args)
  fprs.application('%prjname%')
  fprs.version('%version%')
  fprs.description('%desc%')
  fprs.skip_executable()

  p1 := fprs.string('strparam', `s`, 'default value', 'String Parameter')
    .to_lower()
  p2 := fprs.int('intparam', `n`, 0, 'Integer Parameter')

  additional_args := fprs.finalize() or {
    eprintln(err)
    println(fprs.usage())
    return
  }

  println(additional_args.join_lines())
  println(fprs.usage())
}