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
	set result [reactor peek [reactor size]] 
	reactor destroy
	return $result
}

set puzzle_input [load_input "[file dirname [info script]]/input.txt"]

set as_list [split $puzzle_input ""]

set part_1 [resolve_reaction $as_list]

puts "part 1: [llength $part_1]"
# ======
set part_2_input [join $part_1 ""]

set alphabet [list a b c d e f g h i j k l m n o p r q s t u v x y z]
set minimum [llength $part_1]

foreach letter $alphabet {
	set regex "(?i)($letter)"
	set without_one [regsub -all -- $regex $part_2_input ""]
	set without_one [split $without_one ""]
	set current [llength [resolve_reaction $without_one]] 
	if { $current <= $minimum } {
		set minimum $current
	}
}

puts "part 2: $minimum"

