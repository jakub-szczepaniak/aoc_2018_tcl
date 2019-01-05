source [file join [file dirname [info script]] ../utils utils.tcl]

proc prepare_input {} {
	set puzzle_input [split [load_input "input.txt"] ""]

	set parsed [flatten $puzzle_input]

	set converted_to_int [list]
	foreach item $parsed {
		lappend converted_to_int [to_int $item]
	}
	return $converted_to_int
}
set puzzle_input [prepare_input]
puts $puzzle_input