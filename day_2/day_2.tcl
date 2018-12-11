source [file join [file dirname [info script]] ../utils utils.tcl]

proc sort_all_items { box_ids } {
	set result [list]
	foreach box_id $box_ids {
		lappend result [join [lsort [split $box_id ""]]]
	}
}

proc has_double { box_id } {
	set box_occ_count [dict values [occurences $box_id] 2]
	return [expr [llength $box_occ_count] ne 0]
}

proc has_triple { box_id } {
	set box_occ_count [dict values [occurences $box_id] 3]
	return [expr [llength $box_occ_count] ne 0]
}

set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]

set sorted [sort_all_items $parsed]

proc occurences { box_id } {
	set occurences [dict create]
	foreach letter [split $box_id ""] {
		dict incr occurences $letter 1 
		}
	return $occurences
}

#puts $sorted 
