source [file join [file dirname [info script]] ../utils utils.tcl]


proc parse_command { line } {
	switch -regexp -matchvar groups -- $line {
		"Guard #(\\d+?) begins shift" {
			return [list guard_id [lindex $groups 1]]
			set command [lindex $groups 1]
		}
		"\\[.+?:(\\d{2})\\] falls asleep" {
			return [list asleep [to_int [lindex $groups 1]]]
		}
		"\\[.+?:(\\d{2})\\] wakes up" {
			return [list awake [to_int [lindex $groups 1]]]	
		}
	}
}

set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]

set sorted [lsort $parsed]
save_output "sorted.txt" $sorted

set time_by_guard [dict create]

set current_guard_id 0
foreach log_entry $sorted {
	set command [parse_command $log_entry]
	set time_slept 0
	switch [lindex $command 0] {
		 "guard_id" {
			set current_guard_id [lindex $command 1]
		}
		"asleep" {
			set start_minute [lindex $command 1] 
		}
		"awake" {
			set end_minute [lindex $command 1]
			set time_slept [expr $end_minute - $start_minute]
			if {[dict exists time_by_guard $current_guard_id]} {
					set curr_time [dict get time_by_guard $current_guard_id]
					dict set time_by_guard $current_guard_id [expr $time_slept + $curr_time] 
				} else {
				dict set time_by_guard $current_guard_id $time_slept
			}
		}
	}
	
	}
puts [max_value_key $time_by_guard]

