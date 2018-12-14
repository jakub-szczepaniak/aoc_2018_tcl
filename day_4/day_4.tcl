source [file join [file dirname [info script]] ../utils utils.tcl]


set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]

set sorted [lsort $parsed]
set entries_by_guard [dict create]
foreach log_entry $sorted {
	puts $log_entry
	switch -regexp -matchvar groups -- $log_entry {
		"Guard #(\\d+?) begins shift" { puts [lindex $groups 1] }
		"\\[.+?:(\\d{2})\\] wakes up" { puts [lindex $groups 1]}
		"\\[.+?:(\\d{2})\\] falls asleep" { puts [lindex $groups 1]}
		default { puts "Parsing didnt match"}				
		}
	} 
