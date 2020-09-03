#! /usr/bin/env tclsh

# testing bartabs

#----------------------------------

package require Tk

lappend auto_path [file dirname [info script]]
package require bartabs

#----------------------------------

image create photo markimg -data {iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAAABGdBTUEAAK/INwWK6QAAABl0RVh0
U29mdHdhcmUAQWRvYmUgSW1hZ2VSZWFkeXHJZTwAAAMFSURBVHjaYvz//z8DJQAgAINxcAQgCANA
8MgQlRkefrUDLZM6LBQSAd3XxlxOZofYNtQTWhMWOqYVxHjVsdWY0gj/x+Iw7NqP/KByfwKIiSTr
QI79/TtBXVlqV6S1hZUAK98/gAAi2gCgV0X/MTHMdrfQm1/r6Shz8drzfw/uvEoECCCW/wz/FYHB
8A2o5iUOnQz//vwz4xbjnJ/soqUVoKHM0LH7PMOx0w8yGbmZNgEEEIuQCO/VX7//3fz8+I8PGwPD
UxS9//6z/vj7J1VOTbCnwseY00ZcgKF853mGXQcf1DOxs8xiYPzHABBATHzM3J99HBQNuAXZVv7+
808IrJMRGE5//2v85WBY5uaoNHVqmAenlbgkQ+Oeawy79j7vZ/vP0sTABIk9gABienbn+0wJBjGG
7EAra0YuhnX//jEw/vn9z5VXnGVXarBBSIOrO4M4Dw9D78FLDNu2v1zF/pu5nAEp5AACAEEAvv8D
BjAZ5u70+2RxSUoEBw3+H8fX4mUiKg1hdlc6FEoiMwD4/vMAn8nQAK6t6bgA+v1dAAf89/wE+gD9
BvkA/wf8AAIAQQC+/wMQMCHw7e73HRUcCDNXMDwBCBn3DlM2LgUqDyMA7vzpALHU0wCxquzRAfIB
WQUFAuwD/QQABf0GAAb7CQAG+QoAAgBBAL7/AxAvIv/99AX78gHvWy8nFwEwFiQAA/8DAO/96gC/
3dYArqXx4P/tAU0GBwHgBfwGAAb8CAAI+QwACPYPAAn0EAACiFlIQ5uB9Q/H4y+f/1nxq35V4mFn
Yfj0/xXD6Sf3GLYu/f7m91OWACaO31f+M/+DeJoRGPEgzPQPjAECiInjFzsD5z+2n4zP+LaePv2e
4TnjHYaLr+4z7Fz668uv21wxzMwMp/ElMIAAYmL+y84Awhz/2Be9PsP98MTt5wxHVzH/+n5ZIBuo
eSehFAoQQMwSakbAKGVmYGJk/M70jUPszW0eix/XeesYmP9M+8/2h+Ef82+G/yzADAT2AiOGAQAB
xEhpdgYIMABQrSEzlY7wIwAAAABJRU5ErkJggg==}

#----------------------------------

proc ::TestDel {b t l} {
  return [expr {[tk_messageBox -title "Closing \"$l\"" \
    -message "\nReally close \"$l\"?" \
    -detail "\nDetails: bar=$b tab=$t label=$l" \
    -icon question -type yesno] eq "yes"}]
}

#----------------------------------

proc ::TestAdd {tabID} {
  set barID [lindex [bts::tab_BarID $tabID] 0]
  set newtabID [bts::tab_Insert $barID $::noname]
  if {$newtabID==-1} {
    set newtabID [bts::tab_IDbyName $barID $::noname]
    if {$newtabID==-1} {
      tk_messageBox -title "Error" -message "  \nThe tab not created." \
        -icon error -type ok
      return
    }
  }
  bts::tab_Show $newtabID
}

#----------------------------------

proc ::TestSwitch {barID tabID optname} {
  set val [bts::bar_Cget $barID $optname]
  if {[expr {$val eq "" || !$val}]} {set val yes} {set val no}
  bts::bar_Configure $barID $optname $val
  if {$optname in {-static -hidearrows -expand -bd}} {bts::bar_Update $barID}
  set bwidth [bts::bar_Cget $barID -width]
  set twidth [bts::tab_Cget $tabID -width]
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
  lassign [bts::tab_SelList $barID] fewsel tcurr
  foreach tabID $fewsel {
    set text [bts::tab_Cget $tabID -text]
    append sellist "tabID: $tabID, label: $text\n"
  }
  set text [bts::tab_Cget $tcurr -text]
  tk_messageBox -title "Info" -message "Selected tabs:\n\n$sellist" \
    -detail "Current tab: tabID: $tcurr, label: $text\n\nClick on a tab while pressing Ctrl\nto select few tabs." -icon info -type ok
}

#----------------------------------

proc ::TestDsbl {barID tabID menuitem} {
  set static [bts::bar_Cget $barID -static]
  return [expr {$static && $menuitem eq "Append $::noname"}]
}

#----------------------------------

proc ::StoreAll {} {
  set ::storedBt2 [bts::bar_Store 2]
  set ::storedBt3 [bts::bar_Store 3]
  set ::storedBt4 [bts::bar_Store 4]
  $::b1 configure -state normal
}

proc ::RestoreAll {} {
  bts::bar_Restore 2 $::storedBt2
  bts::bar_Restore 3 $::storedBt3
  bts::bar_Restore 4 $::storedBt4
  bts::bar_DrawAll
}

#----------------------------------

