source [file join [file dirname [info script]] ../utils utils.tcl]

proc as_claim { line } {
	set claim [dict create]
	regexp "^#(\\d+?) @ (\\d+?),(\\d+?): (\\d+?)x(\\d+?$)" $line whole_match claim_id x y w h
	dict append claim claim_id $claim_id
	dict append claim x $x
	dict append claim y $y
	dict append claim w $w
	dict append claim h $h
	return $claim
}
proc list_covered { claim } {
	
}

set input [load_input "input.txt"]

set lines [parse_input $input]

set claims [list]
foreach line $lines {
	lappend claims [as_claim $line]
} 
puts $claims