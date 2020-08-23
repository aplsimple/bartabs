# _______________________________________________________________________ #
#
# The tab bar widget.
#
# Scripted by Alex Plotnikov (aplsimple@gmail.com).
# License: MIT.
# _______________________________________________________________________ #

package require Tk
package provide bartabs 1.0a2
catch {package require tooltip} ;# optional (though necessary everywhere:)

# ______________________ Common data of bartabs _________________________ #

namespace eval ::bartabs {

  variable btData [dict create]
  variable NewBarID 0 NewTabID 0 NewTabNo 0
  image create photo ::bartabs::ImgLeftArr \
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
  image create photo ::bartabs::ImgRightArr \
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
  image create photo ::bartabs::ImgNone \
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
  image create photo ::bartabs::ImgClose \
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
bbYASZIAAAAAAADPKgIEAAABHUlEQVQ4y6VTQUoDQRCsXpO4bkDPEUmibO75hIjP8O4DPOYq3oJf
8Au7P8gDguKhWwTjQQWjmAFREtpLdpzJZhdlGxqGoat6qrqHVBVVIkDFsARXRH8GDZxaWpXwcSe6
3axBzBxxHBMAiIgebAaYaYCddpcKJcxE9EUBah0iA4qIAsBG+wijm1u8Pk78jqr6m8/3CsQ2mVmZ
OXfnYjwJWbde73itduYUoTHY6/ep0IOn8bWaKMyRMKdoAmgtffE8uHRcNVFY6P7n27s9ny4x/5YA
wE4nN4X9rZoHZk4tqIjYIzDzAEky9Lq55yQZImo0PIKcidPJg06/vr2nZtKieh27nQ6t3YPz1Z0o
yROnlsp+4xkRFgAuSmqo6nf+ATq/yK22zWynAAAAAElFTkSuQmCC}
}

# ____________________________ Event handlers ___________________________ #

proc ::bartabs::onClickLeftArrow {barID} {

  Bar_ScrollLeft $barID
}

#----------------------------------

proc ::bartabs::onClickRightArrow {barID} {

  Bar_ScrollRight $barID
}

#----------------------------------

proc ::bartabs::onClickClose {barID wb1 {chcurr yes} {tabID -1}} {

  variable btData
  if {$tabID==-1} {
    set label [$wb1 cget -text]
    set tabID [tab_IDbyName $barID $label]
  } else {
    lassign [tab_Cget $tabID -text] label
  }
  if {![Bar_Command $barID $tabID -cdel]} {return no} ;# chosen to not close
  bar_Clear $barID
  lassign [bar_Cget $barID -TABS -tleft -tright -TABCURR] tabs tleft tright tcurr
  set i [Tab_Search $tabID $tabs]
  set tabs [lreplace $tabs $i $i]
  bar_Configure $barID -TABS $tabs
  if {$i>=$tleft && $i<$tright} {
    bar_Refill $barID $tleft yes
    set tID [lindex $tabs $i 0]
  } else {
    bar_Refill $barID $tright no
    set tID [lindex $tabs end 0]
  }
  if {$chcurr || $tcurr==$tabID} {tab_Select $tID}
  return yes
}

#----------------------------------

proc ::bartabs::onEnterTab {static wb1 wb2 fgo bgo} {

  $wb1 configure -foreground $fgo -background $bgo
  if {!$static} {
    $wb2 configure -image ::bartabs::ImgClose
  }
}

#----------------------------------

proc ::bartabs::onLeaveTab {barID wb1 wb2} {

  $wb1 configure \
      -foreground [ttk::style lookup TLabel -foreground] \
      -background [ttk::style lookup TLabel -background]
  Tab_MarkBars $barID
  $wb2 configure -image ::bartabs::ImgNone
}

#----------------------------------

proc ::bartabs::onButtonPress {barID x wb1} {

  set wbar [bar_Cget $barID -wbar]
  bar_Configure $barID -MOVX $x
  set tabID [tab_IDbyName $barID [$wb1 cget -text]]
  tab_Select $tabID
}

#----------------------------------

proc ::bartabs::onButtonMotion {barID x y w wb wb1} {

  lassign [bar_Cget $barID -static \
    -FGOVER -BGOVER -MOVWIN -MOVX -MOVX0 -MOVY0] \
    static fgo bgo movWin movX movx movY0
  if {$movX eq "" || $w ne $wb1 || $static} return
  # dragging the tab
  if {![winfo exists $movWin]} {
    # make the tab's replica to be dragged
    toplevel $movWin
    if {[tk windowingsystem] eq "aqua"} {
      ::tk::unsupported::MacWindowStyle style $movWin help none
    } else {
      wm overrideredirect $movWin 1
    }
    set movx [set movx1 $x]
    set movX [expr {[winfo pointerx .]-$x}]
    set movY0 [expr {[winfo pointery .]-$y}]
    label $movWin.label -text [$wb1 cget -text] \
      -foreground $fgo -background $bgo  {*}[Tab_Font $barID]
    pack $movWin.label -ipadx 1
    $wb1 configure -foreground [ttk::style lookup TLabel -background]
    ::bartabs::bar_Configure $barID -wb1 $wb1 -MOVX1 $movx1 -MOVY0 $movY0
  }
  wm geometry $movWin +$movX+$movY0
  bar_Configure $barID -MOVX [expr {$movX+$x-$movx}] -MOVX0 $x
}

#----------------------------------

