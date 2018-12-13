proc load_input { filename } {
	set fp [open $filename r]
	set file_data [read $fp]
	close $fp
	return $file_data
}

proc parse_input { file_content} {
	split $file_content "\n"
}

proc filter {list script} {
	set res {}
	foreach element $list { if {[uplevel 1 $script $element]} {lappend res $element}}
	set res
}

proc not_in {list element} { expr { [lsearch -exact $list $element]==-1}}

proc flatten {list} { concat {*}$list }
