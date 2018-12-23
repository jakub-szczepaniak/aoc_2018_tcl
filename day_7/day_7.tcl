source [file join [file dirname [info script]] ../utils utils.tcl]

package require struct


set puzzle_input [parse_input [load_input "input.txt"]]

set dependencies [ dict create ]
set steps [list]
foreach step $puzzle_input {
	scan $step "Step %s must be finished before step %s" pred succ
	dict lappend dependencies $pred $succ
	dict set dependencies $pred [lsort [dict get $dependencies $pred]]
	lappend steps $pred
	lappend steps $succ
} 

set steps [lsort -unique $steps]

puts $steps

dict for { pred succ } $dependencies {
	puts "$pred => $succ"
}

set finished [list]

::struct::stack processing

processing push [lindex $steps 0]
puts [processing peek]