proc ::bartabs::onButtonRelease {barID x w} {

  lassign [bar_Cget $barID \
    -MOVWIN -MOVX -MOVX1 -MOVY0 -wb1 -TABS -tleft -tright -wbar -static] \
    movWin movX movx1 movY0 wb1 tabs tleft tright wbar static
  bar_Configure $barID -MOVX "" -wb1 ""
  if {[winfo exists $movWin]} {destroy $movWin}
  if {$movX eq "" || $w ne $wb1 || $static} return
  # dropping the tab to a new position
  $wb1 configure -foreground [ttk::style lookup TLabel -foreground]
  # find a tab where the button was released
  lassign [Aux_InitDraw $barID] bwidth vislen bd arrlen llen
  set vislen1 $vislen
  set vlist [list]
  set i 0
  set iw1 -1
  foreach tab $tabs {
    lassign $tab tID text _wb _wb1 _wb2
    if {$_wb ne ""} {
      if {$_wb1 eq $wb1} {
        set vislen0 $vislen
        set tab1 $tab
        set iw1 $i
        set tabID $tID
      }
      set wl [expr {[winfo reqwidth $_wb1]+[winfo reqwidth $_wb2]}]
      lappend vlist [list $i $vislen $wl]
      incr vislen $wl
    }
    incr i
  }
  if {$iw1==-1} return  ;# for sure
  if {![Bar_Command $barID $tabID -cmov]} return ;# chosen to not move
  set tabssav $tabs
  set vislen2 [expr {$vislen0+$x-$movx1}]
  foreach vl $vlist {
    lassign $vl i vislen wl
    set rightest [expr {$i==$tright && $vislen2>(10+$vislen)}]
    if {$iw1==($i+1) && $x<0} {incr vislen2 $wl}
    if {($vislen>$vislen2 || $rightest)} {
      set tabs [lreplace $tabs $iw1 $iw1]
      set i [expr {$rightest||$iw1>$i?$i:$i-1}]
      if {$rightest && $i<($llen-1) && $i==$iw1} {incr i}
      set tabs [linsert $tabs $i $tab1]
      set left yes
      if {$rightest} {
        set left no
        set tleft $i
      } elseif {$i<$tleft} {
        set tleft $i
      }
      break
    }
  }
  if {$tabssav ne $tabs} {
    bar_Configure $barID -TABS $tabs
    bar_Refill $barID $tleft $left
  }
}

#----------------------------------

proc ::bartabs::onPopup {barID tabID X Y} {

  lassign [bar_Cget $barID \
    -wbar -menu -TABS -FGOVER -BGOVER -fgmark -bgmark -marktabs -static] \
    wbar popup tabs fgo bgo fgmark bgmark marktabs static
  set textcur [tab_Cget $tabID -text]
  set pop $wbar.popupMenu
  if {[winfo exist $pop]} {destroy $pop}
  menu $pop -tearoff 0
  foreach p $popup {
    lassign $p typ label comm menu dsbl
    set label [string map [list %l $textcur] $label]
    set comm [string map [list %b $barID %t $tabID] $comm]
    switch [string index $typ 0] {
      "s" {$pop add separator}
      "c" {
        if {([info commands $dsbl] ne "" && [$dsbl $tabID $label]) || \
        ([string is boolean -strict $dsbl] && $dsbl)} {
          set dsbl "-state disabled"
        } else {
          set dsbl ""
        }
        $pop add command -label $label -command $comm {*}$dsbl
      }
      "m" {
        menu $pop.$menu -tearoff 0
        $pop add cascade -label $label -menu $pop.$menu
        if {$menu eq "bartabs_cascade"} {
          foreach tab $tabs {
            lassign $tab tID text
            if {$tID==$tabID} {set fg "-foreground $fgo -background $bgo"
            } else            {set fg ""}
            append fg [Tab_MarkAttrs $barID $tID]
            $pop.$menu add command -label $text -command \
              "::bartabs::tab_Show $tID" {*}$fg
          }
        }
      }
    }
  }
  tk_popup $pop $X $Y
}

# _________________________ Auxiliary procedures ________________________ #

proc ::bartabs::Aux_WidgetWidth {w} {

  # Calculates the width of a widget
  #   w - the widget's path

  if {![winfo exists $w]} {return 0}
  set wwidth [winfo width $w]
  if {$wwidth<2} {set wwidth [winfo reqwidth $w]}
  return $wwidth
}

#----------------------------------

proc ::bartabs::Aux_InitDraw {barID} {

  # Auxiliary procedure used before the cycles drawing tabs.
  #   barID - ID of the tab's bar

  set fgo [ttk::style configure . -selectforeground]
  set bgo [ttk::style configure . -selectbackground]
  bar_Configure $barID -FGOVER $fgo -BGOVER $bgo  ;# the options may be themed
  lassign [bar_Cget $barID \
    -WNEED -tleft -hidearrows -TABS -WWID -BD -wbase -wbar -ARRLEN] \
    bwidth tleft hidearr tabs wwid bd wbase wbar arrlen
  lassign $wwid wframe wlarr
  if {$arrlen eq ""} {
    set arrlen [winfo reqwidth $wlarr]
    bar_Configure $barID -wbase $wbase -ARRLEN $arrlen
    if {$wbase eq ""} {set wbase .}
    bar_Configure $barID -WNEED $bwidth
    bind $wbase <Configure> [list + ::bartabs::bar_NeedRedraw $barID]
  }
  set bwidth [Bar_Width $barID]
  set vislen [expr {$tleft || !$hidearr ? $arrlen : 0}]
  set llen [llength $tabs]
  return [list $bwidth $vislen $bd $arrlen $llen $tleft $fgo $bgo $hidearr $tabs $wframe]
}

#----------------------------------

