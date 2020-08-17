# _______________________________________________________________________ #
#
# The tab bar widget.
#
# Scripted by Alex Plotnikov.
# License: MIT.
# _______________________________________________________________________ #

package require Tk
namespace eval ::apave {} ;# just to be universal

# ______________________ Common data of bartabs _________________________ #

namespace eval ::apave::bartabs {

  set _ruff_preamble "
  The *bartabs* provides a bar widget containing tabs that are
    1) selectable
    2) scrollable
    3) markable
    4) moveable
    5) closeable
    6) configureable
    7) extendable & contractable
    8) enhanceable with popup menu functions
  "

  variable batData [dict create]
  variable NewBarID 0 NewTabID 0 NewTabNo 0
  variable WinWidth -1
  variable PosX ""
  image create photo ::apave::bartabs::ImgLeftArr \
  -data {iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADAFBMVEUAAAD/AAAA/wD//wAAAP//
AP8A///////b29u2traSkpJtbW1JSUkkJCTbAAC2AACSAABtAABJAAAkAAAA2wAAtgAAkgAAbQAA
SQAAJADb2wC2tgCSkgBtbQBJSQAkJAAAANsAALYAAJIAAG0AAEkAACTbANu2ALaSAJJtAG1JAEkk
ACQA29sAtrYAkpIAbW0ASUkAJCT/29vbtra2kpKSbW1tSUlJJCT/trbbkpK2bW2SSUltJCT/kpLb
bW22SUmSJCT/bW3bSUm2JCT/SUnbJCT/JCTb/9u227aStpJtkm1JbUkkSSS2/7aS25Jttm1Jkkkk
bSSS/5Jt221JtkkkkiRt/21J20kktiRJ/0kk2yQk/yTb2/+2ttuSkrZtbZJJSW0kJEm2tv+Skttt
bbZJSZIkJG2Skv9tbdtJSbYkJJJtbf9JSdskJLZJSf8kJNskJP///9vb27a2tpKSkm1tbUlJSST/
/7bb25K2tm2SkkltbST//5Lb2222tkmSkiT//23b20m2tiT//0nb2yT//yT/2//bttu2kraSbZJt
SW1JJEn/tv/bktu2bbaSSZJtJG3/kv/bbdu2SbaSJJL/bf/bSdu2JLb/Sf/bJNv/JP/b//+229uS
trZtkpJJbW0kSUm2//+S29tttrZJkpIkbW2S//9t29tJtrYkkpJt//9J29sktrZJ//8k29sk////
27bbtpK2km2SbUltSSRJJAD/tpLbkm22bUmSSSRtJAD/ttvbkra2bZKSSW1tJElJACT/krbbbZK2
SW2SJEltACTbtv+2ktuSbbZtSZJJJG0kAEm2kv+SbdttSbZJJJIkAG222/+SttttkrZJbZIkSW0A
JEmStv9tkttJbbYkSZIAJG22/9uS27ZttpJJkm0kbUkASSSS/7Zt25JJtm0kkkkAbSTb/7a225KS
tm1tkklJbSQkSQC2/5KS221ttklJkiQkbQD/tgDbkgC2bQCSSQD/ALbbAJK2AG2SAEkAtv8AktsA
bbYASZIAAAAAAADPKgIEAAAAgElEQVQ4y52T0QnAMAhEr6GjuIzukvXiMHEX+xUopZVrAvlR3sOT
BJkJ9qpqPmsN5DGzfKs3Fu69Y0tgZqmqn/3GwFsCBgaAs4JFBO4OEUFEcBOYWYpICVER7nBEYM7J
CcYYRwVQE/yRfEZgJeU7WBJ33xMsyXOpv//CkmwLKskFTjp4qfk0WXsAAAAASUVORK5CYII=}
  image create photo ::apave::bartabs::ImgRightArr \
  -data {iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADAFBMVEUAAAD/AAAA/wD//wAAAP//
AP8A///////b29u2traSkpJtbW1JSUkkJCTbAAC2AACSAABtAABJAAAkAAAA2wAAtgAAkgAAbQAA
SQAAJADb2wC2tgCSkgBtbQBJSQAkJAAAANsAALYAAJIAAG0AAEkAACTbANu2ALaSAJJtAG1JAEkk
ACQA29sAtrYAkpIAbW0ASUkAJCT/29vbtra2kpKSbW1tSUlJJCT/trbbkpK2bW2SSUltJCT/kpLb
bW22SUmSJCT/bW3bSUm2JCT/SUnbJCT/JCTb/9u227aStpJtkm1JbUkkSSS2/7aS25Jttm1Jkkkk
bSSS/5Jt221JtkkkkiRt/21J20kktiRJ/0kk2yQk/yTb2/+2ttuSkrZtbZJJSW0kJEm2tv+Skttt
bbZJSZIkJG2Skv9tbdtJSbYkJJJtbf9JSdskJLZJSf8kJNskJP///9vb27a2tpKSkm1tbUlJSST/
/7bb25K2tm2SkkltbST//5Lb2222tkmSkiT//23b20m2tiT//0nb2yT//yT/2//bttu2kraSbZJt
SW1JJEn/tv/bktu2bbaSSZJtJG3/kv/bbdu2SbaSJJL/bf/bSdu2JLb/Sf/bJNv/JP/b//+229uS
trZtkpJJbW0kSUm2//+S29tttrZJkpIkbW2S//9t29tJtrYkkpJt//9J29sktrZJ//8k29sk////
27bbtpK2km2SbUltSSRJJAD/tpLbkm22bUmSSSRtJAD/ttvbkra2bZKSSW1tJElJACT/krbbbZK2
SW2SJEltACTbtv+2ktuSbbZtSZJJJG0kAEm2kv+SbdttSbZJJJIkAG222/+SttttkrZJbZIkSW0A
JEmStv9tkttJbbYkSZIAJG22/9uS27ZttpJJkm0kbUkASSSS/7Zt25JJtm0kkkkAbSTb/7a225KS
tm1tkklJbSQkSQC2/5KS221ttklJkiQkbQD/tgDbkgC2bQCSSQD/ALbbAJK2AG2SAEkAtv8AktsA
bbYASZIAAAAAAADPKgIEAAAAjElEQVQ4y52RwQ3EMAgEN9alE5rBvTjlmSauAyglEveNEkLIIfEx
mtGC4e44NjP7+S3rhqB6745ihYIxRlnS7gbMXJKkgoqkZcOKJBSYGVQVIgIiSiXtaUczAxGBiELJ
J4JU9SL56wZHoZnhu29rKUEEzzmX1wme4DSBiABACqffWIHTFSrwraAKA8APNup1woreOEgAAAAA
SUVORK5CYII=}
  image create photo ::apave::bartabs::ImgNone \
  -data {iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADAFBMVEUAAAD/AAAA/wD//wAAAP//
AP8A///////b29u2traSkpJtbW1JSUkkJCTbAAC2AACSAABtAABJAAAkAAAA2wAAtgAAkgAAbQAA
SQAAJADb2wC2tgCSkgBtbQBJSQAkJAAAANsAALYAAJIAAG0AAEkAACTbANu2ALaSAJJtAG1JAEkk
ACQA29sAtrYAkpIAbW0ASUkAJCT/29vbtra2kpKSbW1tSUlJJCT/trbbkpK2bW2SSUltJCT/kpLb
bW22SUmSJCT/bW3bSUm2JCT/SUnbJCT/JCTb/9u227aStpJtkm1JbUkkSSS2/7aS25Jttm1Jkkkk
bSSS/5Jt221JtkkkkiRt/21J20kktiRJ/0kk2yQk/yTb2/+2ttuSkrZtbZJJSW0kJEm2tv+Skttt
bbZJSZIkJG2Skv9tbdtJSbYkJJJtbf9JSdskJLZJSf8kJNskJP///9vb27a2tpKSkm1tbUlJSST/
/7bb25K2tm2SkkltbST//5Lb2222tkmSkiT//23b20m2tiT//0nb2yT//yT/2//bttu2kraSbZJt
SW1JJEn/tv/bktu2bbaSSZJtJG3/kv/bbdu2SbaSJJL/bf/bSdu2JLb/Sf/bJNv/JP/b//+229uS
trZtkpJJbW0kSUm2//+S29tttrZJkpIkbW2S//9t29tJtrYkkpJt//9J29sktrZJ//8k29sk////
27bbtpK2km2SbUltSSRJJAD/tpLbkm22bUmSSSRtJAD/ttvbkra2bZKSSW1tJElJACT/krbbbZK2
SW2SJEltACTbtv+2ktuSbbZtSZJJJG0kAEm2kv+SbdttSbZJJJIkAG222/+SttttkrZJbZIkSW0A
JEmStv9tkttJbbYkSZIAJG22/9uS27ZttpJJkm0kbUkASSSS/7Zt25JJtm0kkkkAbSTb/7a225KS
tm1tkklJbSQkSQC2/5KS221ttklJkiQkbQD/tgDbkgC2bQCSSQD/ALbbAJK2AG2SAEkAtv8AktsA
bbYASZIAAAAAAADPKgIEAAAEG0lEQVQ4EQEQBO/7Af///wAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAACAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAACAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAIAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAA
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABjmgMdwQiP4QAAAABJ
RU5ErkJggg==}
  image create photo ::apave::bartabs::ImgDelete \
  -data {iVBORw0KGgoAAAANSUhEUgAAABAAAAAQCAYAAAAf8/9hAAADAFBMVEUAAAD/AAAA/wD//wAAAP//
AP8A///////b29u2traSkpJtbW1JSUkkJCTbAAC2AACSAABtAABJAAAkAAAA2wAAtgAAkgAAbQAA
SQAAJADb2wC2tgCSkgBtbQBJSQAkJAAAANsAALYAAJIAAG0AAEkAACTbANu2ALaSAJJtAG1JAEkk
ACQA29sAtrYAkpIAbW0ASUkAJCT/29vbtra2kpKSbW1tSUlJJCT/trbbkpK2bW2SSUltJCT/kpLb
bW22SUmSJCT/bW3bSUm2JCT/SUnbJCT/JCTb/9u227aStpJtkm1JbUkkSSS2/7aS25Jttm1Jkkkk
bSSS/5Jt221JtkkkkiRt/21J20kktiRJ/0kk2yQk/yTb2/+2ttuSkrZtbZJJSW0kJEm2tv+Skttt
bbZJSZIkJG2Skv9tbdtJSbYkJJJtbf9JSdskJLZJSf8kJNskJP///9vb27a2tpKSkm1tbUlJSST/
/7bb25K2tm2SkkltbST//5Lb2222tkmSkiT//23b20m2tiT//0nb2yT//yT/2//bttu2kraSbZJt
SW1JJEn/tv/bktu2bbaSSZJtJG3/kv/bbdu2SbaSJJL/bf/bSdu2JLb/Sf/bJNv/JP/b//+229uS
trZtkpJJbW0kSUm2//+S29tttrZJkpIkbW2S//9t29tJtrYkkpJt//9J29sktrZJ//8k29sk////
27bbtpK2km2SbUltSSRJJAD/tpLbkm22bUmSSSRtJAD/ttvbkra2bZKSSW1tJElJACT/krbbbZK2
SW2SJEltACTbtv+2ktuSbbZtSZJJJG0kAEm2kv+SbdttSbZJJJIkAG222/+SttttkrZJbZIkSW0A
JEmStv9tkttJbbYkSZIAJG22/9uS27ZttpJJkm0kbUkASSSS/7Zt25JJtm0kkkkAbSTb/7a225KS
tm1tkklJbSQkSQC2/5KS221ttklJkiQkbQD/tgDbkgC2bQCSSQD/ALbbAJK2AG2SAEkAtv8AktsA
bbYASZIAAAAAAADPKgIEAAABJklEQVQ4y6VTQUoDQRCsCRJifiFkH7PP8J7es0ev4i34Bb/Q/Q7x
2JEkGzQIijEseEkoL5thdjfJZQcaZpqq6u6amUASfdYAPVcUeA4BAFAUBc2MRVHE1tq5+xoLACAZ
Q0T4O3dys6C7U0QoInR3Hso3blcLighTToO8c6e7E5jQ670nOVXl17psiEQBVSU/FwQmMVJymlPV
KBA9MDPMd3u4Wxwvy3JkWR7P7oZRVcHMznuweXntVD1W/qh9STkDAHgKAdPa2Wo8Ontlfz9bAMA0
wTeqn5r5lCdpF9GDPM9xc33VmbntyRHbeUhmhmo/gOosklMhAFCdYTwcXjbxu1w1Wk1He18uzz+k
h1pMRKiqDWA7d5sUDpd+410IOAB4vIAJfb/zP7R9eKCc1KzuAAAAAElFTkSuQmCC}
}

