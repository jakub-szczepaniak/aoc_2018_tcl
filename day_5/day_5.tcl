source [file join [file dirname [info script]] ../utils utils.tcl]


proc react { polymer } {
	set result [list]
	for { set x 0} { $x < [llength polymer]-1} {incr x} {
		set current [lindex $polymer $0]
		set next [lindex $polymer [expr $0 + 1]]
		if {[lindex $polymer $0]} { 
			lappend result $current
			lappend result $next
		}
	}
	return $result
}

proc can_react { elem1 elem2} {
	if {$elem1 == $elem2} { return false}
}

set puzzle_input [load_input "input.txt"]

#set as_list [split $puzzle_input ""]

set as_list [list d a b A c C a C B A c C c a D A]

puts $as_list

set output [list]
# while { [llength $output] != [llength $as_list]} {
#  	set output [react $as_list]
#  	puts [llength $output]
# }

puts [llength $output]

