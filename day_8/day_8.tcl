source [file join [file dirname [info script]] ../utils utils.tcl]
package require struct

proc prepare_input {} {
	set puzzle_input [split [load_input "input.txt"] " "]
	set parsed [flatten $puzzle_input]
}

::struct::stack processing

proc process_data { data } {
	set data [lassign $data child_count meta_count]
	puts "Child: $child_count"
	puts "Meta count: $meta_count"
	puts "rest : [llength $data]"
	if { $child_count==0} {
		for { set x 0} { $x < $meta_count} { incr x} {
			processing push [lindex $data $x]	
		}
		
	} 
}

# set puzzle_input [prepare_input]
# set puzzle_input [list 2 3 0 3 10 11 12 1 1 0 1 99 2 1 1 2]

# process_data $puzzle_input
# puts $puzzle_input

processing destroy