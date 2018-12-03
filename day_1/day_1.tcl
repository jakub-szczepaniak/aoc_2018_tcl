proc load_input { filename } {
	set fp [open $filename r]
	set file_data [read $fp]
	close $fp
	return $file_data
}

proc parse_input { file_content} {
	split $file_content "\n"
}

set puzzle [load_input "input.txt"]

set parsed [parse_input $puzzle]
# part one

puts "result part1 [expr $parsed]"

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


