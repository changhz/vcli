module restr

import regex {regex_opt}

pub type String = string

const ermsg = "restr.v failed fcall: regex_opt"

pub fn (s String) matches(pattern string) bool {
	mut re := regex_opt(pattern) or {panic(ermsg)}
	return re.matches_string(s)
}

pub fn (s String) find(pattern string) (int, int) {
	mut re := regex_opt(pattern) or {panic(ermsg)}
	return re.find(s)
}

pub fn (s String) find_all(pattern string) []string {
	mut re := regex_opt(pattern) or {panic(ermsg)}
	return re.find_all_str(s)
}

pub fn (s String) replace(pattern string, txt string) String {
	mut re := regex_opt(pattern) or {panic(ermsg)}
	return String(re.replace(s, txt))
}