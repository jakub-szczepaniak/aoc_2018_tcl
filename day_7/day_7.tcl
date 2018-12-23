source [file join [file dirname [info script]] ../utils utils.tcl]


set puzzle_input [parse_input [load_input "input.txt"]]

set steps [ dict create ]
foreach step $puzzle_input {
	scan $step "Step %s must be finished before step %s" pred succ
	dict lappend steps $pred $succ
	dict set steps $pred [lsort [dict get $steps $pred]]
} 


dict for { pred succ } $steps {
	puts "$pred => $succ"
}