# ____________________________ Event handlers ___________________________ #

proc ::apave::bartabs::onClickLeftArrow {barID} {

  Bar_ScrollLeft $barID
}

#----------------------------------

proc ::apave::bartabs::onClickRightArrow {barID} {

  Bar_ScrollRight $barID
}

#----------------------------------

proc ::apave::bartabs::onClickTabClose {barID wb1 {chcurr true}} {

  variable batData
  set label [$wb1 cget -text]
  set tabID [tab_IDbyName $barID $label]
  if {[dict exists $batData $barID -cdel]} {
    set com [dict get $batData $barID -cdel]
    set res [{*}[string map [list %b $barID %t $tabID %l $label] $com]]
    if {$res eq "" || !$res} return  ;# chosen to not close
  }
  bar_Clear $barID
  lassign [Bar_GetOptions $barID -tabs -tleft -tright -tabcurr] -> \
    tabs tleft tright tcurr
  set i [Tab_Search $tabID $tabs]
  set tabs [lreplace $tabs $i $i]
  Bar_SetOptions $barID -tabs $tabs
  if {$i>=$tleft && $i<$tright} {
    bar_Refill $barID $tleft true
    set tID [lindex $tabs $i 0]
  } else {
    bar_Refill $barID $tright false
    set tID [lindex $tabs end 0]
  }
  if {$chcurr || $tcurr==$tabID} {tab_Select $tID}
}

