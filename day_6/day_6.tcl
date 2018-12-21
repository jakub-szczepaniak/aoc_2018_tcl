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

proc min_max_coordinates { coordinates } {
	set max_x 0
	set max_y 0
	set min_x 999
	set min_y 999
	foreach { x y } $coordinates {
		set min_x [ expr $x <= $min_x ? $x : $min_x]
		set min_y [ expr $y <= $min_y ? $y : $min_y]
		set max_x [ expr $x >= $max_x ? $x : $max_x]
		set max_y [ expr $y >= $max_y ? $y : $max_y]
	}
	return [list $min_x $min_y $max_x $max_y]
}

proc manhattan_dist { x1 y1 x2 y2 } {
	return [expr {abs($x2-$x1) + abs($y2-$y1)}]
}

set puzzle_input [load_input "input.txt"]

set coordinates [parse_coordinates $puzzle_input]

puts [min_max_coordinates $coordinates]


puts $coordinates


