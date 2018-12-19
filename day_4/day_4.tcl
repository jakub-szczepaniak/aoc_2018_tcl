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

proc fill_in_0 { dictionary } {
	for { set x 0} { $x < 60} { incr x} {
		dict set dictionary $x 0
	}
	return $dictionary
}

set puzzle [load_input "input.txt"]
#set puzzle [load_input "test.txt"]
set parsed [parse_input $puzzle]

set sorted [lsort $parsed]
save_output "sorted.txt" $sorted

set time_by_guard [dict create]
set minutes [dict create]
set minutes_by_guard [dict create]

set current_guard_id 0
foreach log_entry $sorted {
	set command [parse_command $log_entry]
	set time_slept 0
	switch [lindex $command 0] {
		 "guard_id" {
			set current_guard_id [lindex $command 1]
			set minutes [ fill_in_0 $minutes ]
		}
		"asleep" {
			set start_minute [lindex $command 1] 
		}
		"awake" {
			set end_minute [lindex $command 1]
			set time_slept [expr $end_minute - $start_minute]
			for { set x $start_minute } { $x < $end_minute } { incr x} {
				dict incr minutes $x
			}
			dict incr time_by_guard $current_guard_id $time_slept

			dict lappend minutes_by_guard $current_guard_id [list $minutes]
		}
	}
	
}

#puts $minutes_by_guard

set lazy_guard_id [max_value_key $time_by_guard]
set lazy_minutes [flatten [dict get $minutes_by_guard $lazy_guard_id]]

set total_minutes [fill_in_0 [dict create]]

foreach minutes $lazy_minutes {
	dict for { key value } $minutes {
		dict inc total_minutes $key $value
	}
}

puts "Part 1 [expr $lazy_guard_id * [max_value_key $total_minutes]] "

dict for { guard_id days } $minutes_by_guard {
	set minutes [fill_in_0 [dict create]]
	foreach day [flatten $days] {
		#puts $minute
		foreach { minute state} $day {
		dict incr minutes $minute $state
		}
	} 
	puts "$guard_id : minute: [max_value_key $minutes], sleeps: [dict get $minutes [max_value_key $minutes]]"

}
puts [expr 449*36]

