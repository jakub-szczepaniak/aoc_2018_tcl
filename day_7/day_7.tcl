source [file join [file dirname [info script]] ../utils utils.tcl]

package require struct

proc all_in { list1 list2 } {
	set result true
	foreach elem $list1 {
		if { [lsearch -exact $list2 $elem]==-1} {
			set result false
		}
	}
	return $result
}

proc succesors_for { predecessor } {
	global successors
	return [dict get $successors $predecessor]
}

proc add_successor_for { predecessor successor} {
	global successors
	dict lappend successors $predecessor $successor
}

proc predecessors_for { successor } {
	global predecessors
	return [dict get $predecessors $successor]
}

proc add_predecessor_for { successor predecessor} {
	global predecessors
	dict lappend predecessors $successor $predecessor
}


set puzzle_input [parse_input [load_input "input.txt"]]

set successors [dict create]
set predecessors [dict create]

set steps [list]
foreach step $puzzle_input {
	scan $step "Step %s must be finished before step %s" pred succ
	add_successor_for $pred $succ
	add_predecessor_for $succ $pred
} 

puts [dict keys $successors]
puts [dict keys $predecessors]

::struct::prioqueue -ascii processing

foreach element [dict keys $predecessors] {
	if { [not_in [dict keys $successors] $element ]} {
		processing put $element $element
	}
}

puts [processing size] 
puts [processing peek]
set finished [list]

while { [processing size]} {
}
puts $finished
	

