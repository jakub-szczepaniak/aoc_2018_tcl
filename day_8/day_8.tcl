source [file join [file dirname [info script]] ../utils utils.tcl]

proc prepare_input {} {
	set puzzle_input [split [load_input "[file dirname [info script]]/input.txt"] " "]
	set parsed [flatten $puzzle_input]
}

proc read_node { data } {
	set this_node ""
	if { [llength $data]} {
		set this_node [incr ::nodenum]
		puts "current node : $this_node"
		set data [lassign $data children_count meta_count]
		set ::nodes($this_node) [list]
		while {$children_count} {
			puts "$this_node has $children_count children"
			incr children_count -1
			lassign [read_node $data] n data
			lappend ::nodes($this_node) $n
		}
		set ::metadata($this_node) [list 0]
		while {$meta_count} {
			puts "$this_node has $meta_count metadata"
			lappend ::metadata($this_node) [lindex $data 0]
			puts "Collected values for $this_node: [array get ::metadata $this_node]"
			set data [lrange $data 1 end]
			incr meta_count -1
		}
	} else {
		error "read_node called with empty data"
	}
	puts "finished parsing $this_node"
	return [list $this_node $data]
}

proc part1 {} {
	set meta_sum 0
	foreach {n md} [array get ::metadata] {
		incr meta_sum [expr [join $md +]]
	}
	return $meta_sum
}

proc part2 {node value} {
	if {[llength $::nodes($node)] == 0} {
		incr value [expr [join $::metadata($node) +]]
	} else {
		foreach meta $::metadata($node) {
			incr meta -1
			set n [lindex  $::nodes($node) $meta]
			if {$n ne ""} {
				set value [part2 $n $value]
			}

		}
	}
	return $value
}

set puzzle_input [prepare_input]
set nodenum 0
lassign [read_node $puzzle_input] _ rest

if {[llength $rest] > 0} {
	error "not all data read"
}

puts "Part 1: [part1]"
puts "Part 2: [part2 1 0]"