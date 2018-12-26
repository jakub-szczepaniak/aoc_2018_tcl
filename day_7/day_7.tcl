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

set puzzle_input [parse_input [load_input "input.txt"]]

set pred_2_succ [dict create]
set succ_2_pred [dict create]

set steps [list]
foreach step $puzzle_input {
	scan $step "Step %s must be finished before step %s" pred succ
	dict lappend pred_2_succ $pred $succ
	dict lappend succ_2_pred $succ $pred
} 

puts [dict keys $pred_2_succ]
puts [dict keys $succ_2_pred]

::struct::prioqueue -ascii processing

foreach element [dict keys $pred_2_succ] {
	if { [not_in [dict keys $succ_2_pred] $element ]} {
		processing put $element $element
	}
}

puts [processing size] 
puts [processing peek]
set finished [list]

while { [processing size]} {
	set next_item [processing get]
	puts $next_item
	lappend finished $next_item
	set successors [dict get $pred_2_succ $next_item]
	puts "successors for $next_item : $successors"
	foreach successor $successors {
		set preds [dict get $succ_2_pred $successor]
		puts "predecessor for $successor: $preds"
		if { [not_in $finished $successor] && [all_in $preds $finished] } {
			puts "adding $successor"
			processing put $successor $successor
		} 
	}
}
puts $finished
	

