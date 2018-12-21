source [file join [file dirname [info script]] ../utils utils.tcl]

proc parse_coordinates { file_content } {
	set lines [parse_input $file_content]
	set coordinates [list]
	foreach line $lines {
		scan $line {%d, %d} x y
		lappend coordinates $x $y
	}
	return $coordinates
}

set puzzle_input [load_input "input.txt"]

set coordinates [parse_coordinates $puzzle_input]

puts $coordinates