#----------------------------------

proc ::apave::bartabs::onEnterTab {wb1 wb2 fgo bgo} {

  $wb1 configure -foreground $fgo -background $bgo
  $wb2 configure -image ::apave::bartabs::ImgDelete
}

#----------------------------------

proc ::apave::bartabs::onLeaveTab {barID wb1 wb2} {

  $wb1 configure \
      -foreground [ttk::style lookup TLabel -foreground] \
      -background [ttk::style lookup TLabel -background]
  Tab_MarkBars $barID
  $wb2 configure -image ::apave::bartabs::ImgNone
}

#----------------------------------

proc ::apave::bartabs::onButtonPress {barID x wb1 wb2} {

  variable batData
  variable PosX
  set PosX $x
  set tabID [tab_IDbyName $barID [$wb1 cget -text]]
  tab_Select $tabID
}

#----------------------------------

proc ::apave::bartabs::onButtonMotion {x wb1 wb2} {

  variable batData
  variable PosX
  if {$PosX eq ""} return
}

#----------------------------------

proc ::apave::bartabs::onButtonRelease {x wb1 wb2} {

  variable batData
  variable PosX
  if {$PosX eq ""} return
  set PosX ""
}

# _________________________ Auxiliary procedures ________________________ #

proc ::apave::bartabs::Aux_InitDraw {barID} {

  # Auxiliary procedure used to initialize the cycles drawing tabs.
  #   barID - ID of the tab's bar

  variable WinWidth
  lassign [Bar_GetOptions $barID -bwidth -tleft -fgover -bgover -hidearrows \
    -tabs -wwid -bd] bwidth1 bwidth2 tleft fgo bgo hidearr tabs wwid bd
  lassign $wwid wframe wlarr wrarr
  if {![string is integer -strict $bwidth2]} {set bwidth2 $bwidth1}
  set arrlen [winfo reqwidth $wlarr]
  set bwidth [expr {$bwidth2<$arrlen ? $WinWidth : min($bwidth2,$WinWidth)}]
  set vislen [expr {$tleft || !$hidearr ? $arrlen : 0}]
  set llen [llength $tabs]
  return [list $tleft $fgo $bgo $hidearr $tabs $arrlen $bwidth $vislen $llen $wframe $bd]
}

#----------------------------------

proc ::apave::bartabs::Aux_CheckTabVisible { \
  wb i tleft trightN vislenN llen hidearr arrlen bd bwidth tabsN tabID text} {

  # Auxiliary procedure used in the cycles drawing tabs.
  #   wb - the tab's frame
  #   i - index of cycle
  #   tleft - left tab's index to be shown
  #   trightN - variable's name of right tab's index to be shown
  #   vislenN - current length of all visible tabs
  #   llen - length of tabs' list
  #   hidearr - flag "hide scrolling arrows"
  #   arrlen - length of scrolling arrow
  #   bd - border of tab
  #   bwidth - width of bar of tabs
  #   tabsN - variable's name of tab list
  #   tabID - the tab's ID
  #   text - the tab's label
  # Returns false, if the tab was destroyed.

  upvar 1 $trightN tright $tabsN tabs $vislenN vislen
  set wb1 $wb.l
  set wb2 $wb.b
  #incr vislen [expr {[winfo reqwidth $wb1] + [winfo reqwidth $wb2]}]
  incr vislen [expr {[winfo reqwidth $wb1] + [winfo reqwidth $wb2]} + $bd]
  if {$i>$tleft && ($vislen+(($i+1)<$llen||!$hidearr?$arrlen:0))>$bwidth} {
    destroy $wb
    lassign "" wb wb1 wb2
  } else {
    set tright $i
  }
  set tabs [lreplace $tabs $i $i [Tab_Info $tabID [list $text $wb $wb1 $wb2]]]
  return [string length $wb]
}

