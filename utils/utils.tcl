proc load_input { filename } {
	set fp [open $filename r]
	set file_data [read $fp]
	close $fp
	return $file_data
}

proc parse_input { file_content} {
	split $file_content "\n"
}