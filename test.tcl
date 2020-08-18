#! /usr/bin/env tclsh

# testing bartabs

#----------------------------------

package require Tk

source bartabs.tcl

#----------------------------------

proc ::TestDel {b t l} {
  return [expr {[tk_messageBox -title "Closing \"$l\"" \
    -message "\nReally close \"$l\"?" \
    -detail "\nDetails: bar=$b tab=$t label=$l" \
    -icon question -type yesno] eq "yes"}]
}

proc ::TestAdd {tabID} {
  set barID [lindex [::apave::bartabs::tab_BarID $tabID] 0]
  set newtabID [::apave::bartabs::tab_Insert $barID $::noname]
  if {$newtabID==-1} {
    set newtabID [::apave::bartabs::tab_IDbyName $barID $::noname]
    if {$newtabID==-1} {
      tk_messageBox -title "Error" -message "  \nThe tab not created." \
        -icon error -type ok
      return
    }
  }
  ::apave::bartabs::tab_Show $newtabID
}

#----------------------------------

set ::noname "<No name>"
wm minsize . 200 20
set l1 .l1
set l2 .l2
set w1 .f1
set w2 .f2
ttk::label $l1 -text [string repeat "0123456789" 11]
pack $l1 -anchor w
ttk::label $l2 -text [string repeat "0123456789" 5]
pack $l2 -anchor w
set bw [winfo reqwidth $l2]
ttk::frame $w1
ttk::frame $w2
pack $w1 -anchor w ;#-expand 1 -fill x
pack $w2 -expand 1 -fill x -anchor n

set bar1 [list -tleft 1 -tright 5 -fgover #FFFFFF -bgover #8B8C85 -wbar $w1 \
  -bwidth $bw -hidearrows true -bd 2 -relief sunken \
  -popup sep -popup "com {Append $::noname} {::TestAdd %t}"]

set bar2 [list -tleft 3 -tright end -cnew newTab -cmov movTab \
   -csel {puts "SelectedTab: bar=%b tab=%t label=%l"} -wbar $w2 \
   -cdel {::TestDel %b %t {%l}} -wbar $w2 \
   -font "-family Helvetica -size 11" -scrollcurr true]

lappend bar1 -tab "Button 0 " ;# to test for duplicates
lappend bar2 -tab "Button 0 " -tab "Button 1 \"\""
for {set n 0} {$n<10} {incr n} {
  set tab "Button $n [string repeat . [expr $n/2]]"
  lappend bar1 -tab $tab
  lappend bar2 -tab $tab
}

::apave::bartabs::bar_Create $bar1
::apave::bartabs::bar_Create $bar2
::apave::bartabs::bar_RedrawAll

####### some mimicring actions with bars & tabs:

#toplevel .mimi
#label .mimi.l -text "\n\n <== Please wait 5 seconds\n\n <== while seeing this test.\n\n" -fg white -bg maroon -font "-weight bold"
#pack .mimi.l
#update
#lassign [split [winfo geometry .] x+] w h x y
#lassign [split [winfo geometry .mimi] x+] w2
#wm geometry .mimi +[expr {$x+$w-$w2}]+$y
#after 1000 {::apave::bartabs::tab_Show 5 ; ::apave::bartabs::tab_Show 15}
#after 2000 {::apave::bartabs::tab_Mark 12 15 18 19 20}
#after 3000 {::apave::bartabs::tab_UnMark 19 20}
#after 4000 {::apave::bartabs::tab_Insert 1 "Button 0.5" 1}
#after 5000 {::apave::bartabs::tab_Close 19}
#after 5010 {if {[winfo exists .mimi]} {destroy .mimi}}