#----------------------------------

proc ::apave::bartabs::Aux_EndDraw {barID tleft tright llen tabs fgo bgo} {

  # Auxiliary procedure used to initialize the cycles drawing tabs.
  #   barID - ID of the tab's bar

  Bar_ArrowsState $barID $tleft [expr {$tright < ($llen-1)}]
  Bar_SetOptions $barID -tabs $tabs -tleft $tleft -tright $tright
  Tab_Bindings $barID $fgo $bgo
  lassign [Bar_GetOptions $barID -tabcurr] -> tabcurr
  Tab_MarkBar $barID $tabcurr
}

# _____________________ Internal procedures for tabs ____________________ #

proc ::apave::bartabs::Tab_Info {tabID tabinfo} {

  # Gets a tab item (ID + data).
  #   tabID - ID of the tab
  #   tabinfo - list of attributes of the tab (text, widgets etc.)
  # Returns a tab item.

  return [list $tabID {*}$tabinfo]
}

#----------------------------------

proc ::apave::bartabs::Tab_Search {tabID tabs} {

  # Searches a tab in the tabs.
  #   tabID - ID of the tab
  #   tabs - list of tabs
  # Returns index of the tab if found or -1 if not found.

  return [lsearch -glob $tabs "$tabID *"]
}

#----------------------------------

proc ::apave::bartabs::Tab_SaveData {barID tabID tabinfo} {

  # Saves data of a tab in batData dictionary.
  #   barID - ID of the tab's bar
  #   tabID - ID of the tab
  #   tabInfo - the tab's data
  # Returns a list containing ID and attributes of the tab.

  variable batData
  set tab [Tab_Info $tabID $tabinfo]
  dict update batData $barID bar {
    dict update bar -tabs tabs {
      if {[set i [Tab_Search $tabID $tabs]] > -1} {
        set tabs [lreplace $tabs $i $i $tab]
      }
    }
  }
  return $tab
}

#----------------------------------

proc ::apave::bartabs::Tab_NewData {barID tabinfo} {

  # Creates data of a new tab.
  #   barID - ID of the new tab's bar
  #   tabInfo - the new tab's data
  # Returns a list containing ID and attributes of the new tab.

  variable batData
  variable NewTabID
  if {[dict exists $batData $barID]} {
    # for sure, the bar is checked for a duplicate of the 'text'
    set text [lindex $tabinfo 0]
    if {[tab_IDbyName $barID $text]>-1} {return ""}
  }
  incr NewTabID
  set tab [Tab_Info $NewTabID $tabinfo]
  return $tab
}

#----------------------------------

proc ::apave::bartabs::Tab_Bindings {barID fgo bgo} {

  # Sets bindings on events of tabs.
  #   barID - ID of the tab's bar

  variable batData
  foreach tab [dict get $batData $barID -tabs] {
    lassign $tab tabID text wb wb1 wb2
    foreach w [list $wb1 $wb2] {
      catch {
        bind $w <Enter> "::apave::bartabs::onEnterTab $wb1 $wb2 $fgo $bgo"
        bind $w <Leave> "::apave::bartabs::onLeaveTab $barID $wb1 $wb2"
        bind $w <ButtonPress> "::apave::bartabs::onButtonPress $barID %x $wb1 $wb2"
        bind $w <ButtonRelease> "::apave::bartabs::onButtonRelease %x $wb1 $wb2"
        bind $w <Motion> "::apave::bartabs::onButtonMotion %x $wb1 $wb2"
      }
    }
  }
}

#----------------------------------

proc ::apave::bartabs::Tab_Create {barID tabID w text} {

  # Creates a tab widget (consisting of a frame, a label, a button).
  #   barID - ID of the tab's bar
  #   tabID - ID of the tab
  #   w - a parent frame's name
  #   text - a text of tab
  # Returns a list of created widgets of the tab (frame, label, button).

  variable NewTabNo
  lassign [Bar_GetOptions $barID -font -relief -bd] -> font relief bd
  set NewTabNo [expr {($NewTabNo+1)%1000000}]
  set wb $w.t[format %09d $tabID]$NewTabNo
  set wb1 $wb.l
  set wb2 $wb.b
  Tab_SaveData $barID $tabID [list $text $wb $wb1 $wb2]
  frame $wb -relief $relief -bd $bd -padx 0 -pady 0
  if {$font ne ""} {set font "-font {$font}"}
  label $wb1 -text $text -relief flat -padx 0 {*}$font
  button $wb2 -image ::apave::bartabs::ImgNone -relief flat -takefocus 0 -padx 0 \
    -command [list ::apave::bartabs::onClickTabClose $barID $wb1]
  return [list $wb $wb1 $wb2]
}

#----------------------------------

