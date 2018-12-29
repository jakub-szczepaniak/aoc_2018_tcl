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

proc has_successors { predecessor } {
	global successors
	return [dict exists $successors $predecessor]
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

proc reset_queue {} {
	processing clear
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

proc prepare_worker { name } {
	return [dict create id $name working_for 0 task {} done false]
}

proc is_busy { worker } {
	return [dict get $worker working_for] > 0
}

proc set_task { worker task} {
	dict set worker task $task
	dict set worker working_for [expr [scan $task "%c"] + 60 - 65]
	return $worker
}

proc next_second { worker } {
	dict incr worker working_for -1
	if { [dict get $worker working_for] == 0} {
		dict set worker done true
	} 
	return $worker
}
#-----------------

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
	if { ![has_successors $next_item]} {
		break
	}
	foreach successor [successors_for $next_item] {
			if {!($successor in $finished) && [all_in [predecessors_for $successor] $finished]} {
				queue_push $successor
		}
	}
	
}
puts  "Part 1: [join $finished {}]"
	
reset_queue

set part_2 [list]

foreach element [dict keys $successors] {
	if { [not_in [dict keys $predecessors] $element ]} {
		queue_push $element
	}
}
puts [queue_size]

set workers [list]

for {set x 0 } { $x < 5} { incr x} {
	lappend workers [prepare_worker $x]
}
puts $workers
set my_worker [prepare_worker 1]
set my_worker [set_task $my_worker "D"]
puts [expr [dict get $my_worker working_for] > 0]

puts [next_second $my_worker]
puts [next_second [next_second $my_worker]]

