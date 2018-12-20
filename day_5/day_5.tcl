source [file join [file dirname [info script]] ../utils utils.tcl]


proc react { polymer } {
	set result $polymer
	for { set x 0} { $x < [llength $polymer]-1} {incr x} {
		set current [lindex $polymer $x]
		set next [lindex $polymer [expr $x + 1]]
		if {[can_react $current $next]} { 
			set result [lreplace $polymer $x [expr $x + 1]]
		}
	}
	return $result
}

proc can_react { elem1 elem2} {
	if {$elem1 == $elem2} { return false}
	if {([string toupper $elem1] == $elem2) || ($elem1 == [string toupper $elem2])} { return true }
	return false
}

set puzzle_input [load_input "input.txt"]

set as_list [split $puzzle_input ""]

set as_list [list d a b A c C a C B A c C c a D A]

#puts $as_list

set output [list]
 while { [llength $output] != [llength $as_list]} {
  	set output $as_list
  	set as_list [react $as_list]
  	puts "current legth [llength $output]"
 }

puts $output
puts [llength $output]