proc ::apave::bartabs::Tab_MarkBar {barID {tabID -1}} {

  # Marks the tabs of a bar with color & underlinement.
  #   barID - ID of the bar
  #   tabID - ID of the current tab
  lassign [Bar_GetOptions $barID -tabs -marktabs -fgmark -bgmark -font -tabcurr] \
    -> tabs marktabs fgm bgm font tID
  if {$tabID in {"" "-1"}} {set tabID $tID}
  foreach tab $tabs {
    lassign $tab tID text wb wb1
    if {$wb ne ""} {
      $wb1 configure -font [dict set font -underline [expr {$tID == $tabID}]]
      if {[lsearch $marktabs $tID]>-1} {
        $wb1 configure -foreground $fgm
        if {$bgm ne ""} {$wb1 configure -background $bgm}
      } else {
        $wb1 configure \
          -foreground [ttk::style lookup TLabel -foreground] \
          -background [ttk::style lookup TLabel -background]
      }
    }
  }
  Bar_SetOptions $barID -tabcurr $tabID
}

#----------------------------------

proc ::apave::bartabs::Tab_MarkBars {{barID -1} {tabID -1}} {

  # Marks the tabs with color & underlinement.
  #   barID - ID of the bar (if omitted, all bars are scanned)
  #   tabID - ID of the current tab

  variable batData
  if {$barID == -1} {
    dict for {barID barInfo} $batData {Tab_MarkBar $barID}
  } else {
    Tab_MarkBar $barID $tabID
  }
}

#----------------------------------

proc ::apave::bartabs::Tab_GetOptions {barID tabID args} {

  # Gets options of the tab.
  #   barID - ID of the bar or -1 (to get it by tab_BarID)
  #   tabID - ID of the tab
  #   args - list of option names (-text, -wb, -wb1, -wb2)
  # Return a list of option values.

  set res [list]
  if {$barID<0} {set barID [tab_BarID $tabID]}
  lassign [Bar_GetOptions $barID -tabs] -> tabs
  foreach tab $tabs {
    lassign $tab tID text wb wb1 wb2
    if {$tID==$tabID} {
      foreach opt $args {
        switch $opt {
          -text - -wb - -wb1 - -wb2 {
            lappend res [set [string range $opt 1 end]]
          }
          default {return -code error "Incorrect tab option: $opt"}
        }
      }
      return $res
    }
  }
  return $res
}

# _____________________ Internal procedures for bars ____________________ #

proc ::apave::bartabs::Bar_SaveData {barNewInfo} {

  # Saves data of a new bar in batData dictionary.
  #   barNewInfo - the new bar's data
  # Returns a list containing ID and attributes of the new bar.

  variable batData
  variable NewBarID
  incr NewBarID
  set fgo [ttk::style configure . -selectforeground]
  set bgo [ttk::style configure . -selectbackground]
  set barinfo [dict create \
    -hidearrows false -tleft 0 -tright end -fgover $fgo -bgover $bgo \
    -fgmark #800080 -font "-weight bold -family TkFixedFont -size 11" \
    -relief flat -bd 1]
  set tabinfo [list]
  set tleft 0
  set tright end
  set fgover white
  set bgover green
  foreach {optnam optval} $barNewInfo {
    switch -exact -- $optnam {
      -tleft  { ;# index of left tab
        set tleft $optval
      }
      -tright { ;# index of right tab
        set tright $optval
      }
      -fgover  { ;# foreground color of a tab under mouse
        set fgover $optval
      }
      -bgover  { ;# background color of a tab under mouse
        set bgover $optval
      }
      -tab    { ;# a tab's info is a text
        set found false
        foreach tab $tabinfo {
          if {[lindex $tab 1] eq $optval} {
            set found true ;# no duplicate tabs allowed
            break
          }
        }
        if {!$found} {
          lappend tabinfo [Tab_NewData $NewBarID [list $optval]]
        }
        continue
      }
      -fgmark  { ;# foreground color of a tab marked
      }
      -bgmark  { ;# background color of a tab marked
      }
      -cnew { ;# a command called at creating a new tab
      }
      -cdel { ;# a command called at deleting (closing) a tab
      }
      -csel { ;# a command called at selecting a tab
      }
      -cmov { ;# a command called at moving a tab
      }
      -bwidth { ;# maximum allowed for bar width
      }
      -menu { ;# additional menu items (pairs "label command")
      }
      -hidearrows { ;# true to hide scrolling arrows; false (default) to disable
      }
      -font { ;# font of buttons
      }
      -scrollcurr { ;# if true, a current tab position scrolled
      }
      -relief {  ;# relief of tabs
      }
      -bd {  ;# border of tabs
      }
      -wbar { ;# (inside use) parent widget of the bar
      }
      -wwid { ;# (inside use) widgets of the bar
      }
      default {
        continue  ;# this might return an error instead
      }
    }
    dict set barinfo $optnam $optval
  }
  dict set barinfo -tabs $tabinfo     ;# tabs' info is a last item
  dict set batData $NewBarID $barinfo
  return [list $NewBarID $tleft $tright $fgover $bgover $tabinfo]
}

#----------------------------------

proc ::apave::bartabs::Bar_GetOptions {barID args} {

  # Gets a current width and other options of a bar.
  #   barID - ID of the bar
  #   args - a list of names of options, e.g. {-tleft -wbar -fgover}
  #
  #  Returns a current width of the bar and values of other options.

  variable batData
  lassign [dict get [dict get $batData $barID] -wbar] wbar
  set res [list [winfo width $wbar]]
  foreach opt $args {
    if {[dict exists $batData $barID $opt]} {
      lappend res [dict get $batData $barID $opt]
    } else {
      lappend res ""
    }
  }
  return $res
}

#----------------------------------

proc ::apave::bartabs::Bar_SetOptions {barID args} {

  # Sets values of options of a bar.
  #   barID - ID of the bar
  #   args - a list of pairs "option value", e.g. {{-tleft 1} {-fgover red}}

  variable batData
  foreach {opt val} $args {dict set batData $barID $opt $val}
}

#----------------------------------

