namespace eval ::hashdeepCsv {}

proc ::hashdeepCsv::parseCsv {hashdeepOutputCsv} {
	set hashmap {}
	set lines [split $hashdeepOutputCsv \n]

	if {![string match "%%%% HASHDEEP*" [lindex $lines 0]]} {
		error "Invalid input file: found [lindex $lines 0] at line 1, expected '%%%% HASHDEEP...'";
	}

	set columnInfo [regsub {^%%%% } [lindex $lines 1] {}]
	set columns [split $columnInfo ,]
	if {[lsearch $columns "md5"] < 0} {
		error "Arbitrary limitation of this program: each csv line must contain an md5 hash"
	}

	foreach line $lines {
		set firstchar [string index $line 0]
		if {$firstchar == "%" || $firstchar == "#"} {
			continue
		}

		set parts [split $line ,]
		set keyValPairs {}

		for {set i 0} {$i < [llength $columns]} {incr i} {
			dict append keyValPairs [lindex $columns $i] [lindex $parts $i]
		}

		dict set hashmap [dict get $keyValPairs md5] $keyValPairs
	}

	return $hashmap
}

