source [file join [file dirname [info script]] ../utils utils.tcl]

proc as_claim { line } {
	set claim [dict create]
	regexp "^#(\\d+?) @ (\\d+?),(\\d+?): (\\d+?)x(\\d+?$)" $line whole_match claim_id x y w h
	dict append claim claim_id $claim_id
	dict append claim x $x
	dict append claim y $y
	dict append claim w $w
	dict append claim h $h
	set covered_list [list_covered $claim]
	dict append claim covered $covered_list
	return $claim
}
proc list_covered { claim } {
	set top_corner_x [dict get $claim x]
	set top_corner_y [dict get $claim y]
	set width [dict get $claim w]
	set height [dict get $claim h]
	set result [list]
	
	for {set counter_x $top_corner_x} { $counter_x < [expr $width + $top_corner_x]} {incr counter_x} {
		for {set counter_y $top_corner_y} {$counter_y < [expr $height + $top_corner_y]} {incr counter_y} {
		lappend result "$counter_x:$counter_y"
		}
	}
	return $result
}

set input [load_input "input.txt"]

set lines [parse_input $input]

set claims [list]

set fabric [dict create]

foreach line $lines {
	set current_claim [as_claim $line]
	foreach covered [dict get $current_claim covered ] {
		  dict lappend fabric $covered [dict get $current_claim claim_id]
	}
} 

set result_1 0
foreach inch [dict values $fabric] {
	if {[expr [llength $inch] > 1]} {
		incr result_1 
	}
} 
puts $result_1

puts [dict get $fabric 130:466]