source [file join [file dirname [info script]] ../utils utils.tcl]

proc sort_all_items { box_ids } {
	set result [list]
	foreach box_id $box_ids {
		lappend result [join [lsort [split $box_id ""]]]
	}
}

proc has_double { box_id } {
	return [expr [regexp -all (.)\\1 $box_id] eq 1]
}

proc has_triple { box_id } {
 	return 0
}

set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]

set sorted [sort_all_items $parsed]

#puts $sorted 
