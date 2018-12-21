source [file join [file dirname [info script]] ../utils utils.tcl]
package require struct

proc can_react { elem1 elem2} {
	if {$elem1 == $elem2} { return false}
	if {([string toupper $elem1] == $elem2) || ($elem1 == [string toupper $elem2])} { return true }
	return false
}

proc resolve_reaction { elements } {
	::struct::stack reactor

	foreach element $elements {
		if {[reactor size] == 0 } {
			reactor push $element
			continue
		}
		set existing [reactor peek]
		if { [can_react $existing $element]} {
			reactor pop
		} else {
			reactor push $element
		}
	}
	return [reactor peek [reactor size]]
}

set puzzle_input [load_input "input.txt"]

set as_list [split $puzzle_input ""]

set result [resolve_reaction $as_list]

puts [llength $result]

