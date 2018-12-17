source [file join [file dirname [info script]] ../utils utils.tcl]


set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]

set sorted [lsort $parsed]
save_output "sorted.txt" $sorted

set entries_by_guard [dict create]
set current_guard_id 0
foreach log_entry $sorted {
	switch -regexp -matchvar groups -- $log_entry {
		"Guard #(\\d+?) begins shift" { 
			set current_guard_id [lindex $groups 1]
			if {[dict exists $entries_by_guard $current_guard_id]} {
				continue
			}
			dict append entries_by_guard $current_guard_id [list] 
			 }
		"\\[.+?:(\\d{2})\\] wakes up" { 
			dict lappend entries_by_guard $current_guard_id [list 1 [to_int [lindex $groups 1]]]
		}
		"\\[.+?:(\\d{2})\\] falls asleep" { 
			dict lappend entries_by_guard $current_guard_id [list 0 [to_int [lindex $groups 1]]]
			}
		default { puts "Parsing didnt match"}				
		}
	}

set times_by_guard [dict create ]

dict for {guard_id commands} $entries_by_guard  {
	set time_slept 0
	foreach {start_command end_command} $commands {
		set start_time [lindex $start_command 1]
		set end_time [lindex $end_command 1]
		set time_slept [expr ($end_time - $start_time)]
	}
	dict append times_by_guard $guard_id $time_slept
	
}

puts $times_by_guard

set max_time 0
set max_guard 0

dict for { guard_id time_slept} $times_by_guard {
	if { [expr $max_time < $time_slept ]} {
		set max_time $time_slept
		set max_guard $guard_id
	}
}

puts $max_guard
puts [dict get $entries_by_guard $max_guard]