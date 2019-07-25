package require Tk

set w 500
set h 500
ttk::frame .f 
canvas .f.c -height $h -width $w

grid .f
focus .f
bind .f <1> {focus %W}
.f configure -takefocus 1

proc setU { up } {
	return [expr -1 * $up ]
}

set step 10 

set up 0
set right $step
#list of direction for each element of the snake
set direcs [ list r r r r] 
set tags [ list a b c d]
#####
#TODO 
#1. no self-interestion are allowed
#2. add food
#
proc checkOverlap {size} {
	#---------------
	set lcoords {}
	for { set i 0} {$i < [expr $size]} {incr i} {
		set coords [.f.c coords [.f.c gettags [string cat $i x]]]
		if { [llength $coords] != 0} {
			lappend lcoords $coords
		}
	}
	set len [llength $lcoords]
	if {[llength [lsort -unique $lcoords]] != $len} {
		exit
	}
		#---------------
}
proc addFood {} {

		global w
		global h
		global step
		set x1 [expr $step * [expr round([expr [expr $w * [expr rand()]]] / $step)]]
		set y1 [expr $step * [expr round([expr [expr $h * [expr rand()]]] / $step)]]


		set x2 [expr $x1 - $step]
		set y2 [expr $y1 - $step]


		#.f.c create rectangle $x1 $y1 $x2 $y2 -tags food
		puts $x1
		.f.c create rectangle $x1 $y1 $x2 $y2 -tags food

		 
}
proc moveRec { size tag x1 y1 x2 y2 } {

		global up
		global right
		global w
		global h
				set x1 [expr $x1 + $right ]
			
				set y1 [expr $y1 + $up ]
				set x2 [expr $x2 + $right ]
				set y2 [expr $y2 + $up ] 
				set last [string length $tag]
				set tag [string range $tag 0 [expr $last - 2 ]]
				checkOverlap $size
				#-----eat food

				set coords [.f.c coords food]
				puts ----------
				puts $coords 
				puts [list $x1 $y1 $x2 $y2]
				puts ----------
				#puts [list $x1 [lindex coords 0] $y2 [lindex coords 1]]
				
				puts ---------
				if {$x1 == [lindex $coords 0] && $y1 == [lindex $coords 1]} {
					.f.c delete food
					set size [expr $size + 1]
				}
				#-----
				.f.c delete [string cat [expr [expr $tag + 1] % $size] x]

				set tag [string cat [expr [expr $tag + 1] % $size] x]
				
				.f.c create rectangle $x1 $y1 $x2 $y2 -tags $tag
			
				return [list moveRec $size $tag $x1 $y1 $x2 $y2]

}
proc f {dl} {

	foreach command $dl {
    	# execute the command. The return is the new command
    	# with parameters. 
    	lappend newdl [eval $command]
  	}
	puts ----------
	
	puts -----------
	if {[llength [.f.c gettags food]] == 0} {	
		addFood 
	}
	after 100 [list f $newdl]

}
bind .f <Key-Up> {
	global right
	global up
	set up -$step
	set right 0
}
bind .f <Key-Down> {
	global up	
	set up $step
	set right 0
}
bind .f <Key-Right> {
	global right	
	set right $step
	set up 0
}
bind .f <Key-Left> {
	global right	
	set right -$step
	set up 0
}

grid .f.c
set x1 10
set y1 10
set x2 20
set y2 20
#lappend dl [list moveRec 3  $x1 $y1 $x2 $y2]
#lappend dl [list moveRec 2  20 1t0 30 20]
lappend dl [list moveRec 2 0x  30 10 40 20]

f $dl