proc ::apave::bartabs::Bar_ScrollCurr {barID dir} {

  # Scrolls the current tab the left/right.
  #   barID - ID of the bar
  #   dir - -1 if scrolling to the left; 1 if to the right

  lassign [Bar_GetOptions $barID -scrollcurr -tabcurr -tabs] -> sccur tcurr tabs
  if {$sccur eq "" || !$sccur || $tcurr eq ""} {return false}
  set i 0
  foreach tab $tabs {
    lassign $tab tID text wb
    if {$tID == $tcurr} {
      set it [expr {$i+$dir}]
      if {[lindex $tabs $it 2] ne ""} {  ;# is it a visible tab?
        tab_Select [lindex $tabs $it 0]  ;# yes, set it be current
        return true
      }
      return false
    }
    incr i
  }
  return false
}

#----------------------------------

proc ::apave::bartabs::Bar_ScrollLeft {barID} {

  # Scrolls the bar tabs to the left.
  #   barID - ID of the bar

  variable batData
  if {[Bar_ScrollCurr $barID -1]} return
  lassign [Bar_GetOptions $barID -tleft -tabs -scrollcurr] -> tleft tabs sccur
  set llen [llength $tabs]
  if {![string is integer -strict $tleft]} {set tleft 0}
  for {set i $tleft} {$i && $i<$llen} {incr i} {
    # shift the visible tabs, by one tab to the left
    set i1 [expr {$i-1}]
    set tab1 [lindex $tabs $i1]
    set tab2 [lindex $tabs $i]
    lassign $tab1 ID1 text1
    lassign $tab2 ID2 text2 wb wb1 wb2
    # move widget names from current to previous tab
    set tabs [lreplace $tabs $i1 $i1 [Tab_Info $ID1 [list $text1 $wb $wb1 $wb2]]]
    # remove widget names from the current tab
    set tabs [lreplace $tabs $i $i [Tab_Info $ID2 [list $text2]]]
  }
  if {$tleft && $tleft<$llen} {
    incr tleft -1
    if {$sccur ne "" && $sccur} {tab_Select [lindex $tabs $tleft 0]}
  }
  Bar_SetOptions $barID -tabs $tabs -tleft $tleft
  bar_Redraw $barID
}

#----------------------------------

proc ::apave::bartabs::Bar_ScrollRight {barID} {

  # Scrolls the bar tabs to the right.
  #   barID - ID of the bar

  variable batData
  if {[Bar_ScrollCurr $barID 1]} return
  lassign [Bar_GetOptions $barID -tleft -tright -tabs -scrollcurr] -> \
    tleft tright tabs sccur
  set llen [llength $tabs]
  if {![string is integer -strict $tleft]} {set tleft 0}
  if {![string is integer -strict $tright]} {set tright $llen}
  for {set i $tright} {$i>=$tleft && $i<($llen-1)} {incr i -1} {
    # shift the visible tabs, by one tab to the right
    set i2 [expr {$i+1}]
    set tab1 [lindex $tabs $i]
    set tab2 [lindex $tabs $i2]
    lassign $tab1 ID1 text1 wb wb.l wb.b
    lassign $tab2 ID2 text2
    # move widget names from current to next tab
    set tabs [lreplace $tabs $i2 $i2 [Tab_Info $ID2 [list $text2 $wb $wb.l $wb.b]]]
    # remove widget names from the current tab
    set tabs [lreplace $tabs $i $i [Tab_Info $ID1 [list $text1]]]
  }
  if {$tleft<($llen-1)} {incr tleft; incr tright}
  Bar_SetOptions $barID -tabs $tabs -tleft $tleft -tright $tright
  bar_Redraw $barID
  if {$sccur ne "" && $sccur} {
    # 'tright' may be corrected in bar_Redraw
    lassign [Bar_GetOptions $barID -tright] -> tright
    tab_Select [lindex $tabs $tright 0]
  }
}

#----------------------------------

proc ::apave::bartabs::Bar_ArrowsState {barID sleft sright} {

  # Sets a state of scrolling arrows.
  #   barID - ID of the bar
  #   sleft - state of a left arrow (false for "disabled")
  #   sright - state of a right arrow (false for "disabled")

  variable batData
  lassign [Bar_GetOptions $barID -wwid -hidearrows] -> wwid hidearr
  lassign $wwid wframe wlarr wrarr
  if {$sleft} {
    if {$hidearr} {
      if {[catch {pack $wlarr -before $wframe -side left}]} {
        pack $wlarr -side left
      }
    } else {
      $wlarr configure -state normal
    }
  } else {
    if {$hidearr} {
      pack forget $wlarr
    } else {
      $wlarr configure -state disabled
    }
  }
  if {$sright} {
    if {$hidearr} {
      if {[catch {pack $wrarr -after $wframe -side right -anchor e}]} {
        pack $wrarr -side right -anchor e
      }
    } else {
      $wrarr configure -state normal
    }
  } else {
    if {$hidearr} {
      pack forget $wrarr
    } else {
      $wrarr configure -state disabled
    }
  }
}

#----------------------------------

proc ::apave::bartabs::bar_FillFromLeft {barID {ileft ""} {tright "end"}} {

  # Fills a bar with tabs from the left to the right (as much tabs as possible).
  #   barID - ID of the bar
  #   ileft - index of a left tab
  #   tright - index of a right tab

  variable batData
  variable WinWidth
  lassign [Aux_InitDraw $barID] tleft fgo bgo hidearr tabs arrlen bwidth vislen llen wframe bd
  if {$ileft ne ""} {set tleft $ileft}
  for {set n $tleft} {$n<$llen} {incr n} {
    lassign [lindex $tabs $n] tabID text
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    if {[Aux_CheckTabVisible $wb $n $tleft tright vislen \
    $llen $hidearr $arrlen $bd $bwidth tabs $tabID $text]} {
      pack $wb1 $wb2 -side left
      pack $wb -side left
    }
  }
  Aux_EndDraw $barID $tleft $tright $llen $tabs $fgo $bgo
}

#----------------------------------

