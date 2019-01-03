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
	return [dict create id $name working_for -1 task {} done false]
}

proc is_busy { worker } {
	return [dict get $worker working_for] > 0
}

proc set_task { worker task} {
	dict set worker task $task
	dict set worker working_for [expr [scan $task "%c"] + 60 - 65]
	dict set worker done false
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

set workers [list]

for {set x 0 } { $x < 5} { incr x} {
	lappend workers [prepare_worker $x]
}

set seconds 0

while {[llength $part_2] != 26} {

	set available_workers [list]
	foreach worker $workers {
		if {![dict get $worker done] } {
			lappend available_workers $worker
		}
	}
	foreach worker $available_workers {
			if {[queue_size]} {
				set next_item [queue_pop]
				set new_worker [set_task $worker $next_item]  
				set workers [lreplace $workers [dict get $worker id] [dict get $worker id] $new_worker]
			  puts $workers
		}
	}
	foreach worker $workers {
		puts "worker before $worker"
		set new_worker [next_second $worker]
		puts "second $seconds, worker : $new_worker"
		if { [dict get $new_worker done] } {
			puts "worker is done"
			set task [dict get $new_worker task]
			lappend part_2 $task
			if {![has_successors $task]} {
				break
			}
			foreach successor [successors_for $task] {
				if {!($successor in $part_2) && [all_in [predecessors_for $successor] $part_2]} {
					puts "Pushing $successor"
					queue_push $successor
				}
			}
		}
			set workers [lreplace $workers [dict get $worker id] [dict get $worker id] $new_worker]
	}
	incr seconds
	#break
}
puts $seconds
puts $part_2
