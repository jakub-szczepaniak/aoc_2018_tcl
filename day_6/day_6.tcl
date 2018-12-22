source [file join [file dirname [info script]] ../utils utils.tcl]

proc parse_coordinates { file_content } {
	set lines [parse_input $file_content]
	set coordinates [list]
	set coordinate_id 1
	foreach line $lines {
		scan $line {%d, %d} x y
		lappend coordinates #id_$coordinate_id $x $y
		incr coordinate_id 
	}
	return $coordinates
}

proc min_max_coordinates { coordinates } {
	set max_x 0
	set max_y 0
	set min_x 999
	set min_y 999
	foreach { id x y } $coordinates {
		set min_x [ expr $x <= $min_x ? $x : $min_x]
		set min_y [ expr $y <= $min_y ? $y : $min_y]
		set max_x [ expr $x >= $max_x ? $x : $max_x]
		set max_y [ expr $y >= $max_y ? $y : $max_y]
	}
	return [list $min_x $min_y $max_x $max_y]
}

proc manhattan_dist { x1 y1 x2 y2 } {
	return [expr {abs($x2-$x1) + abs($y2-$y1)}]
}

set puzzle_input {1, 1
1, 6
8, 3
3, 4
5, 5
8, 9}

set puzzle_input [load_input "input.txt"]
set coordinates [parse_coordinates $puzzle_input]

set min_max [min_max_coordinates $coordinates]

set distances [dict create]

for {set dx [lindex $min_max 0]} { $dx < [lindex $min_max 2] } {incr dx} {
	for {set dy [lindex $min_max 1]} { $dy < [lindex $min_max 3] } {incr dy} {
			foreach {id x y} $coordinates {
				set distance [manhattan_dist $x $y $dx $dy]
				if { ![dict exists $distances "$dx:$dy"]} {
					dict set distances "$dx:$dy" [list $id $distance $distance]
				} else {
					set current [lindex [dict get $distances "$dx:$dy"] 1]
					
					if {$current > $distance} {
						dict set distances "$dx:$dy" [list $id $distance]
					}
					if {$current == $distance} { dict set distances "$dx:$dy" [list "." $distance] }
				}
			}
	}
}

set areas [dict create]
set infinite [list]
dict for { key value } $distances {
	set field_id [lindex $value 0]
	lassign [split $key ":"] x y
	lassign $min_max min_x min_y max_x max_y
	if { $x == $min_x || $x == $max_x - 1 || $y == $max_y -1 || $y == $min_y} {
		lappend infinite $field_id
	}
	dict incr areas $field_id
}


foreach inf [lsort -unique $infinite] {
	dict unset areas $inf
}
puts "part 1 : [dict get $areas [max_value_key $areas]]"

# part 2

set area 0

set distances [dict create]

for {set dx [lindex $min_max 0]} { $dx < [lindex $min_max 2] } {incr dx} {
	for {set dy [lindex $min_max 1]} { $dy < [lindex $min_max 3] } {incr dy} {
			foreach {id x y} $coordinates {
				set distance [manhattan_dist $x $y $dx $dy]
				dict incr distances "$dx:$dy" $distance
			}
			if { [dict get $distances "$dx:$dy"] < 10000} {
				incr area
			}
	}
}
puts "Part 2: $area"