proc ::apave::bartabs::bar_FillFromRight {barID {tleft 0} {tright "end"}} {

  # Fills a bar with tabs from the right to the left (as much tabs as possible).
  #   barID - ID of the bar
  #   tleft - index of a left tab
  #   tright - index of a right tab

  variable batData
  variable WinWidth
  lassign [Aux_InitDraw $barID] tleft fgo bgo hidearr tabs arrlen bwidth vislen llen wframe bd
  if {$tright eq "end" || $tright>=$llen} {set tright [expr {$llen-1}]}
  for {set n $tright} {$n>=0} {incr n -1} {
    lassign [lindex $tabs $n] tabID text
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    incr vislen [expr {[winfo reqwidth $wb1] + [winfo reqwidth $wb2] + $bd*2}]
    if {$n<$tright && ($vislen+($n||!$hidearr?$arrlen:0))>$bwidth} {
      destroy $wb
      lassign "" wb wb1 wb2
    } else {
      set tleft $n
    }
    set tabs [lreplace $tabs $n $n [Tab_Info $tabID [list $text $wb $wb1 $wb2]]]
  }
  for {set n $tleft} {$n<$llen} {incr n} {
    lassign [lindex $tabs $n] tabID text wb wb1 wb2
    if {$wb ne ""} {
      pack $wb1 $wb2 -side left
      pack $wb -side left
    }
  }
  Aux_EndDraw $barID $tleft $tright $llen $tabs $fgo $bgo
}

#----------------------------------

proc ::apave::bartabs::bar_Refill {barID itab left} {

  # Fills a bar with tabs.
  #   barID - ID of the bar
  #   itab - index of tab
  #   left - if true, the bar is filled from the left to the right

  variable batData
  lassign [Bar_GetOptions $barID -fgover -bgover] -> fgo bgo
  bar_Clear $barID
  if {$left} {
    bar_FillFromLeft $barID $itab
  } else {
    bar_FillFromRight $barID 0 $itab
  }
}

# ____________________ Interface procedures for bars ____________________ #

proc ::apave::bartabs::bar_Remove {barID} {

  # Removes a bar info from batData dictionary and destroys its widgets.
  #   barID - the bar's ID
  # Returns true, if the bar was successfully removed.

  variable batData
  if {[dict exists $batData $barID]} {
    set bar [dict get $batData $barID]
    catch {
      foreach wb [dict get $bar -wwid] {destroy $wb}
    }
    dict unset batData $barID
    return true
  }
  return false
}

#----------------------------------

proc ::apave::bartabs::bar_Clear {barID} {

  # Destroys the current shown tabs of a bar.
  #   barID - ID of the bar to be cleared

  variable batData
  dict update batData $barID bar {
    dict update bar -tabs tabs {
      set i 0
      foreach tab $tabs {
        lassign $tab tabID text wtab
        if {$wtab ne "" && [winfo exists $wtab]} {destroy $wtab}
        set tabs [lreplace $tabs $i $i [Tab_Info $tabID [list $text]]]
        incr i
      }
    }
  }
}

#----------------------------------

proc ::apave::bartabs::bar_Create {barInfo} {

  # Creates a tab bar.
  #   barInfo - a list of bars' data
  # Returns ID of the tab created

  variable WinWidth
  set w [dict get $barInfo -wbar] ;# parent window (a frame, most likely)
  set wframe $w.frame ;# frame for tabs
  set wlarr $w.larr   ;# left scrolling button
  set wrarr $w.rarr   ;# right scrolling button
  lappend barInfo -wwid [list $wframe $wlarr $wrarr]
  lassign [Bar_SaveData $barInfo] barID tleft tright fgo bgo tabinfo
  lassign [Bar_GetOptions $barID -bwidth] -> bwidth
  button $wlarr -image ::apave::bartabs::ImgLeftArr \
    -command [list ::apave::bartabs::onClickLeftArrow $barID] \
    -relief flat -highlightthickness 0 -takefocus 0
  button $wrarr -image ::apave::bartabs::ImgRightArr \
    -command [list ::apave::bartabs::onClickRightArrow $barID] \
    -relief flat -highlightthickness 0 -takefocus 0
  ttk::frame $wframe -relief flat
  pack $wlarr -side left -padx 0 -pady 0
  pack $wframe -after $wlarr -side left -padx 0 -pady 0
  pack $wrarr -after $wframe -side right -padx 0 -pady 0 -anchor e
}

#----------------------------------

proc ::apave::bartabs::bar_Redraw {barID {doupdate true}} {

  # Draws the bar tabs. Used at changing their contents.
  #   barID - ID of the bar
  #   doupdate - if true, performs 'update' before redrawing

  variable batData
  variable WinWidth
  if {$doupdate} update
  lassign [Aux_InitDraw $barID] tleft fgo bgo hidearr tabs arrlen bwidth vislen llen wframe bd
  for {set i [set tright $tleft]} {$i<$llen} {incr i} {
    set tab [lindex $tabs $i]
    lassign $tab tabID text wb wb1 wb2
    if {$wb eq ""} {
      lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    } else {
      $wb1 configure -text $text
    }
    if {[Aux_CheckTabVisible $wb $i $tleft tright vislen $llen $hidearr $arrlen $bd $bwidth tabs $tabID $text]} {
      pack $wb1 $wb2 -side left
      pack $wb -side left
    }
  }
  Aux_EndDraw $barID $tleft $tright $llen $tabs $fgo $bgo
}

#----------------------------------

proc ::apave::bartabs::bar_RedrawAll {} {

  # Redraws all tab bars.

  variable batData
  variable WinWidth
  update ;# to get real widths of bar frames
  if {$WinWidth<0} {
    after idle {bind . <Configure> {+ ::apave::bartabs::bar_NeedRedrawAll}}
  }
  set WinWidth [winfo width .]
  dict for {barID barInfo} $batData {bar_Redraw $barID false}
}