proc ::FillBarTabs {} {

  set ::noname "<No name>"
  set ::frm .frame
  set ::l0 $::frm.::l0
  set ::l1 $::frm.::l1
  set ::l2 $::frm.::l2
  set ::w0 $::frm.f0
  set ::w1 $::frm.f1
  set ::w2 $::frm.f2
  set ::w3 $::frm.f3
  set ::l3 $::w3.l3
  set ::w4 $::frm.f4
  set ::w5 $::w4.f5
  set ::w6 $::frm.w6
  set ::b1 $::w6.b1
  set ::b2 $::w6.b2
  toplevel $::frm
  wm minsize $::frm 200 350
  wm geometry $::frm +80+80
  wm protocol $::frm WM_DELETE_WINDOW exit
  ttk::label $::l0 -text "Absolutely static with \"-expand 1\" option:"
  ttk::label $::l1 -text [string repeat "0123456789" 6]
  ttk::label $::l2 -text [string repeat "0123456789" 12]
  ttk::frame $::w0
  ttk::frame $::w1
  ttk::frame $::w2
  ttk::frame $::w3
  ttk::label $::l3 -text [string repeat "0123456789" 4]
  ttk::frame $::w4
  ttk::frame $::w5
  ttk::frame $::w6
  ttk::button $::b1 -text "Restore all" -command ::RestoreAll -state disabled
  ttk::button $::b2 -text "Store all" -command ::StoreAll
  pack $::l0 -anchor w -pady 10
  pack $::w0 -side top -anchor nw -expand 1
  pack $::l1 -anchor sw -pady 10
  pack $::w1 -side top -anchor nw -expand 1
  pack $::l2 -anchor w -pady 10
  pack $::w2 -side top -anchor nw -expand 1 -fill x
  pack $::l3
  pack $::w3 -side left -anchor n
  pack $::w5 -expand 1 -fill x
  pack $::w4 -side left -after $::w3 -expand 1 -fill x -anchor ne
  pack $::w6 -anchor e -after $::l3 -side top -anchor e -expand 1 -fill x
  pack $::b1 -anchor e -side right
  pack $::b2 -anchor e -side right

  set bar0 [list -wbar $::w0 -wbase $::frm -wproc "winfo width $::l1" \
    -hidearrows yes -static 1 -padx 12 -pady 6 -csel "::TestComm sel %b %t {%l}"]

  set bar1 [list -tleft 1 -tright 5 -wbar $::w1 -fgsel "" \
    -wbase $::frm -wproc "winfo width $::l1" \
    -hidearrows yes -relief sunken  -static 1 -tiplen -1 \
    -menu [list sep "com {Append $::noname} {::TestAdd %t} {} ::TestDsbl" sep \
    "com {Switch -static option} {::TestSwitch %b %t -static}" \
    "com {Switch -scrollsel option} {::TestSwitch %b %t -scrollsel}" \
    "com {Switch -hidearrows option} {::TestSwitch %b %t -hidearrows}"] ]
  
  set bar2 [list -wbar $::w2 -wbase $::l2 \
    -lablen 11 -expand 0 -imagemark markimg \
    -tleft 3 -fgsel black -bgsel #999999 \
    -cnew {::TestComm new %b %t {%l}} \
    -cmov {::TestComm mov %b %t {%l}} \
    -csel {::TestComm sel %b %t {%l}} \
    -cdel {::TestDel %b %t {%l}} \
    -font "-family Helvetica -size 12" -scrollsel 1 \
    -menu [list sep "com {Append $::noname} {::TestAdd %t}" \
    "com {View selected} {::TestViewSel %b}" \
    sep \
    "com {Switch -expand option} {::TestSwitch %b %t -expand}" ]]
  
  set bar3 [list -wbar $::w5 -wbase $::frm -wproc \
    "expr {\[winfo width $::frm\]-\[winfo width $::l3\]-80}" -tleft 7 -bd 0 \
    -menu [list sep "com {Switch -bd option} {::TestSwitch %b %t -bd}"]]
  
  lappend bar1 -tab "#0 tab item" ;# to test for duplicates
  lappend bar2 -tab "#0 tab item" -tab "Item 1 \""
  for {set n 0} {$n<10} {incr n} {
    set tab "#$n tab item[string repeat ~ [expr $n/2]]"
    if {$n<4} {lappend bar0 -tab $tab}
    lappend bar1 -tab $tab
    lappend bar2 -tab $tab
    lappend bar3 -tab $tab
  }
  bts::bar_Create $bar0
  bts::bar_Create $bar1
  bts::bar_Create $bar2
  bts::bar_Create $bar3
}

#----------------------------------

if {$::tcl_platform(platform) == "windows"} {
  wm attributes . -alpha 0.0
} else {
  wm withdraw .
}
try {ttk::style theme use clam}

::FillBarTabs

if {1} {
  ####### some mimicring actions with bars & tabs:
  toplevel .mimi
  label .mimi.l -text "\n\n <== Please wait 5 seconds\n\n <== while seeing this test.\n\n" -fg #800080 -font "-size 12"
  lassign [split [winfo geometry $::frm] x+] w h x y
  lassign [split [winfo geometry .mimi] x+] ::w2 h2
  wm geometry .mimi +$x+[expr {$y+$h+10}]
  pack .mimi.l
  update
  after 1000 {bts::tab_Show 5 ; bts::tab_Show 15}
  after 2000 {bts::tab_Mark 12 15 18 19 20}
  after 3000 {bts::tab_Unmark 19 20}
  after 4000 {bts::tab_Insert 2 "Button 0.5" 1}
  after 4500 {bts::tab_Configure 12 -text "==12th tab==" ; bts::tab_Show 12}
  after 5000 {bts::tab_Close 19}
  after 5050 {if {[winfo exists .mimi]} {destroy .mimi}}
}  