proc ::bartabs::Aux_CheckTabVisible { \
  wb wb1 wb2 i tleft trightN vislenN llen hidearr arrlen bd bwidth tabsN tabID text} {

  # Auxiliary procedure used in the cycles drawing tabs.
  #   wb - the tab's frame
  #   wb1 - the tab's label
  #   wb2 - the tab's button
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
  # Returns "no", if the tab was destroyed.

  upvar 1 $trightN tright $tabsN tabs $vislenN vislen
  incr vislen [tab_Cget $tabID -width]
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

proc ::bartabs::Aux_EndDraw {barID tleft tright llen tabs fgo bgo} {

  # Auxiliary procedure used after the cycles drawing tabs.
  #   barID - ID of the tab's bar

  Bar_ArrowsState $barID $tleft [expr {$tright < ($llen-1)}]
  bar_Configure $barID -TABS $tabs -tleft $tleft -tright $tright
  Tab_Bindings $barID $fgo $bgo
  set tabcurr [bar_Cget $barID -TABCURR]
  Tab_MarkBar $barID $tabcurr
}

# _____________________ Internal procedures for tabs ____________________ #

proc ::bartabs::Tab_Create {barID tabID w text} {

  # Creates a tab widget (consisting of a frame, a label, a button).
  #   barID - ID of the tab's bar
  #   tabID - ID of the tab
  #   w - a parent frame's name
  #   text - a text of tab
  # Returns a list of created widgets of the tab (frame, label, button).

  variable NewTabNo
  lassign [bar_Cget $barID -relief -BD] relief bd
  set NewTabNo [expr {($NewTabNo+1)%1000000}]
  set wb $w.t[format %09d $tabID]$NewTabNo
  set wb1 $wb.bartabsL
  set wb2 $wb.bartabsB
  Tab_SaveData $barID $tabID [list $text $wb $wb1 $wb2]
  set bg [. cget -background]
  ttk::frame $wb -relief $relief -borderwidth $bd
  label $wb1 -relief flat -padx 0 {*}[Tab_Font $barID]
  ttk::button $wb2 -style ClButton$barID -image ::bartabs::ImgNone \
    -command [list ::bartabs::onClickClose $barID $wb1] -takefocus 0
  Tab_SetAttrs $barID $wb1 $wb2 $text
  return [list $wb $wb1 $wb2]
}

#----------------------------------

proc ::bartabs::Tab_Label {label} {

  # Prepares a label to be shown in a tab (excludes special characters).
  #   label - a tab's label

  return [string map {\" \'} $label]
}

#----------------------------------

proc ::bartabs::Tab_Info {tabID tabinfo} {

  # Gets a tab item (ID + data).
  #   tabID - ID of the tab
  #   tabinfo - list of attributes of the tab (text, widgets etc.)
  # Returns a tab item.

  return [list $tabID {*}$tabinfo]
}

#----------------------------------

proc ::bartabs::Tab_Search {tabID tabs} {

  # Searches a tab in the tabs.
  #   tabID - ID of the tab
  #   tabs - list of tabs
  # Returns index of the tab if found or -1 if not found.

  return [lsearch -glob $tabs "$tabID *"]
}

#----------------------------------

proc ::bartabs::Tab_SaveData {barID tabID tabinfo} {

  # Saves data of a tab in btData dictionary.
  #   barID - ID of the tab's bar
  #   tabID - ID of the tab
  #   tabInfo - the tab's data
  # Returns a list containing ID and attributes of the tab.

  variable btData
  set tab [Tab_Info $tabID $tabinfo]
  dict update btData $barID bar {
    dict update bar -TABS tabs {
      if {[set i [Tab_Search $tabID $tabs]] > -1} {
        set tabs [lreplace $tabs $i $i $tab]
      }
    }
  }
  return $tab
}

#----------------------------------

proc ::bartabs::Tab_NewData {barID tabinfo} {

  # Creates data of a new tab.
  #   barID - ID of the new tab's bar
  #   tabInfo - the new tab's data
  # Returns a list containing ID and attributes of the new tab.

  variable btData
  variable NewTabID
  if {[dict exists $btData $barID]} {
    # for sure, the bar is checked for a duplicate of the 'text'
    set text [lindex $tabinfo 0]
    if {[tab_IDbyName $barID $text]>-1} {return ""}
  }
  incr NewTabID
  set tab [Tab_Info $NewTabID $tabinfo]
  return $tab
}

#----------------------------------

proc ::bartabs::Tab_Bindings {barID fgo bgo} {

  # Sets bindings on events of tabs.
  #   barID - ID of the tab's bar

  lassign [bar_Cget $barID -TABS -static] tabs static
  foreach tab $tabs {
    lassign $tab tabID text wb wb1 wb2
    foreach w [list $wb1 $wb2] {
      catch {
        bind $w <Enter> "::bartabs::onEnterTab $static $wb1 $wb2 $fgo $bgo"
        bind $w <Leave> "::bartabs::onLeaveTab $barID $wb1 $wb2"
        bind $w <ButtonPress> "::bartabs::onButtonPress $barID %x $wb1"
        bind $w <ButtonRelease> "::bartabs::onButtonRelease $barID %x $w"
        bind $w <Motion> "::bartabs::onButtonMotion $barID %x %y $w $wb $wb1"
        bind $w <Button-3>  "::bartabs::onPopup $barID $tabID %X %Y"
      }
    }
  }
}

#----------------------------------

proc ::bartabs::Tab_Font {barID} {

  # Gets a font option for a tab label.
  #   barID - ID of the bar

  set font [bar_Cget $barID -font]
  if {$font eq ""} {
    if {[set font [ttk::style configure TLabel -font]] eq ""} {
      set font TkDefaultFont
    }
    set font [font configure $font]
  }
  return "-font {$font}"
}

#----------------------------------

proc ::bartabs::Tab_MarkAttrs {barID tabID} {

  # Gets attributes of marks.
  #   barID - ID of the bar
  #   tabID - ID of the current tab
  # Returns attributes of marks or empty string.

  lassign [bar_Cget $barID -MARKTABS -fgmark -bgmark] marktabs fgm bgm
  set res ""
  if {[lsearch $marktabs $tabID]>-1} {
    set res " -foreground $fgm"
    if {$bgm ne ""} {append res " -background $bgm"}
  }
  return $res
}

#----------------------------------

proc ::bartabs::Tab_MarkBar {barID {tabID -1}} {

  # Marks the tabs of a bar with color & underlining.
  #   barID - ID of the bar
  #   tabID - ID of the current tab

  lassign [bar_Cget $barID -TABS -MARKTABS -fgmark -bgmark -TABCURR] \
    tabs marktabs fgm bgm tID
  if {$tabID in {"" "-1"}} {set tabID $tID}
  foreach tab $tabs {
    lassign $tab tID text wb wb1
    if {$wb ne ""} {
      set font [Tab_Font $barID]
      if {$tID == $tabID} {
        lassign $font opt val
        set val [dict set val -underline 1]
        set font "$opt {$val}"
      }
      $wb1 configure {*}$font
      if {[set attrs [Tab_MarkAttrs $barID $tID]] ne ""} {
        $wb1 configure {*}$attrs
      } else {
        $wb1 configure \
          -foreground [ttk::style lookup TLabel -foreground] \
          -background [ttk::style lookup TLabel -background]
      }
    }
  }
  bar_Configure $barID -TABCURR $tabID
}

#----------------------------------

proc ::bartabs::Tab_MarkBars {{barID -1} {tabID -1}} {

  # Marks the tabs with color & underlinement.
  #   barID - ID of the bar (if omitted, all bars are scanned)
  #   tabID - ID of the current tab

  variable btData
  if {$barID == -1} {
    dict for {barID barInfo} $btData {Tab_MarkBar $barID}
  } else {
    Tab_MarkBar $barID $tabID
  }
}

#----------------------------------

proc ::bartabs::Tab_SetAttrs {barID wb1 wb2 text} {

  # Sets a tab's state and label, possibly ellipsed and tooltipped.
  #   barID - ID of the bar
  #   wb1 - tab label's path
  #   wb2 - tab button's path
  #   text - text of tab label
  # If a limit of text length is set with option -maxlen, the text is
  # ellipsed: its part above the limit is replaced with ellipse character.
  # Also, a tooltip is set for an ellipsed label.

  lassign [bar_Cget $barID -maxlen -ELLIPSE] maxlen ellipse
  if {$maxlen && [string length $text]>$maxlen} {
    set ttip $text
    set text [string range $text 0 $maxlen-1]
    append text $ellipse
  } else {
    set ttip ""
  }
  catch {tooltip::tooltip $wb1 $ttip}
  $wb1 configure -text $text
  if {[bar_Cget $barID -static]} {
    $wb2 configure -state disabled -image {} -compound text
  }
}

# _____________________ Internal procedures for bars ____________________ #

proc ::bartabs::Bar_Data {barNewInfo} {

  # Saves data of a new bar in btData dictionary.
  #   barNewInfo - the new bar's data
  # Returns ID of the new bar.

  variable btData
  variable NewBarID
  incr NewBarID
  # create a dictionary of bar data with default settings
  set barinfo [dict create \
    -static no -hidearrows no -tleft 0 -tright end \
    -fgmark #800080 -font "" -relief groove -maxlen 0 -scrollsel 0 \
    -BD 2 -ELLIPSE "\u2026" -MOVX "" -MOVY0 "" -MOVX1 "" -MOVWIN ".bt_move"]
  set tabinfo [set popup [list]]
  Bar_PopupInfo $NewBarID popup
  foreach {optnam optval} $barNewInfo {
    switch -exact -- $optnam {
      -tab    { ;# a tab's info is a text
        set found no
        set optval [Tab_Label $optval]
        # check for duplicates: no duplicate tabs allowed
        if {[lsearch -index 1 -exact $tabinfo $optval]==-1} {
          lappend tabinfo [Tab_NewData $NewBarID [list $optval]]
        }
        continue
      }
      -menu {
        lappend popup {*}$optval
      }
      -tleft  { ;# index of left tab
      }
      -tright { ;# index of right tab
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
      -hidearrows { ;# "yes" to hide scrolling arrows; "no" (default) to disable
      }
      -font { ;# font of buttons
      }
      -scrollsel { ;# if "yes", a current tab position scrolled
      }
      -relief {  ;# relief of tabs
      }
      -static {  ;# to disable "Close"
      }
      -wbar { ;# parent widget of the bar
      }
      -wbase { ;# base widget to get the bartabs' width
      }
      -maxlen { ;# maximum of tab label's length
      }
      #-BD {  ;# tab's border (inside use)
      #}
      -WWID { ;# tab's widgets (inside use)
      }
      default {
        return -code error "bartabs: incorrect option $optnam"
      }
    }
    dict set barinfo $optnam $optval
  }
  dict set barinfo -menu $popup
  dict set barinfo -TABS $tabinfo
  dict set btData $NewBarID $barinfo
  return $NewBarID
}

#----------------------------------

proc ::bartabs::Bar_Style {barID} {

  # Sets styles a bar's widgets.
  #   barID - ID of the tab's bar

  # for scrolling arrow buttons
  ttk::style configure ArButton$barID [ttk::style configure TButton]
  ttk::style configure ArButton$barID -relief flat \
    -padx 0 -bd 0 -highlightthickness 0
  ttk::style map       ArButton$barID [ttk::style map TButton]
  ttk::style layout    ArButton$barID [ttk::style layout TButton]
  # for tab close buttons
  ttk::style configure ClButton$barID [ttk::style configure TButton]
  ttk::style configure ClButton$barID -anchor center -relief flat \
    -padx 0 -bd 0 -highlightthickness 0
  ttk::style map       ClButton$barID [ttk::style map TButton]
  ttk::style layout    ClButton$barID [ttk::style layout TButton]
}

#----------------------------------

proc ::bartabs::Bar_ScrollCurr {barID dir} {

  # Scrolls the current tab to the left/right.
  #   barID - ID of the bar
  #   dir - -1 if scrolling to the left; 1 if to the right

  lassign [bar_Cget $barID -scrollsel -TABCURR -TABS] sccur tcurr tabs
  if {!$sccur || $tcurr eq ""} {return no}
  set i 0
  foreach tab $tabs {
    lassign $tab tID text wb
    if {$tID == $tcurr} {
      set it [expr {$i+$dir}]
      if {[lindex $tabs $it 2] ne ""} {  ;# is it a visible tab?
        tab_Select [lindex $tabs $it 0]  ;# yes, set it be current
        return yes
      }
      return no
    }
    incr i
  }
  return no
}

#----------------------------------

proc ::bartabs::Bar_ScrollLeft {barID} {

  # Scrolls the bar tabs to the left.
  #   barID - ID of the bar

  if {[Bar_ScrollCurr $barID -1]} return
  lassign [bar_Cget $barID -tleft -TABS -scrollsel] tleft tabs sccur
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
    if {$sccur} {tab_Select [lindex $tabs $tleft 0]}
  }
  bar_Configure $barID -TABS $tabs -tleft $tleft
  ::bartabs::bar_Refill $barID $tleft yes
}

#----------------------------------

proc ::bartabs::Bar_ScrollRight {barID} {

  # Scrolls the bar tabs to the right.
  #   barID - ID of the bar

  if {[Bar_ScrollCurr $barID 1]} return
  lassign [bar_Cget $barID -tleft -tright -TABS -scrollsel] \
    tleft tright tabs sccur
  set llen [llength $tabs]
  if {![string is integer -strict $tleft]} {set tleft 0}
  if {![string is integer -strict $tright]} {set tright [expr {$llen-1}]}
  for {set i $tright} {$i>=$tleft && $i<($llen-1)} {incr i -1} {
    # shift the visible tabs, by one tab to the right
    set i2 [expr {$i+1}]
    set tab1 [lindex $tabs $i]
    set tab2 [lindex $tabs $i2]
    lassign $tab1 ID1 text1 wb wb1 wb2
    lassign $tab2 ID2 text2
    # move widget names from current to next tab
    set tabs [lreplace $tabs $i2 $i2 [Tab_Info $ID2 [list $text2 $wb $wb1 $wb2]]]
    # remove widget names from the current tab
    set tabs [lreplace $tabs $i $i [Tab_Info $ID1 [list $text1]]]
  }
  if {$tright<($llen-1)} {incr tright}
  bar_Configure $barID -TABS $tabs -tleft $tleft -tright $tright
  ::bartabs::bar_Refill $barID $tright no
  if {$sccur} {tab_Select [lindex $tabs $tright 0]}
}

#----------------------------------

proc ::bartabs::Bar_ArrowsState {barID sleft sright} {

  # Sets a state of scrolling arrows.
  #   barID - ID of the bar
  #   sleft - state of a left arrow ("no" for "disabled")
  #   sright - state of a right arrow ("no" for "disabled")

  variable btData
  lassign [bar_Cget $barID -WWID -hidearrows] wwid hidearr
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

proc ::bartabs::Bar_CheckDsblPopup {tabID menuitem} {

  # Controls disabling of "Close" menu items.
  #   tabID - ID of the clicked tab
  #   menuitem - menu item to control
  # Returns "yes" for disabled menu item

  lassign [tab_BarID $tabID] barID tabs icur
  set static [bar_Cget $barID -static]
  switch -exact -- $menuitem {
    "Close" - "Close all" {return $static}
    "Close all at left" {return [expr {$static || !$icur}]}
    "Close all at right" {return [expr {$static || $icur==([llength $tabs]-1)}]}
  }
  return no
}

#----------------------------------

proc ::bartabs::Bar_PopupInfo {barID popName} {

  # Creates a popup menu items in a tab bar.
  #   barID - ID of the bar
  #   popName - variable name for popup's data

  upvar 1 $popName pop
  set dsbl "{} ::bartabs::Bar_CheckDsblPopup"
  foreach item [list \
  "m {List} {} bartabs_cascade" "s" \
  "c {Close} {::bartabs::tab_Close %t} $dsbl" \
  "c {Close all} {::bartabs::tab_CloseFew $barID} $dsbl" \
  "c {Close all at left} {::bartabs::tab_CloseFew $barID %t 1} $dsbl" \
  "c {Close all at right} {::bartabs::tab_CloseFew $barID %t} $dsbl"] {
    lappend pop $item
  }
}

#----------------------------------

proc ::bartabs::Bar_Command {barID tabID opt} {

  # Executes a command bound to an action on a tab.
  #   barID - ID of the bar
  #   tabID - ID of the tab
  #   opt - command option (-cdel, -cnew, -csel)
  # The commands can include wildcards: %b for bar ID, %t for tab ID,
  # %l for tab label. 
  # Returns "yes", if no command set or the command returned "yes".

  variable btData
  if {[dict exists $btData $barID $opt]} {
    set com [dict get $btData $barID $opt]
    if {$tabID>-1} {
      set label [tab_Cget $tabID -text]
    } else {
      set label ""
    }
    set res [{*}[string map [list %b $barID %t $tabID %l $label] $com]]
    if {$res eq "" || !$res} {return no} ;# chosen to not close
  }
  return yes
}

#----------------------------------

proc ::bartabs::Bar_Width {barID} {

  # Calculates the width of a bar to place tabs.
  #   barID - ID of the bar
  # Returns the width of bar.

  lassign [bar_Cget $barID \
    -tleft -tright -TABS -wbase -wbar -ARRLEN -hidearrows -WWID -bwidth] \
    tleft tright tabs wbase wb arrlen hidearrows wwid bwidth1
  set iarr 2
  if {$hidearrows} {  ;# how many scrolling arrow are visible?
    if {!$tleft} {incr iarr -1}
    if {$tright==([llength $tabs]-1)} {incr iarr -1}
  }
  set minus2len [expr {-$iarr*$arrlen}]
  if {[set wbase_exist [winfo exists $wbase]]} {
    # 'wbase' is a base widget to get the bartabs' width from
    set bwidth2 [expr {[Aux_WidgetWidth $wbase]+$minus2len}]
    set wbase_exist [expr {$bwidth2>1}]
  }
  if {$bwidth1 eq "" || $bwidth1<=1} {set bwidth1 0}
  if {$wbase_exist && !$bwidth1} {
    # no -bwidth option - get the bartabs' width from 'wbase'
    set bwidth $bwidth2
  } else {
    # otherwise, get the bartabs' width from -bwidth
    set bwidth [expr {$wbase_exist ? min($bwidth1,$bwidth2) : $bwidth1}]
  }
  if {[set winw [winfo width .]]<2} {set winw [winfo reqwidth .]}
  incr winw $minus2len
  if {$bwidth<=0} { ;# last refuge
    set bwidth [expr {max($winw,[winfo reqwidth $wb],[winfo width $wb])}]
  } elseif {$wbase eq "" && $bwidth1 && $winw>1 && $bwidth1>$winw} {
    set bwidth $winw
  }
  return $bwidth
}

# ____________________ Interface procedures for bars ____________________ #

proc ::bartabs::bar_FillFromLeft {barID {ileft ""} {tright "end"}} {

  # Fills a bar with tabs from the left to the right (as much tabs as possible).
  #   barID - ID of the bar
  #   ileft - index of a left tab
  #   tright - index of a right tab

  variable btData
  lassign [Aux_InitDraw $barID] bwidth vislen bd arrlen llen tleft fgo bgo hidearr tabs wframe
  if {$ileft ne ""} {set tleft $ileft}
  for {set n $tleft} {$n<$llen} {incr n} {
    lassign [lindex $tabs $n] tabID text
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    if {[Aux_CheckTabVisible $wb $wb1 $wb2 $n $tleft tright vislen \
    $llen $hidearr $arrlen $bd $bwidth tabs $tabID $text]} {
      pack $wb1 $wb2 -side left
      pack $wb -side left
    }
  }
  Aux_EndDraw $barID $tleft $tright $llen $tabs $fgo $bgo
}

#----------------------------------

proc ::bartabs::bar_FillFromRight {barID {tleft 0} {tright "end"}} {

  # Fills a bar with tabs from the right to the left (as much tabs as possible).
  #   barID - ID of the bar
  #   tleft - index of a left tab
  #   tright - index of a right tab

  variable btData
  set llen [llength [bar_Cget $barID -TABS]]
  if {$tright eq "end" || $tright>=$llen} {
    set tright [expr {$llen-1}]
    bar_Configure $barID -tright $tright
  }
  lassign [Aux_InitDraw $barID] bwidth vislen bd arrlen llen tleft fgo bgo hidearr tabs wframe
  for {set n $tright} {$n>=0} {incr n -1} {
    lassign [lindex $tabs $n] tabID text
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    incr vislen [tab_Cget $tabID -width]
    if {$n<$tright && ($vislen+($tright<($llen-1)||!$hidearr?$arrlen:0))>$bwidth} {
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

proc ::bartabs::bar_Refill {barID itab left} {

  # Fills a bar with tabs.
  #   barID - ID of the bar
  #   itab - index of tab
  #   left - if "yes", the bar is filled from the left to the right

  bar_Clear $barID
  if {$left} {
    bar_FillFromLeft $barID $itab
  } else {
    bar_FillFromRight $barID 0 $itab
  }
}

#----------------------------------

proc ::bartabs::bar_Remove {barID} {

  # Removes a bar info from btData dictionary and destroys its widgets.
  #   barID - the bar's ID
  # Returns "yes", if the bar was successfully removed.

  variable btData
  if {[dict exists $btData $barID]} {
    set bar [dict get $btData $barID]
    catch {
      foreach wb [dict get $bar -WWID] {destroy $wb}
    }
    dict unset btData $barID
    return yes
  }
  return no
}

#----------------------------------

proc ::bartabs::bar_Clear {barID} {

  # Destroys the current shown tabs of a bar.
  #   barID - ID of the bar to be cleared

  variable btData
  dict update btData $barID bar {
    dict update bar -TABS tabs {
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

proc ::bartabs::bar_Create {barInfo} {

  # Creates a tab bar.
  #   barInfo - a list of bar's data
  # Returns ID of the created bar.

  set w [dict get $barInfo -wbar] ;# parent window (a frame, most likely)
  set wframe $w.frame ;# frame for tabs
  set wlarr $w.larr   ;# left scrolling button
  set wrarr $w.rarr   ;# right scrolling button
  lappend barInfo -WWID [list $wframe $wlarr $wrarr]
  set barID [Bar_Data $barInfo]
  Bar_Style $barID
  ttk::button $wlarr -style ArButton$barID -image ::bartabs::ImgLeftArr \
    -command [list ::bartabs::onClickLeftArrow $barID] -takefocus 0
  ttk::button $wrarr -style ArButton$barID -image ::bartabs::ImgRightArr \
    -command [list ::bartabs::onClickRightArrow $barID] -takefocus 0
  ttk::frame $wframe -relief flat
  pack $wlarr -side left -padx 0 -pady 0
  pack $wframe -after $wlarr -side left -padx 0 -pady 0
  pack $wrarr -after $wframe -side right -padx 0 -pady 0 -anchor e
  return $barID
}

#----------------------------------

proc ::bartabs::bar_Draw {barID {doupdate yes}} {

  # Draws the bar tabs. Used at changing their contents.
  #   barID - ID of the bar
  #   doupdate - if "yes", performs 'update' before redrawing

  variable btData
  if {$doupdate} update
  lassign [Aux_InitDraw $barID] bwidth vislen bd arrlen llen tleft fgo bgo hidearr tabs wframe
  set tright [expr {$llen-1}]
  for {set i $tleft} {$i<$llen} {incr i} {
    set tab [lindex $tabs $i]
    lassign $tab tabID text wb wb1 wb2
    if {$wb eq ""} {
      lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    } else {
      Tab_SetAttrs $barID $wb1 $wb2 $text
    }
    if {[Aux_CheckTabVisible $wb $wb1 $wb2 $i $tleft tright vislen $llen $hidearr $arrlen $bd $bwidth tabs $tabID $text]} {
      pack $wb1 $wb2 -side left
      pack $wb -side left
    }
  }
  Aux_EndDraw $barID $tleft $tright $llen $tabs $fgo $bgo
}

#----------------------------------

proc ::bartabs::bar_DrawAll {} {

  # Redraws all tab bars.

  variable btData
  dict for {barID barInfo} $btData {bar_Draw $barID no}
}

#----------------------------------

proc ::bartabs::bar_NeedRedraw {barID} {

  # Checks for resizing the bar and redraws it, if needed.
  #   barID - ID of the bar

  lassign [bar_Cget $barID -wbase -WNEED -ARRLEN] wbase wneed arrlen
  set ww [Bar_Width $barID]
  if {$wneed != $ww} {
    bar_Configure $barID -WNEED $ww
    bar_Draw $barID no
  }
}

#----------------------------------

proc ::bartabs::bar_Update {barID {tabID -1}} {

  # Clears and redraws a bar.
  #   barID - ID of the bar to be cleared
  #   tabID - ID of tab to be current (barID may be anything at that)

  if {$tabID > -1} {lassign [tab_BarID $tabID] barID}
  bar_Clear $barID
  if {$tabID == -1} {
    bar_Draw $barID
  } else {
    tab_Show $tabID
  }
  update
}

#----------------------------------

proc ::bartabs::bar_Configure {barID args} {

  # Sets values of options of a bar.
  #   barID - ID of the bar
  #   args - a list of pairs "option value", e.g. {{-tleft 1} {-scrollsel 1}}
  # To make the changes be active, bar_Update is called.

  variable btData
  foreach {opt val} $args {dict set btData $barID $opt $val}
  if {[dict exists $args -static]} {Bar_Style $barID}
}

#----------------------------------

proc ::bartabs::bar_Cget {barID args} {

  # Gets values of options of a tab.
  #   barID - ID of the bar
  #   args - a list of options, e.g. {-TABS -width}
  # Return a list of option values or an option value if args is one option.

  variable btData
  lassign [dict get [dict get $btData $barID] -wbar] wbar
  set res [list]
  foreach opt $args {
    if {$opt eq "-width"} {
      lappend res [Aux_WidgetWidth $wbar]
    } elseif {[dict exists $btData $barID $opt]} {
      lappend res [dict get $btData $barID $opt]
    } else {
      lappend res ""
    }
  }
  if {[llength $args]==1} {return [lindex $res 0]}
  return $res
}

# ____________________ Interface procedures for tabs ____________________ #

proc ::bartabs::tab_BarID {tabID} {

  # Gets barID from tabID.
  #   tabID - ID of a tab
  # Returns a list containing 1) bar's ID (or -1 if no bar found) 2) tabs' list
  # of the bar 3) index of the tab in tabs' list.

  variable btData
  set barID -1
  dict for {bID bInfo} $btData {
    lassign [bar_Cget $bID -WWID -TABS] wwid tabs
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

proc ::bartabs::tab_Select {tabID} {

  # Selects a tab, i.e. makes the tab to be current.
  #   tabID - ID of the tab

  if {$tabID eq ""} return
  set barID [lindex [tab_BarID $tabID] 0]
  if {![Bar_Command $barID $tabID -csel]} {return no} ;# chosen to not select
  Tab_MarkBar $barID $tabID
}

#----------------------------------

proc ::bartabs::tab_Mark {args} {

  # Marks tab(s) in a bar.
  #   args - list of ID of tabs to be marked

  foreach tabID $args {
    set barID [lindex [tab_BarID $tabID] 0]
    set marktabs [bar_Cget $barID -MARKTABS]
    if {[lsearch $marktabs $tabID]<0} {
      lappend marktabs $tabID
      bar_Configure $barID -MARKTABS $marktabs
    }
  }
  Tab_MarkBars
}

#----------------------------------

proc ::bartabs::tab_UnMark {args} {

  # Unmarks tab(s) in a bar.
  #   args - list of ID of tabs to be unmarked

  foreach tabID $args {
    set barID [lindex [tab_BarID $tabID] 0]
    set marktabs [bar_Cget $barID -MARKTABS]
    if {[set i [lsearch $marktabs $tabID]]>=0} {
      bar_Configure $barID -MARKTABS [lreplace $marktabs $i $i]
    }
  }
  Tab_MarkBars
}

#----------------------------------

proc ::bartabs::tab_Show {tabID} {

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
    if {$wb ne ""} {set vis yes}
  }
  if {$fill} {bar_Refill $barID $itab [expr {$fill==2}]}
  tab_Select $tabID
}

#----------------------------------

proc ::bartabs::tab_IDbyName {barID text} {

  # Searches for a tab ID by its text.
  #   barID - ID of the tab's bar
  #   text - a text of tab
  # Returns the tab's ID (if found) or -1 (if not).

  variable btData
  set ellipse [dict get $btData $barID -ELLIPSE]
  if {[string first $ellipse $text]} {
    set pattern [string map [list $ellipse "*"] $text]
  } else {
    set pattern ""
  }
  foreach tab [dict get $btData $barID -TABS] {
    lassign $tab tID ttxt
    if {$text eq $ttxt} {return $tID}
    if {$pattern ne "" && [string match $pattern $ttxt]} {return $tID}
  }
  return -1
}

#----------------------------------

proc ::bartabs::tab_Close {tabID} {

  # Closes a tab.
  #   tabID - ID of the tab

  lassign [tab_BarID $tabID] barID tabs i
  return [onClickClose $barID [lindex $tabs $i 3] no $tabID]
}

#----------------------------------

proc ::bartabs::tab_CloseFew {barID {tabID -1} {left no}} {

  # Closes few tabs.
  #   tabID - ID of the current tab or -1 if to close all
  #   left - "yes" if to close all at left of tabID, "no" if at right

  if {$tabID!=-1} {
    lassign [tab_BarID $tabID] barID tabs icur
  } else {
    set tabs [bar_Cget $barID -TABS]
  }
  for {set i [llength $tabs]} {$i} {} {
    incr i -1
    lassign [lindex $tabs $i] tID text wb
    if {$tabID==-1 || ($left && $i<$icur) || (!$left && $i>$icur)} {
      if {[tab_Close $tID]} {set tabs [lreplace $tabs $i $i]}
    }
  }
  bar_Clear $barID
  bar_Configure $barID -TABS $tabs
  if {$tabID==-1} {
    bar_Refill $barID 0 yes
  } else {
    lassign [tab_BarID $tabID] barID tabs icur
    bar_Refill $barID $icur $left
  }
}

#----------------------------------

proc ::bartabs::tab_Insert {barID txt {pos "end"}} {

  # Insert a tab into a bar.
  #   barID - ID of the bar
  #   txt - text of the tab
  #   pos - position of the tab in the tabs' list (e.g. 0, end)
  # Returns ID of the created tab.

  if {![Bar_Command $barID -1 -cnew]} {return no} ;# chosen to not insert
  set tabs [bar_Cget $barID -TABS]
  set tab [Tab_NewData $barID [list [Tab_Label $txt]]]
  if {$tab eq ""} {return -1}
  if {$pos eq "end"} {
    set tabs [lappend tabs $tab]
  } else {
    set tabs [linsert $tabs $pos $tab]
  }
  bar_Configure $barID -TABS $tabs
  bar_Refill $barID $pos [expr {$pos ne "end"}]
  return [lindex $tab 0]
}

#----------------------------------

proc ::bartabs::tab_List {barID} {

  # Gets a list of bar's tabs with flags "visible", "marked".
  #   barID - ID of the bar
  # Returns a list of items "tab ID, tab text, visible, marked".

  lassign [bar_Cget $barID -TABS -MARKTABS] tabs marktabs
  set res [list]
  foreach tab $tabs {
    lassign $tab tabID text wb
    set visible [expr {$wb ne ""}]
    set marked [expr {[lsearch $marktabs $tabID]>=0}]
    lappend res [list $tabID $text $visible $marked]
  }
  return $res
}

#----------------------------------

proc ::bartabs::tab_Configure {tabID args} {

  # Sets values of options of a tab.
  #   tabID - ID of the tab
  #   args - a list of pairs "option value", e.g. {-text "New name"}
  # To make the changes be active, bar_Draw or tab_Show is called.

  lassign [tab_BarID $tabID] barID tabs i
  set tab [lindex $tabs $i]
  foreach {opt val} $args {
    switch -- $opt {
      -text {
        set tab [lreplace $tab 1 1 $val]
      }
    }
  }
  bar_Configure $barID -TABS [lreplace $tabs $i $i $tab]
}

#----------------------------------

proc ::bartabs::tab_Cget {tabID args} {


  # Gets options of the tab.
  #   tabID - ID of the tab
  #   args - list of option names (-text, -wb, -wb1, -wb2)
  # Return a list of option values or an option value if args is one option.

  set res [list]
  lassign [tab_BarID $tabID] barID tabs i
  lassign [lindex $tabs $i] tID text wb wb1 wb2
  set bd [bar_Cget $barID -BD]
  foreach opt $args {
    switch -- $opt {
      -text - -wb - -wb1 - -wb2 {
        lappend res [set [string range $opt 1 end]]
      }
      -width {  ;# width of tab widget
        if {$wb eq ""} {
          lappend res 0
        } else {
          lappend res [expr {[Aux_WidgetWidth $wb1]+[Aux_WidgetWidth $wb2]}]
        }
      }
      default {return -code error "Incorrect tab option: $opt"}
    }
  }
  if {[llength $args]==1} {return [lindex $res 0]}
  return $res
}

# _________________________________ EOF _________________________________ #

#RUNF0: test.tcl     ;# to test from e_menu without switching to test*.tcl
#-RUNF1: ../tests/test2_pave.tcl
