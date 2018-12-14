source [file join [file dirname [info script]] ../utils utils.tcl]


set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]

set sorted [lsort $parsed]
save_output "sorted.txt" $sorted

set entries_by_guard [dict create]
set current_guard_id 0
foreach log_entry $sorted {
	puts $log_entry
	switch -regexp -matchvar groups -- $log_entry {
		"Guard #(\\d+?) begins shift" { 
			set current_guard_id [lindex $groups 1]
			if {[dict exists $entries_by_guard $current_guard_id]} {
				continue
			}
			dict append entries_by_guard $current_guard_id [list] 
			 }
		"\\[.+?:(\\d{2})\\] wakes up" { 
			dict lappend entries_by_guard $current_guard_id [list 1 [lindex $groups 1]]
		}
		"\\[.+?:(\\d{2})\\] falls asleep" { 
			dict lappend entries_by_guard $current_guard_id [list 0 [lindex $groups 1]]
			}
		default { puts "Parsing didnt match"}				
		}
	}
	puts $entries_by_guard

