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

proc successors_for { predecessor } {
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

proc prepare_queue {} { 
	::struct::prioqueue -ascii processing
}

proc queue_push { element } {
	processing put $element $element
}

proc queue_pop {} {
	return [processing get] 
}

proc queue_size {} {
	return [processing size]
}

proc queue_peek {} {
	return [processing peek]
}

proc destroy_queue {} {
	processing destroy
}

set puzzle_input [parse_input [load_input "input.txt"]]

set successors [dict create]

set predecessors [dict create]

foreach step $puzzle_input {
	scan $step "Step %s must be finished before step %s" pred succ
	add_successor_for $pred $succ
	add_predecessor_for $succ $pred
} 


prepare_queue

foreach element [dict keys $successors] {
	if { [not_in [dict keys $predecessors] $element ]} {
		queue_push $element
	}
}

set finished [list]

while {[queue_size]} {
	set next_item [queue_pop]
	lappend finished $next_item
	if { ![dict exists $successors $next_item]} {
		break
	}
	foreach successor [successors_for $next_item] {
		if {[dict exists $predecessors $successor]} {
			set current_pred [predecessors_for $successor]
			if { !($successor in $finished) && [all_in $current_pred $finished]} {
				queue_push $successor
			}
		}
	}
	
}
puts  "Part 1: [join $finished {}]"
	