#----------------------------------

proc ::apave::bartabs::bar_NeedRedrawAll {} {

  # Checks for resizing the window and redraws all bars, if needed.

  variable WinWidth
  set ww [winfo width .]
  if {$ww != $WinWidth} {
    set WinWidth $ww
    bar_RedrawAll
  }
  
}

# ____________________ Interface procedures for tabs ____________________ #

proc ::apave::bartabs::tab_BarID {tabID} {

  # Gets barID from tabID.
  #   tabID - ID of a tab
  # Returns a list containing 1) bar's ID (or -1 if no bar found) 2) tabs' list
  # of the bar 3) index of the tab in tabs' list.

  variable batData
  set barID -1
  dict for {bID bInfo} $batData {
    lassign [Bar_GetOptions $bID -wwid -tabs -tleft -tright -csel] -> \
      wwid tabs tleft tright csel
    if {[set i [Tab_Search $tabID $tabs]] > -1} {
      set barID $bID
      set w [lindex $wwid 0]
      break
    }
  }
  if {$barID < 0} {
    return -code error "bartabs: tab ID $tabID not found in the bars"
  }
  return [list $barID $tabs $i]
}

#----------------------------------

proc ::apave::bartabs::tab_Select {tabID} {

  # Selects a tab, i.e. makes the tab to be current.
  #   tabID - ID of the tab

  if {$tabID eq ""} return
  set barID [lindex [tab_BarID $tabID] 0]
  Tab_MarkBar $barID $tabID
  lassign [Bar_GetOptions $barID -csel] -> csel
  if {$csel ne ""} {
    lassign [Tab_GetOptions $barID $tabID -text] text
    {*}[string map [list %b $barID %t $tabID %l $text] $csel]
  }
}

#----------------------------------

proc ::apave::bartabs::tab_Mark {args} {

  # Marks tab(s) in a bar.
  #   args - list of ID of tabs to be marked

  foreach tabID $args {
    set barID [lindex [tab_BarID $tabID] 0]
    lassign [Bar_GetOptions $barID -marktabs] -> marktabs
    if {[lsearch $marktabs $tabID]<0} {
      lappend marktabs $tabID
      Bar_SetOptions $barID -marktabs $marktabs
    }
  }
  Tab_MarkBars
}

#----------------------------------

proc ::apave::bartabs::tab_UnMark {args} {

  # Unmarks tab(s) in a bar.
  #   args - list of ID of tabs to be unmarked

  foreach tabID $args {
    set barID [lindex [tab_BarID $tabID] 0]
    lassign [Bar_GetOptions $barID -marktabs] -> marktabs
    if {[set i [lsearch $marktabs $tabID]]>=0} {
      Bar_SetOptions $barID -marktabs [lreplace $marktabs $i $i]
    }
  }
  Tab_MarkBars
}

#----------------------------------

proc ::apave::bartabs::tab_Show {tabID} {

  # Shows a tab in a bar and sets it as current.
  #   tabID - ID of the tab

  lassign [tab_BarID $tabID] barID tabs
  # check if the tab is visible or left or right from visible range
  set vis [set fill [set itab 0]]
  foreach tab $tabs {
    lassign $tab tID text wb
    if {$tabID==$tID} {
      if {$wb ne ""} {  ;# it is visible
      } elseif {$vis} {
        set fill 1      ;# not visible, at right from visible range
      } else {
        set fill 2      ;# not visible, at left from visible range
      }
      break
    }
    incr itab
    if {$wb ne ""} {set vis true}
  }
  if {$fill} {
    bar_Refill $barID $itab [expr {$fill==2}]
  }
  tab_Select $tabID
}

#----------------------------------

proc ::apave::bartabs::tab_IDbyName {barID text} {

  # Searches for a tab ID by its text.
  #   barID - ID of the tab's bar
  #   text - a text of tab
  # Returns the tab's ID (if found) or -1 (if not).

  variable batData
  foreach tab [dict get $batData $barID -tabs] {
    lassign $tab tID ttxt
    if {$text eq $ttxt} {return $tID}
  }
  return -1
}

#----------------------------------

proc ::apave::bartabs::tab_Close {tabID} {

  # Closes a tab.
  #   tabID - ID of the tab

  lassign [tab_BarID $tabID] barID tabs i
  onClickTabClose $barID [lindex $tabs $i 3] false
}

#----------------------------------

proc ::apave::bartabs::tab_Insert {barID txt {pos "end"}} {

  # Insert a tab into a bar.
  #   barID - ID of the bar
  #   txt - text of the tab
  #   pos - position of the tab in the tabs' list (e.g. 0, end)
  # Returns ID of the created tab.

  lassign [Bar_GetOptions $barID -tabs] -> tabs
  set tab [Tab_NewData $barID [list $txt]]
  if {$pos eq "end"} {
    set tabs [lappend tabs $tab]
  } else {
    set tabs [linsert $tabs $pos $tab]
  }
  Bar_SetOptions $barID -tabs $tabs
  bar_Refill $barID $pos [expr {$pos ne "end"}]
}

#----------------------------------

proc ::apave::bartabs::tab_List {barID} {

  # Gets a list of bar's tabs with flags "visible", "marked"
  #   barID - ID of the bar
  # Returns a list of items "tab ID, tab text, visible, marked".

  lassign [Bar_GetOptions $barID -tabs -marktabs] -> tabs marktabs
  set res [list]
  foreach tab $tabs {
    lassign $tab tabID text wb
    set visible [expr {$wb ne ""}]
    set marked [expr {[lsearch $marktabs $tabID]>=0}]
    lappend res [list $tabID $text $visible $marked]
  }
  return $res
}
# _________________________________ EOF _________________________________ #

#RUNF0: ./test.tcl     ;# to test from e_menu without switching to test.tcl
