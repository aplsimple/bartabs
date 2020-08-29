#! /usr/bin/env tclsh

# testing bartabs

#----------------------------------

package require Tk

lappend auto_path "."
package require bartabs

#----------------------------------

proc ::TestDel {b t l} {
  return [expr {[tk_messageBox -title "Closing \"$l\"" \
    -message "\nReally close \"$l\"?" \
    -detail "\nDetails: bar=$b tab=$t label=$l" \
    -icon question -type yesno] eq "yes"}]
}

#----------------------------------

proc ::TestAdd {tabID} {
  set barID [lindex [::bartabs::tab_BarID $tabID] 0]
  set newtabID [::bartabs::tab_Insert $barID $::noname]
  if {$newtabID==-1} {
    set newtabID [::bartabs::tab_IDbyName $barID $::noname]
    if {$newtabID==-1} {
      tk_messageBox -title "Error" -message "  \nThe tab not created." \
        -icon error -type ok
      return
    }
  }
  ::bartabs::tab_Show $newtabID
}

#----------------------------------

proc ::TestSwitch {barID tabID optname} {

  set val [::bartabs::bar_Cget $barID $optname]
  if {[expr {$val eq "" || !$val}]} {set val yes} {set val no}
  ::bartabs::bar_Configure $barID $optname $val
  if {$optname in {-static -hidearrows}} {::bartabs::bar_Update $barID}
  set bwidth [::bartabs::bar_Cget $barID -width]
  set twidth [::bartabs::tab_Cget $tabID -width]
  tk_messageBox -title "Info" -message "  \nThe \"$optname\" option is \"$val\"." \
    -detail "\n#$barID bar's width is $bwidth.\n#$tabID tab's width is $twidth." \
    -icon info -type ok
}

#----------------------------------

proc ::TestComm {oper args} {
  puts "$oper: $args"
  return yes
}

#----------------------------------

proc ::TestViewSel {barID} {

  set sellist ""
  lassign [::bartabs::tab_SelList $barID] fewsel tcurr
  foreach tabID $fewsel {
    set text [::bartabs::tab_Cget $tabID -text]
    append sellist "tabID: $tabID, label: $text\n"
  }
  set text [::bartabs::tab_Cget $tcurr -text]
  tk_messageBox -title "Info" -message "Selected tabs:\n\n$sellist" \
    -detail "Current tab: tabID: $tcurr, label: $text\n\nClick on a tab while pressing Ctrl\nto select few tabs." -icon info -type ok
}

#----------------------------------

proc ::TestDsbl {tabID menuitem} {
  set barID [lindex [::bartabs::tab_BarID $tabID] 0]
  set static [::bartabs::bar_Cget $barID -static]
  return [expr {$static && $menuitem eq "Append $::noname"}]
}

proc ::CalcWidth3 {barID} {

  if {[::bartabs::bar_Exists $barID]} {
    lassign [::bartabs::bar_Cget $barID -bwidth] wneed
    set ww [expr {[winfo width .]-[winfo width $::l3]-40}]
    if {$wneed != $ww} {
      ::bartabs::bar_Configure $barID -bwidth $ww
      ::bartabs::bar_Draw $barID no
    }
  }
}

#----------------------------------

set ::noname "<No name>"
wm minsize . 200 170
set l1 .l1
set l2 .l2
set w1 .f1
set w2 .f2
set w3 .f3
set l3 $w3.l3
set w4 .f4
set w5 $w4.f5
ttk::label $l1 -text [string repeat "0123456789" 6]
ttk::label $l2 -text [string repeat "0123456789" 12]
ttk::frame $w1
ttk::frame $w2
ttk::frame $w3
ttk::label $l3 -text [string repeat "0123456789" 4]
ttk::frame $w4
ttk::frame $w5
pack $l1 -anchor sw -pady 10
pack $w1 -side top -anchor w
pack $l2 -anchor sw -pady 10
pack $w2 -side top -expand 1 -fill x
pack $l3
pack $w3 -side left -anchor w
pack $w5 -anchor e -expand 1 -fill x
pack $w4 -side left -after $w3 -expand 1 -fill x -anchor e
set bw [winfo reqwidth $l1]

set bar1 [list -tleft 1 -tright 5 -wbar $w1 -fgsel "" \
  -bwidth $bw -hidearrows yes -relief sunken  -static 1 -tiplen -1 \
  -menu [list sep "com {Append $::noname} {::TestAdd %t} {} ::TestDsbl" sep \
  "com {Switch -static option} {::TestSwitch %b %t -static}" \
  "com {Switch -scrollsel option} {::TestSwitch %b %t -scrollsel}" \
  "com {Switch -hidearrows option} {::TestSwitch %b %t -hidearrows}"] ]

set bar2 [list  -wbar $w2 -wbase $l2 -lablen 11 -expand 0 \
   -tleft 3 -fgsel black -bgsel #999999 \
   -cnew {::TestComm new %b %t {%l}} \
   -cmov {::TestComm mov %b %t {%l}} \
   -csel {::TestComm sel %b %t {%l}} \
   -cdel {::TestDel %b %t {%l}} \
   -font "-family Helvetica -size 12" -scrollsel 1 \
   -menu [list sep "com {Append $::noname} {::TestAdd %t}" \
   "com {View selected} {::TestViewSel %b}"]]

set bar3 [list -wbar $w5 -wproc {::CalcWidth3 %b}]

lappend bar1 -tab "#0 tab item" ;# to test for duplicates
lappend bar2 -tab "#0 tab item" -tab "Item 1 \""
for {set n 0} {$n<10} {incr n} {
  set tab "#$n tab item[string repeat ~ [expr $n/2]]"
  lappend bar1 -tab $tab
  lappend bar2 -tab $tab
  lappend bar3 -tab $tab
}

::bartabs::bar_Create $bar1
::bartabs::bar_Create $bar2
::bartabs::bar_Create $bar3
::bartabs::bar_DrawAll

####### some mimicring actions with bars & tabs:
update
toplevel .mimi
label .mimi.l -text "\n\n <== Please wait 5 seconds\n\n <== while seeing this test.\n\n" -fg #800080 -font "-size 12"
pack .mimi.l
update
lassign [split [winfo geometry .] x+] w h x y
lassign [split [winfo geometry .mimi] x+] w2
wm geometry .mimi +[expr {$x+$w-$w2}]+$y
after 1000 {::bartabs::tab_Show 5 ; ::bartabs::tab_Show 15}
after 2000 {::bartabs::tab_Mark 12 15 18 19 20}
after 3000 {::bartabs::tab_UnMark 19 20}
after 4000 {::bartabs::tab_Insert 1 "Button 0.5" 1}
after 4500 {::bartabs::tab_Configure 12 -text "==12th tab==" ; ::bartabs::tab_Show 12}
#after 5000 {::bartabs::tab_Close 19}
after 5010 {if {[winfo exists .mimi]} {destroy .mimi}}
