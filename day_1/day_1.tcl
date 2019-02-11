source [file join [file dirname [info script]] ../utils utils.tcl]

set puzzle [load_input "[file dirname [info script]]/input.txt"]

# part one
set parsed [parse_input $puzzle]
puts "result part1 [expr $parsed]"

# part 2
set frequencies [dict create]
set freq_count [expr [llength $parsed]]

set sum 0
set ctr 0
while {![dict exists $frequencies $sum]} {
		dict append frequencies $sum $sum
		set sum [expr $sum[lindex $parsed $ctr]]
		incr ctr
		if { [expr $ctr > $freq_count -1] } {
	 		set ctr 0
  	}
}
puts "result part2 $sum"


