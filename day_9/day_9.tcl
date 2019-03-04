proc init_game {} {
	return [list 0 0]
}

proc add_marble {game_field marble} {
	set field [lassign $game_field position]
	
	set field [lappend field $marble]
	set field [lappend field 1]
	return $field
}
