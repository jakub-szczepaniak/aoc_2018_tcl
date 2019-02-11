source [file join [file dirname [info script]] ../utils utils.tcl]

proc sort_all_items { box_ids } {
	set result [list]
	foreach box_id $box_ids {
		lappend result [join [lsort [split $box_id ""]]]
	}
}
proc occurences { box_id } {
	set occurences [dict create]
	foreach letter [split $box_id ""] {
		dict incr occurences $letter 1 
		}
	return $occurences
}

proc has_double { box_id } {
	set box_occ_count [dict values [occurences $box_id] 2]
	return [expr [llength $box_occ_count] ne 0]
}

proc has_triple { box_id } {
	set box_occ_count [dict values [occurences $box_id] 3]
	return [expr [llength $box_occ_count] ne 0]
}

proc doubles { box_ids } {
	set count 0
	foreach box_id $box_ids {
		if {[has_double $box_id]} {
			incr count
		}
	}
	return $count
}
 proc triples { box_ids } {
 	set count 0
 	foreach box_id $box_ids {
 		if {[has_triple $box_id]} {
 			incr count
 		}
 	}
 	return $count
 }

proc string_to_list { input } {
	return [split $input ""]
}

proc levenhstein { input1 input2 } {
 	set distance 0
 	set count 0
 	set list1 [string_to_list $input1]
	set list2 [string_to_list $input2]

 	set input_length [llength $list1]
 	
 	while { $count < $input_length} {
 		if { [lindex $list1 $count] ne [lindex $list2 $count]} {
 		 		incr distance
 			}
 		incr count
 	}
 	return $distance
}

proc strip_difference { input1 input2} {
	set list1 [string_to_list $input1]
	set list2 [string_to_list $input2]
	set diff_index -1
	set counter 0
	while { $counter < [llength $list1]} {
		if {[lindex $list1 $counter] ne [lindex $list2 $counter]} {
 		 		set diff_index $counter
 			}
 		incr counter
	} 
	return $diff_index
}


set puzzle [load_input "[file dirname [info script]]/input.txt"]

set parsed [parse_input $puzzle]

set checksum [expr [doubles $parsed]*[triples $parsed]]
puts $checksum


set mapping_distances [dict create]

foreach input1 $parsed {
	foreach input2 $parsed {
		set distance [levenhstein $input1 $input2]
		if { $distance eq 1} {
			puts "$input1:$input2"
			puts [strip_difference $input1 $input2]
		}
	}
}




#puts $sorted 
