source [file join [file dirname [info script]] ../utils utils.tcl]

proc sort_all_items { box_ids } {
	set result [list]
	foreach box_id $box_ids {
		lappend result [join [lsort [split $box_id ""]]]
	}
	puts $result
}

proc has_double { sorted } {
	return [expr [regexp -all "(?!:)(\w)\1" sorted] eq 2]
}

set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]

set sorted [sort_all_items $parsed]

puts $sorted 
