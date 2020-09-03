# _______________________________________________________________________ #
#
# The tab bar widget.
#
# Scripted by Alex Plotnikov (aplsimple@gmail.com).
# License: MIT.
# _______________________________________________________________________ #

package require Tk
package provide bartabs 1.0b4
catch {package require tooltip} ;# optional (though necessary everywhere:)

# ______________________ Common data of bartabs _________________________ #

namespace eval bts {

  # dictionary of bars & tabs
  variable btData [dict create]

  # IDs for new bars & tabs
  variable NewBarID 0 NewTabID 0 NewTabNo 0

  # images used by bartabs, made by base64
  image create photo bts::ImgLeftArr \
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
  image create photo bts::ImgRightArr \
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
  image create photo bts::ImgNone \
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
  image create photo bts::ImgClose \
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

# _____________________ Internal procedures for tabs ____________________ #

proc bts::Tab_Create {barID tabID w text} {
  # Creates a tab widget (consisting of a frame, a label, a button).
  #   barID - ID of the tab's bar
  #   tabID - ID of the tab
  #   w - a parent frame's name
  #   text - a text of tab
  # Returns a list of created widgets of the tab (frame, label, button).

  variable NewTabNo
  lassign [bar_Cget $barID -relief -bd -padx -pady] relief bd padx pady
  set bd [expr {$bd?1:0}]
  lassign [tab_Cget $tabID -wb -wb1 -wb2] wb wb1 wb2
  if {![Tab_Is $wb]} {
    if {$wb eq ""} {
      set NewTabNo [expr {($NewTabNo+1)%1000000000}]
      set wb $w.t[format %09d $tabID]$NewTabNo
      set wb1 $wb.l
      set wb2 $wb.b
    }
    tab_Configure $tabID -wb $wb -wb1 $wb1 -wb2 $wb2
    ttk::frame $wb -relief $relief -borderwidth $bd
    ttk::label $wb1 -relief flat -padding "$padx $pady $padx $pady" \
      {*}[Tab_Font $barID]
    ttk::button $wb2 -style ClButton$barID -image bts::ImgNone \
      -command [list bts::tab_Close $tabID] -takefocus 0
  } else {
    $wb configure -relief $relief -borderwidth $bd
    $wb1 configure -relief flat -padding "$padx $pady $padx $pady" \
      {*}[Tab_Font $barID]
  }
  lassign [Tab_TextEllipsed $barID $text] text ttip
  catch {tooltip::tooltip $wb1 $ttip; tooltip::tooltip $wb2 $ttip}
  $wb1 configure -text $text
  if {[Tab_Iconic $barID]} {
    $wb2 configure -state normal
  } else {
    $wb2 configure -state disabled -image {}
  }
  return [list $wb $wb1 $wb2]
}
#----------------------------------

proc bts::Tab_Label {label} {
  # Prepares a label to be shown in a tab (excludes special characters).
  #   label - a tab's label

  return [string map {\" \'} $label]
}
#----------------------------------

proc bts::Tab_DictItem {tabID {data ""}} {
  # Gets a tab item data from a dictionary item (ID + data).
  #   tabID - ID of the tab or the tab item (ID + data).
  #   data - the tab's data (list of option-value pairs)
  # If 'data' argument omitted, tabID is a dictionary item (ID + data).
  # If the tab's attribute is absent, it's considered being empty ("").
  # Returns a list of attributes: "ID, text, wb, wb1, wb2, pf".

  if {$data eq ""} {lassign $tabID tabID data}
  set res [list $tabID]
  foreach a {-text -wb -wb1 -wb2 -pf} {
    if {[dict exists $data $a]} {
      lappend res [dict get $data $a]
    } else {
      lappend res ""
    }
  }
  return $res
}
#----------------------------------

proc bts::Tab_ItemDict {tabID text {wb ""} {wb1 ""} {wb2 ""} {pf ""}} {
  # Gets a dictionary item (ID + data) from a tab item data.
  #   tabID - ID of the tab
  #   text - text of tab's label;
  #   wb - tab's frame
  #   wb1 - tab's label
  #   wb2 - tab's button
  #   pf - "p" if the tab under pack or "" if pack forget
  # Returns a dictionary tab item containing ID and a dictionary of attributes.

  return [list $tabID [list -text $text -wb $wb -wb1 $wb1 -wb2 $wb2 -pf $pf]]
}
#----------------------------------

proc bts::Tab_Data {barID text} {
  # Creates data of a new tab.
  #   barID - ID of the new tab's bar
  #   text - the new tab's text
  # For sure, the bar is checked for a duplicate of the 'text'.
  # Returns a tab item or "" (if duplicated).

  variable NewTabID
  if {[tab_IDbyName $barID $text]>-1} {return ""}
  return [Tab_ItemDict [incr NewTabID] $text]
}
#----------------------------------

proc bts::Tab_Bindings {barID} {
  # Sets bindings on events of tabs.
  #   barID - ID of the tab's bar

  lassign [bar_Cget $barID -static -FGOVER -BGOVER] static fgo bgo
  foreach tab [tab_List $barID] {
    lassign $tab tabID text wb wb1 wb2
    if {[Tab_Is $wb]} {
      set ctrlBP "bts::onCtrlButton $barID $tabID ; break"
      foreach w [list $wb $wb1 $wb2] {
        bind $w <Enter> "bts::onEnterTab $barID $wb1 $wb2 $fgo $bgo"
        bind $w <Leave> "bts::onLeaveTab $barID $tabID $wb1 $wb2"
        bind $w <Button-3> "bts::onPopup $barID $tabID %X %Y"
        bind $w <Control-ButtonPress> $ctrlBP
      }
      bind $wb <Control-ButtonPress> $ctrlBP
      bind $wb <ButtonPress> "bts::onButtonPress $barID $wb1 {}"
      bind $wb1 <ButtonPress> "bts::onButtonPress $barID $wb1 %x"
      bind $wb1 <ButtonRelease> "bts::onButtonRelease $barID $wb1 %x"
      bind $wb1 <Motion> "bts::onButtonMotion $barID $wb1 %x %y"
    }
  }
}
#----------------------------------

proc bts::Tab_Font {barID} {
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

proc bts::Tab_ImageMarkAttrs {barID tabID {withbg yes} {wb2 ""}} {
  # Gets image & mark attributes of marks.
  #   barID - ID of the bar
  #   tabID - ID of the current tab
  #   wb2 - path to a button
  #   withbg - if true, to get also background
  # Returns string of mark attributes or empty string.

  lassign [bar_Cget $barID \
    -marktabs -imagemark -fgmark -bgmark -IMAGETABS -FGMAIN -BGMAIN] \
    marktabs imagemark fgm bgm imagetabs fgmain bgmain
  set res ""
  if {[lsearch $marktabs $tabID]>-1} {
    if {$imagemark eq ""} {
      if {$fgm eq ""} {set fgm $fgmain}  ;# empty value - no markable tabs
      set res " -foreground $fgm"
      if {$withbg} {
        if {$bgm eq ""} {set bgm $bgmain}
        append res " -background $bgm"
      }
      if {$wb2 ne ""} {$wb2 configure -image bts::ImgNone}
    }
  } else {
    set imagemark ""
    set text [tab_Cget $tabID -text] 
    if {[set i [lsearch -index 0 -exact $imagetabs $text]]>-1} {
      set imagemark [lindex $imagetabs $i 1]
    } elseif {$wb2 ne ""} {
      $wb2 configure -image bts::ImgNone
    }
  }
  if {$imagemark ne ""} {
    set res " -image $imagemark -compound left"
    if {$wb2 ne ""} {$wb2 configure {*}$res}
  }
  return $res
}
#----------------------------------

proc bts::Tab_SelAttrs {fnt fgsel bgsel} {
  # Gets attributes of selected tab's title.
  #   fnt - original font attributes
  #   fgsel - 'foreground for selection' setting
  #   bgsel - 'background for selection' setting
  # The 'selection' settings work as follows:
  #   1) if both set, fgsel and bgsel mean colors for selection
  #   2) if bgsel=="", fgsel!="" means a widget for selection
  #   3) if fgsel=="", then 'selection' means 'underlining'
  # Examples: 1) -fgsel white -bgsel red 2) -fgsel . 3) -fgsel ""
  # Returns a new font attributes.

  lassign $fnt opt val
  if {$fgsel eq ""} {
    set val [dict set val -underline 1]
  } else {
    if {$bgsel eq ""} {
      set bgsel [ttk::style configure $fgsel -selectbackground]
      set fgsel [ttk::style configure $fgsel -selectforeground]
    }
    set opt "-foreground $fgsel -background $bgsel $opt"
  }
  return "$opt {$val}"
}
#----------------------------------

proc bts::Tab_MarkBar {barID {tabID -1}} {
  # Marks the tabs of a bar with color & underlining.
  #   barID - ID of the bar
  #   tabID - ID of the current tab

  lassign [bar_Cget $barID -tabcurrent -fgsel -bgsel -FEWSEL -FGMAIN -BGMAIN] \
    tID fgs bgs fewsel fgm bgm
  if {$tabID in {"" "-1"}} {set tabID $tID}
  foreach tab [tab_List $barID] {
    lassign $tab tID text wb wb1 wb2
    if {[Tab_Is $wb]} {
      set font [Tab_Font $barID]
      set selected [expr {$tID == $tabID || [lsearch $fewsel $tID]>-1}]
      if {$selected} {set font [Tab_SelAttrs $font $fgs $bgs]}
      $wb1 configure {*}$font
      set attrs [Tab_ImageMarkAttrs $barID $tID [expr {!$selected}] $wb2]
      if {$attrs ne "" && "-image" ni $attrs } {
        $wb1 configure {*}$attrs
      } elseif {!$selected} {
        $wb1 configure -foreground $fgm -background $bgm
      }
    }
  }
  bar_Configure $barID -tabcurrent $tabID
}
#----------------------------------

proc bts::Tab_MarkBars {{barID -1} {tabID -1}} {
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

proc bts::Tab_TextEllipsed {barID text {lneed -1}} {
  # Gets a tab's label (possibly ellipsed) and tooltip
  #   barID - ID of the bar
  #   text - text of tab label
  #   lneed - label length anyway
  # Returns a list of "label tooltip".

  lassign [bar_Cget $barID -lablen -ELLIPSE] lablen ellipse
  if {$lneed ne -1} {set lablen $lneed}
  if {$lablen && [string length $text]>$lablen} {
    set ttip $text
    set text [string range $text 0 $lablen-1]
    append text $ellipse
  } else {
    set ttip ""
  }
  return [list $text $ttip]
}
#----------------------------------

proc bts::Tab_Iconic {barID} {
  # Gets a flag "tabs with icons".
  #   barID - ID of the bar
  # Returns "yes", if tabs are supplied with icons.

  lassign [bar_Cget $barID -static -IMAGETABS] static imagetabs
  return [expr {!$static}]
  #return [expr {[llength $imagetabs] || !$static}]
}
#----------------------------------

proc bts::Tab_Pack {barID tabID wb wb1 wb2} {
  # Packs the tab widgets.
  #   barID - ID of the bar
  #   tabID - ID of the tab
  #   wb - frame
  #   wb1 - label
  #   wb2 - button

  lassign [bar_Cget $barID -static -expand] static expand

  if {[Tab_Iconic $barID]} {
    pack $wb1 -side left
    pack $wb2 -side left
  } else {
    pack $wb1 -side left -fill x
    pack forget $wb2
  }
  if {$expand} {
    pack $wb -side left -fill x -expand 1
  } else {
    pack $wb -side left
  }
  tab_Configure $tabID -pf "p"
}
#----------------------------------

proc bts::Tab_RemoveLinks {barID tabID {txt ""}} {
  # Removes a tab's links from the internal lists.
  #   barID - ID of the bar
  #   tabID - ID of the tab or -1, if for the tab's text only
  #   txt - tab's text

  set imagetabs [bar_Cget $barID -IMAGETABS]
  if {$tabID>-1} {set txt [tab_Cget $tabID -text]}
  if {[set i [lsearch -index 0 -exact $imagetabs $txt]]>-1} {
    set imagetabs [lreplace $imagetabs $i $i]
    bar_Configure $barID -IMAGETABS $imagetabs
  }
  if {$tabID>-1} {tab_Unmark $tabID}
}
#----------------------------------

proc bts::Tab_MoveBehind {tabID1 tabID2} {
  # Moves a tab to a new position.
  #   tabID1 - ID of the moved tab
  #   tabID2 - ID of a tab the moved tab should be behind

  lassign [tab_BarID $tabID1] barID i1
  lassign [tab_BarID $tabID2] barID i2
  if {$i1!=$i2} {
    set tabs [bar_Cget $barID -TABS]
    set tab [lindex $tabs $i1]
    set tabs [lreplace $tabs $i1 $i1]
    set i [expr {$i1>$i2?($i2+1):$i2}]
    bar_Configure $barID -TABS [linsert $tabs $i $tab]
    tab_Show $tabID1 1
  }
}
#----------------------------------

proc bts::Tab_Is {wb} {
  # Checks if 'wb' is a path to an existing tab.
  #   wb - path to be checked

    return [expr {$wb ne "" && [winfo exists $wb]}]
}

# _____________________ Internal procedures for bars ____________________ #

proc bts::Bar_Data {barNewInfo} {
  # Puts data of a new bar in btData dictionary.
  #   barNewInfo - the new bar's data
  # Returns ID of the new bar.

  variable btData
  variable NewBarID
  incr NewBarID
  # set defaults:
  set barinfo [dict create -wbase "" -wproc "" \
    -static no -hidearrows no -redraw 1 -scrollsel yes -lablen 0 -tiplen 0 \
    -tleft 0 -tright end -tabcurrent -1 -marktabs [list] -fgmark #800080 \
    -relief groove -fgsel "." -bd 1 -padx 2 -pady 4 -expand 1 \
    -ELLIPSE "\u2026" -MOVWIN ".bt_move" -ARRLEN 0]
  set tabinfo [set imagetabs [set popup [list]]]
  set usermnu 0
  Bar_PopupInfo $NewBarID popup
  foreach {optnam optval} $barNewInfo {
    switch -exact -- $optnam {
      -tab { ;# a tab's info is a text
        set found no
        set optval [Tab_Label $optval]
        # check for duplicates: no duplicate tabs allowed
        if {[lsearch -index {1 1} -exact $tabinfo $optval]==-1} {
          lappend tabinfo [Tab_Data $NewBarID $optval]
        }
        continue ;# tabs added one by one
      }
      -imagetab {  ;# a label and its image
        lappend imagetabs $optval
      }
      -menu {
        lappend popup {*}$optval
        set usermnu 1
      }
      -tleft - -tright { ;# index of left/right tab
      }
      -fgmark - -bgmark { ;# foreground/background color of a tab marked
      }
      -imagemark { ;# image of a tab marked
      }
      -cnew - -cdel - -csel - -cmov {
        ;# command called at creating/deleting/selecting/moving a tab
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
      -wproc { ;# procedure to get the bartabs' width
      }
      -lablen { ;# maximum of tab label's length
      }
      -tiplen { ;# maximum of tooltips for scrolling arrows
      }
      -fgsel - -bgsel { ;# attributes for selection
      }
      -bd { ;# tab's border
      }
      -padx - -pady { ;# tab's padx, pady
      }
      -expand { ;# flag "expand tabs to fill the bar"
      }
      -redraw { ;# flag "redraw the bar at window resizing"
      }
      -WWID { ;# tab's widgets (inside use)
      }
      -DEBUG { ;# for debugging, e.g. to shade options like -menu
      }
      default {
        return -code error "bartabs: incorrect option $optnam"
      }
    }
    dict set barinfo $optnam $optval
  }
  set wbase [dict get $barinfo -wbase]
  set wproc [dict get $barinfo -wproc]
  if {$wbase ne "" && $wproc eq ""} {
    dict set barinfo -wproc "expr {\[winfo width $wbase\]-80}" ;# 80 for ornaments
  }
  dict set barinfo -menu $popup
  dict set barinfo -USERMNU $usermnu
  dict set barinfo -TABS $tabinfo
  dict set barinfo -LLEN [llength $tabinfo]
  dict set barinfo -IMAGETABS $imagetabs
  dict set btData $NewBarID $barinfo
  return $NewBarID
}
#----------------------------------

proc bts::Bar_InitColors {barID} {
  # Initializes colors of a bar.
  #   barID - ID of the tab's bar

  set fgmain [ttk::style configure . -foreground] ;# all of these are themed &
  set bgmain [ttk::style configure . -background] ;# must be updated each time
  if {[catch { \
    set bgo [dict get [ttk::style map . -background] active]
    set fgo [ttk::style map TButton -foreground]
    if {[dict exists $fgo active]} {
      set fgo [dict get $fgo active]
    } else {
      set fgo $fgmain
    }
  }]} { 
    set bgo $fgmain  ;# reversed
    set fgo $bgmain
    if {$bgo in {black #000000}} {set bgo #444444; set fgo #FFFFFF}
  }
  bar_Configure $barID -FGMAIN $fgmain -BGMAIN $bgmain -FGOVER $fgo -BGOVER $bgo
}
#----------------------------------

proc bts::Bar_Style {barID} {
  # Sets styles a bar's widgets.
  #   barID - ID of the tab's bar

  ttk::style configure ClButton$barID [ttk::style configure TButton]
  ttk::style configure ClButton$barID -relief flat \
    -padx 0 -bd 0 -highlightthickness 0
  ttk::style map       ClButton$barID [ttk::style map TButton]
  ttk::style layout    ClButton$barID [ttk::style layout TButton]
}
#----------------------------------

proc bts::Bar_ScrollCurr {barID dir} {
  # Scrolls the current tab to the left/right.
  #   barID - ID of the bar
  #   dir - -1 if scrolling to the left; 1 if to the right

  lassign [bar_Cget $barID -scrollsel -tabcurrent] sccur tcurr
  if {!$sccur || $tcurr eq ""} {return no}
  set tabs [tab_FlagList $barID]
  if {[set i [Aux_IndexInList $tcurr $tabs]]==-1} {return no}
  incr i $dir
  if {[lindex $tabs $i 2] eq "1"} { ;# is the next/previous tab visible?
    tab_Select [lindex $tabs $i 0]  ;# yes, set it current
    return yes
  }
  return no
}
#----------------------------------

proc bts::Bar_ArrowsState {barID tleft tright sright} {
  # Sets a state of scrolling arrows.
  #   barID - ID of the bar
  #   tleft - index of left tab
  #   tright - index of right tab
  #   sright - state of a right arrow ("no" for "disabled")

  lassign [bar_Cget $barID -WWID -hidearrows -tiplen] wwid hidearr tiplen
  lassign $wwid wframe wlarr wrarr
  set tabs [tab_List $barID]
  if {$tleft} {
    if {$hidearr && [catch {pack $wlarr -before $wframe -side left}]} {
      pack $wlarr -side left
    }
    set state normal
  } else {
    if {$hidearr} {
      set state normal
      pack forget $wlarr
    } else {
      catch {pack $wlarr -before $wframe -side left}
      set state disabled
    }
  }
  $wlarr configure -state $state
  set tip ""
  if {$state eq "normal" && $tiplen>=0} {
    for {set i [expr {$tleft-1}]} {$i>=0} {incr i -1} {
      if {$tiplen && [incr cntl]>$tiplen} {
        append tip "..."
        break
      }
      set text [lindex [Tab_TextEllipsed $barID [lindex $tabs $i 1]] 0]
      append tip "$text\n"
    }
  }
  catch {tooltip::tooltip $wlarr [string trim $tip]}
  if {$sright} {
    if {$hidearr && [catch {pack $wrarr -after $wframe -side right -anchor e}]} {
      pack $wrarr -side right -anchor e
    }
    set state normal
  } else {
    if {$hidearr} {
      set state normal
      pack forget $wrarr
    } else {
      catch {pack $wrarr -after $wframe -side right -anchor e}
      set state disabled
    }
  }
  $wrarr configure -state $state
  set tip ""
  if {$state eq "normal" && $tiplen>=0} {
    for {set i [expr {$tright+1}]} {$i<[llength $tabs]} {incr i} {
      if {$tiplen && [incr cntr]>$tiplen} {
        append tip "..."
        break
      }
      set text [lindex [Tab_TextEllipsed $barID [lindex $tabs $i 1]] 0]
      append tip "$text\n"
    }
  }
  catch {tooltip::tooltip $wrarr [string trim $tip]}
}
#----------------------------------

proc bts::Bar_CheckDsblPopup {barID tabID mnuit} {
  # Controls disabling of "Close" menu items.
  #   barID - ID of the bar
  #   tabID - ID of the clicked tab
  #   mnuit - menu label
  # Returns "yes" for disabled menu item

  lassign [tab_BarID $tabID] barID icur
  lassign [bar_Cget $barID -static -LLEN] static llen
  switch -exact -- $mnuit {
    "Move to" {
      if {$static} {return 2}
      lassign [Tab_TextEllipsed $barID [tab_Cget $tabID -text] 16] mnuit
      return [list [expr {$llen<2||$llen==2&&$icur==1}] {} "Put \"$mnuit\" behind"]
    }
    "Close" - "Close all" - "" {
      if {$static} {return 2}
    }
    "Close all at left" {
      if {$static} {return 2}
      return [expr {!$icur}]
    }
    "Close all at right" {
      if {$static} {return 2}
      return [expr {$icur==($llen-1)}]
    }
  }
  return no
}
#----------------------------------

proc bts::Bar_PopupInfo {barID popName} {
  # Creates a popup menu items in a tab bar.
  #   barID - ID of the bar
  #   popName - variable name for popup's data

  upvar 1 $popName pop
  set NS "[namespace current]::"
  set dsbl "${NS}Bar_CheckDsblPopup"
  foreach item [list \
  "m {List} {} bartabs_cascade" \
  "m {Move to} {} bartabs_cascade2 $dsbl" \
  "s {} {} {} $dsbl" \
  "c {Close} {${NS}tab_Close %t} {} $dsbl" \
  "c {Close all} {${NS}tab_CloseFew $barID} {} $dsbl" \
  "c {Close all at left} {${NS}tab_CloseFew $barID %t 1} {} $dsbl" \
  "c {Close all at right} {${NS}tab_CloseFew $barID %t} {} $dsbl"] {
    lappend pop $item
  }
}
#----------------------------------

proc bts::Bar_PopupFillList {barID popi {tabID -1} {mnu ""}} {
  # Fills "List of tabs" item of popup menu.
  #   barID - ID of the bar
  #   popi - menu of the tab items
  #   tabID - ID of the tab clicked
  #   mnu - root menu name
  # Return a list of menu items types (s - separator, ID - tab ID)

  set vis [set seps 0] ;# flags for separators before/after visible items
  set res [list]
  foreach tab [tab_FlagList $barID] {
    lassign $tab tID text vsbl
    if {$vsbl && !$seps || !$vsbl && $vis} {
      $popi add separator
      lappend res s
      incr seps
      set vis 0
    } elseif {$vsbl} {
      set vis 1
    }
    if {!$seps && $vis} { ;# no invisible at left
      $popi add separator
      lappend res s
      incr seps
    }
    if {$tabID == -1 || $mnu eq "bartabs_cascade"} {
      set comm "bts::tab_Show $tID 1"
    } else {
      set comm "bts::Tab_MoveBehind $tabID $tID"
    }
    $popi add command -label $text -command $comm
    lappend res $tID
  }
  if {$seps<2} { ;# no invisible at right
    $popi add separator
    lappend res s
  }
  return $res
}
#----------------------------------

proc bts::Bar_PopupTuneList {barID tabID popi ilist {pop ""}} {
  # Tunes "List of tabs" item of popup menu (colors & underlining).
  #   barID - ID of the bar
  #   tabID - ID of the clicked tab
  #   popi - menu of the tab items
  #   ilist - list of "s" (separators) and IDs of tabs
  #   pop - menu to be themed

  if {$pop eq ""} {set pop $popi}
  catch {::apave::paveObj themePopup $pop}
  lassign [bar_Cget $barID -tabcurrent -FEWSEL -FGOVER -BGOVER] \
    tabcurr fewsel fgo bgo
  for {set i 0} {$i<[llength $ilist]} {incr i} {
    if {[set tID [lindex $ilist $i]] eq "s"} continue
    set opts [Tab_ImageMarkAttrs $barID $tID]
    if {"-image" ni $opts} {
      append opts " -image bts::ImgNone -compound left"
    }
    set font [list -font [font configure TkDefaultFont]]
    if {$tID==$tabcurr || [lsearch $fewsel $tID]>-1} {
      set font [Tab_SelAttrs $font "" ""]
    }
    append opts " $font"
    if {$tID==$tabID} {append opts " -foreground $fgo -background $bgo"}
    $popi entryconfigure $i {*}$opts
  }
}
#----------------------------------

proc bts::Bar_Command {barID tabID opt} {
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
    if {$res eq "" || !$res} {return no} ;# chosen "don't"
  }
  return yes
}
#----------------------------------

proc bts::Bar_Width {barID} {
  # Calculates the width of a bar to place tabs.
  #   barID - ID of the bar
  # Returns the width of bar.

  lassign [bar_Cget $barID \
    -tleft -tright -LLEN -wbase -wbar -ARRLEN -hidearrows -WWID -BWIDTH -wproc] \
    tleft tright llen wbase wb arrlen hidearrows wwid bwidth1 wproc
  set iarr 2
  if {$hidearrows} {  ;# how many scrolling arrows are visible?
    if {!$tleft} {incr iarr -1}
    if {$tright==($llen-1)} {incr iarr -1}
  }
  set minus2len [expr {-$iarr*$arrlen}]
  set bwidth2 0
  if {$wproc ne ""} {
    set bwidth2 [{*}[string map [list %b $barID] $wproc]]
  }
  if {$bwidth2<2 && [set wbase_exist [winfo exists $wbase]]} {
    # 'wbase' is a base widget to get the bartabs' width from
    set bwidth2 [Aux_WidgetWidth $wbase]
  }
  incr bwidth2 $minus2len
  set wbase_exist [expr {$bwidth2>1}]
  if {$bwidth1 eq "" || $bwidth1<=1} {set bwidth1 0}
  if {$wbase_exist && !$bwidth1} {
    # no -BWIDTH option - get the bartabs' width from 'wbase'
    set bwidth $bwidth2
  } else {
    # otherwise, get the bartabs' width from -BWIDTH
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
#----------------------------------

proc bts::Bar_FillFromLeft {barID {ileft ""} {tright "end"}} {
  # Fills a bar with tabs from the left to the right (as much tabs as possible).
  #   barID - ID of the bar
  #   ileft - index of a left tab
  #   tright - index of a right tab

  lassign [Aux_InitDraw $barID] bwidth vislen bd arrlen llen tleft hidearr tabs wframe
  if {$ileft ne ""} {set tleft $ileft}
  for {set i $tleft} {$i<$llen} {incr i} {
    lassign [Tab_DictItem [lindex $tabs $i]] tabID text wb wb1 wb2 pf
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    if {[Aux_CheckTabVisible $wb $wb1 $wb2 $i $tleft tright vislen \
    $llen $hidearr $arrlen $bd $bwidth tabs $tabID $text]} {
      Tab_Pack $barID $tabID $wb $wb1 $wb2
    }
  }
  Aux_EndDraw $barID $tleft $tright $llen
}
#----------------------------------

proc bts::Bar_FillFromRight {barID tleft tright behind} {
  # Fills a bar with tabs from the right to the left (as much tabs as possible).
  #   barID - ID of the bar
  #   tleft - index of a left tab
  #   tright - index of a right tab
  #   behind - flag "go behind the right tab"

  set llen [bar_Cget $barID -LLEN]
  if {$tright eq "end" || $tright>=$llen} {set tright [expr {$llen-1}]}
  bar_Configure $barID -tleft $tright -tright $tright
  lassign [Aux_InitDraw $barID] bwidth vislen bd arrlen llen tleft hidearr tabs wframe
  set totlen 0
  for {set i $tright} {$i>=0} {incr i -1} {
    lassign [Tab_DictItem [lindex $tabs $i]] tabID text wb wb1 wb2 pf
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    incr vislen [set wlen [tab_Cget $tabID -width]]
    if {$i<$tright && ($vislen+($tright<($llen-1)||!$hidearr?$arrlen:0))>$bwidth} {
      set pf ""
    } else {
      set tleft $i
      set pf "p"
      incr totlen $wlen
    }
    set tabs [lreplace $tabs $i $i [Tab_ItemDict $tabID $text $wb $wb1 $wb2 $pf]]
  }
  set i $tright
  while {$behind && [incr i]<($llen-1) && $totlen<$bwidth} {
    # try to go behind the right tab as far as possible
    lassign [Tab_DictItem [lindex $tabs $i]] tabID text wb wb1 wb2 pf
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    incr totlen [tab_Cget $tabID -width]
    if {($totlen+($i<($llen-1)||!$hidearr?$arrlen:0))>$bwidth} {
      set pf ""
    } else {
      set tright $i
      set pf "p"
    }
    set tabs [lreplace $tabs $i $i [Tab_ItemDict $tabID $text $wb $wb1 $wb2 $pf]]
  }
  for {set i $tleft} {$i<$llen} {incr i} {
    lassign [Tab_DictItem [lindex $tabs $i]] tabID text wb wb1 wb2 pf
    if {[Tab_Is $wb] && $pf ne ""} {Tab_Pack $barID $tabID $wb $wb1 $wb2}
  }
  Aux_EndDraw $barID $tleft $tright $llen
}
#----------------------------------

proc bts::Bar_Refill {barID itab left {behind false}} {
  # Fills a bar with tabs.
  #   barID - ID of the bar
  #   itab - index of tab
  #   left - if "yes", the bar is filled from the left to the right
  #   behind - flag "go behind the right tab"

  bar_Clear $barID
  if {$itab eq "end" || $itab==([bar_Cget $barID -LLEN]-1)} {
    set left 0  ;# checking for the end
  }
  if {$left} {
    Bar_FillFromLeft $barID $itab
  } else {
    Bar_FillFromRight $barID 0 $itab $behind
  }
}

# ____________________ Interface procedures for bars ____________________ #

proc bts::bar_Remove {barID} {
  # Removes a bar info from btData dictionary and destroys its widgets.
  #   barID - the bar's ID
  # Returns "yes", if the bar was successfully removed.

  variable btData
  if {[dict exists $btData $barID]} {
    set bar [dict get $btData $barID]
    catch {foreach wb [dict get $bar -WWID] {destroy $wb}}
    dict unset btData $barID
    return yes
  }
  return no
}
#----------------------------------

proc bts::bar_Clear {barID} {
  # Forgets the currently shown tabs of a bar.
  #   barID - ID of the bar to be cleared

  foreach tab [tab_List $barID] {
    lassign $tab tabID text wb wb1 wb2 pf
    if {[Tab_Is $wb] && $pf ne ""} {
      pack forget $wb
      tab_Configure $tabID -pf ""
    }
  }
}
#----------------------------------

proc bts::bar_Create {barInfo} {
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
  ttk::button $wlarr -style ClButton$barID -image bts::ImgLeftArr \
    -command [list bts::bar_ScrollLeft $barID] -takefocus 0
  ttk::button $wrarr -style ClButton$barID -image bts::ImgRightArr \
    -command [list bts::bar_ScrollRight $barID] -takefocus 0
  ttk::frame $wframe -relief flat
  pack $wlarr -side left -padx 0 -pady 0 -anchor e
  pack $wframe -after $wlarr -side left -padx 0 -pady 0 -fill x -expand 1
  pack $wrarr -after $wframe -side right -padx 0 -pady 0 -anchor w
  foreach w {wlarr wrarr} {
    bind [set $w] <Button-3> "bts::bar_PopupList $barID %X %Y"
  }
  lassign [bar_Cget $barID -wbase -wproc -redraw] wbase wproc redraw
  if {$wbase ne "" && $wproc ne "" && $redraw} {
    bind $wbase <Configure> [list + bts::bar_NeedRedraw $barID]
  }
  after idle [list bar_NeedRedraw $barID ; bts::bar_Draw $barID]
  return $barID
}
#----------------------------------

proc bts::bar_NeedRedraw {barID {doredraw yes}} {

  if {[bar_Exists $barID]} {
    lassign [bar_Cget $barID -wproc -BWIDTH -ARRLEN] wproc bwo arrlen
    set bw [{*}[string map [list %b $barID] $wproc]]
    if {$bwo eq "" || [set needit [expr {abs($bwo-$bw)>$arrlen} && $bw>10]]} {
      bar_Configure $barID -BWIDTH $bw
    }
    if {$bwo ne "" && $arrlen ne "" && $needit} {
      after idle [list bts::bar_Draw $barID]
    }
  }
}
#----------------------------------

proc bts::bar_PopupList {barID X Y} {
  # Shows a stand-alone popup menu of tabs.
  #   barID - ID of the bar
  #   X - x coordinate of mouse pointer
  #   Y - y coordinate of mouse pointer

  set wbar [bar_Cget $barID -wbar]
  set popi $wbar.popupList
  catch {destroy $popi}
  menu $popi -tearoff 0
  if {[set plist [Bar_PopupFillList $barID $popi]] eq "s"} {
    destroy $popi
  } else {
    Bar_PopupTuneList $barID -1 $popi $plist
    tk_popup $popi $X $Y
  }
}
#----------------------------------

proc bts::bar_ScrollLeft {barID} {
  # Scrolls the bar tabs to the left.
  #   barID - ID of the bar

  if {[Bar_ScrollCurr $barID -1]} return
  lassign [bar_Cget $barID -tleft -LLEN -scrollsel] tleft llen sccur
  if {![string is integer -strict $tleft]} {set tleft 0}
  if {$tleft && $tleft<$llen} {
    incr tleft -1
    set tID [lindex [tab_List $barID] $tleft 0]
    bar_Configure $barID -tleft $tleft
    Bar_Refill $barID $tleft yes
    if {$sccur} {tab_Select $tID}
  }
}
#----------------------------------

proc bts::bar_ScrollRight {barID} {
  # Scrolls the bar tabs to the right.
  #   barID - ID of the bar

  if {[Bar_ScrollCurr $barID 1]} return
  lassign [bar_Cget $barID -tright -LLEN -scrollsel] tright llen sccur
  if {![string is integer -strict $tright]} {set tright [expr {$llen-2}]}
  if {$tright<($llen-1)} {
    incr tright
    set tID [lindex [tab_List $barID] $tright 0]
    bar_Configure $barID -tright $tright
    Bar_Refill $barID $tright no
    if {$sccur} {tab_Select $tID}
  }
}
#----------------------------------

proc bts::bar_Draw {barID {doupdate yes}} {
  # Draws the bar tabs. Used at changing their contents.
  #   barID - ID of the bar
  #   doupdate - if "yes", performs 'update' before redrawing

  if {$doupdate} update
  lassign [Aux_InitDraw $barID] bwidth vislen bd arrlen llen tleft hidearr tabs wframe
  set tright [expr {$llen-1}]
  for {set i $tleft} {$i<$llen} {incr i} {
    lassign [Tab_DictItem [lindex $tabs $i]] tabID text wb wb1 wb2 pf
    lassign [Tab_Create $barID $tabID $wframe $text] wb wb1 wb2
    if {[Aux_CheckTabVisible $wb $wb1 $wb2 $i $tleft tright vislen $llen $hidearr $arrlen $bd $bwidth tabs $tabID $text]} {
      Tab_Pack $barID $tabID $wb $wb1 $wb2
    }
  }
  Aux_EndDraw $barID $tleft $tright $llen
  Tab_MarkBar $barID
}
#----------------------------------

proc bts::bar_DrawAll {} {
  # Redraws all tab bars.

  variable btData
  dict for {barID barInfo} $btData {bar_Draw $barID no}
}
#----------------------------------

proc bts::bar_UpdateAll {} {
  # Updates all tab bars.

  variable btData
  dict for {barID barInfo} $btData {Bar_Refill $barID 0 yes}
}
#----------------------------------

proc bts::bar_Update {barID {tabID -1}} {
  # Clears and redraws a bar.
  #   barID - ID of the bar to be cleared
  #   tabID - ID of tab to be current (barID may be anything at that)

  if {$tabID > -1} {set barID [lindex [tab_BarID $tabID] 0]}
  bar_Clear $barID
  if {$tabID == -1} {
    bar_Draw $barID
  } else {
    tab_Show $tabID
  }
  update
}
#----------------------------------

proc bts::bar_Exists {barID args} {
  # Checks if a bar exists.
  #   barID - ID of the bar
  # Returns 1 if the bar exists, otherwise returns 0.

  return [expr {[bar_Cget $barID -MOVWIN] ne ""}]
}
#----------------------------------

proc bts::bar_Cget {barID args} {
  # Gets values of options of a tab.
  #   barID - ID of the bar
  #   args - a list of options, e.g. {-TABS -width}
  # Return a list of option values or an option value if args is one option.

  variable btData
  set res [list]
  foreach opt $args {
    if {$opt eq "-width"} {
      lassign [dict get [dict get $btData $barID] -wbar] wbar
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
#----------------------------------

proc bts::bar_Configure {barID args} {
  # Sets values of options of a bar.
  #   barID - ID of the bar
  #   args - a list of pairs "option value", e.g. {{-tleft 1} {-scrollsel 1}}
  # To make the changes be active, bar_Update is called.

  variable btData
  foreach {opt val} $args {
    dict set btData $barID $opt $val
    if {$opt eq "-TABS"} {dict set btData $barID -LLEN [llength $val]}
  }
  if {[dict exists $args -static]} {Bar_Style $barID}
}
#----------------------------------

proc bts::bar_Store {barID} {
  # Stores a bar's data.
  #   barID - ID of the bar
  # Returns the bar's data, i.e. the bar's dictionary.

  variable btData
  variable NewBarID
  variable NewTabID
  variable NewTabNo
  bar_Configure $barID -NewBarID $NewBarID -NewTabID $NewTabID -NewTabNo $NewTabNo
  return [dict get $btData $barID]
}
#----------------------------------

proc bts::bar_Restore {barID data} {
  # Restores a bar's data, i.e. sets the bar's dictionary.
  #   barID - ID of the bar
  #   data - data of the bar (stored by bts::bar_Store)

  variable btData
  variable NewBarID
  variable NewTabID
  variable NewTabNo
  dict set btData $barID $data
  lassign [bar_Cget $barID -NewBarID -NewTabID -NewTabNo] NewBarID NewTabID NewTabNo
}

# ____________________ Interface procedures for tabs ____________________ #

proc bts::tab_BarID {tabID {act ""}} {
  # Gets barID from tabID.
  #   tabID - ID of a tab
  #   act - if "check", only checks the existance of tabID
  # If 'act' is "check" and a bar not found, -1 is returned, otherwise bar ID.
  # Returns a list containing 1) bar's ID (or -1 if no bar found) 2) index of
  # the tab in tabs' list 3) the found tab data.

  variable btData
  set barID -1
  dict for {bID bInfo} $btData {
    set tabs [bar_Cget $bID -TABS]
    if {[set i [Aux_IndexInList $tabID $tabs]] > -1} {
      set barID $bID
      break
    }
  }
  if {$act eq "check"} {return $barID}
  if {$barID < 0} {
    return -code error "bartabs: tab ID $tabID not found in the bars"
  }
  return [list $barID $i [lindex $tabs $i]]
}
#----------------------------------

proc bts::tab_Exists {tabID} {
  # Checks if a tab exists.
  #   tabID - ID of a tab
  # Returns true if the tab exists, otherwise returns false.

  return [expr {[tab_BarID $tabID check] > 0}]
}
#----------------------------------

proc bts::tab_Select {tabID} {
  # Selects a tab, i.e. makes the tab to be current.
  #   tabID - ID of the tab

  if {$tabID in {"" "-1"}} return
  set barID [tab_Cget $tabID -barID]
  Bar_Command $barID $tabID -csel
  Tab_MarkBar $barID $tabID
  if {[set wb2 [tab_Cget $tabID -wb2]] ne "" && \
  ![string match "bts::*" [$wb2 cget -image]] &&
  $tabID ni [tab_MarkList $barID]} {
    $wb2 configure -image bts::ImgNone
  }
}
#----------------------------------

proc bts::tab_Mark {args} {
  # Marks tab(s) in a bar.
  #   args - list of ID of tabs to be marked

  foreach tabID $args {
    if {$tabID ne ""} {
      set barID [lindex [tab_BarID $tabID] 0]
      set marktabs [bar_Cget $barID -marktabs]
      if {[lsearch $marktabs $tabID]<0} {
        lappend marktabs $tabID
        bar_Configure $barID -marktabs $marktabs
      }
    }
  }
  Tab_MarkBars
}
#----------------------------------

proc bts::tab_Unmark {args} {
  # Unmarks tab(s) in a bar.
  #   args - list of ID of tabs to be unmarked

  foreach tabID $args {
    set barID [lindex [tab_BarID $tabID] 0]
    set marktabs [bar_Cget $barID -marktabs]
    if {[set i [lsearch $marktabs $tabID]]>=0} {
      bar_Configure $barID -marktabs [lreplace $marktabs $i $i]
    }
  }
  Tab_MarkBars
}
#----------------------------------

proc bts::tab_Unselect {barID args} {
  # Removes few or all of multi-selections and redraws a bar.
  #   barID - ID of the bar
  #   args - list of tabID to unselect or {} if to unselect all

  if {[llength $args]} {
    set fewsel [bar_Cget $barID -FEWSEL]
    foreach tID $args {
      if {[set i [lsearch $fewsel $tID]]>-1} {
        set fewsel [lreplace $fewsel $i $i]
      }
    }
  } else {
    set fewsel {}
  }
  bar_Configure $barID -FEWSEL $fewsel
  bar_Draw $barID
}
#----------------------------------

proc bts::tab_Show {tabID {anyway no}} {
  # Shows a tab in a bar and sets it as current.
  #   tabID - ID of the tab
  #   anyway - if "yes", refill the bar anyway (for choosing from menu)

  set barID [lindex [tab_BarID $tabID] 0]
  if {$anyway} {bar_Clear $barID}
  set itab 0
  foreach tab [tab_List $barID]  {
    lassign $tab tID text wb wb1 wb2 pf
    if {$tabID==$tID} {
      set anyway [expr {$pf eq ""}]  ;# check if visible
      break
    }
    incr itab
  }
  if {$anyway} {Bar_Refill $barID $itab no yes}
  tab_Select $tabID
}
#----------------------------------

proc bts::tab_IDbyName {barID text} {
  # Searches for a tab ID by its text.
  #   barID - ID of the tab's bar
  #   text - a text of tab
  # Returns the tab's ID (if found) or -1 (if not).

  set ellipse [bar_Cget $barID -ELLIPSE]
  if {[string first $ellipse $text]} {
    set pattern [string map [list $ellipse "*"] $text]
  } else {
    set pattern ""
  }
  foreach tab [tab_List $barID] {
    lassign $tab tID ttxt
    if {$text eq $ttxt} {return $tID}
    if {$pattern ne "" && [string match $pattern $ttxt]} {return $tID}
  }
  return -1
}
#----------------------------------

proc bts::tab_Close {tabID {doupdate yes}} {
  # Closes (deletes) a tab and updates the bar.
  #   tabID - ID of the tab (if >-1, this is used to get the tab label)
  #   doupdate - if "yes", update the bar and select the new tab
  # Returns "yes" if the deletion was successful.

  lassign [tab_BarID $tabID] barID icurr
  if {![Bar_Command $barID $tabID -cdel]} {return no} ;# chosen to not close
  if {$doupdate} {bar_Clear $barID}
  lassign [bar_Cget $barID -TABS -tleft -tright -tabcurrent] tabs tleft tright tcurr
  Tab_RemoveLinks $barID $tabID
  destroy [tab_Cget $tabID -wb]
  set tabs [lreplace $tabs $icurr $icurr]
  bar_Configure $barID -TABS $tabs
  if {$doupdate} {
    if {$icurr>=$tleft && $icurr<$tright} {
      bar_Draw $barID
      tab_Select [lindex $tabs $icurr 0]
    } else {
      if {[set tabID [lindex $tabs end 0]] ne ""} {
        tab_Show $tabID 1 ;# last tab deleted: show a new last tab if any
      }
    }
  }
  return yes
}
#----------------------------------

proc bts::tab_CloseFew {barID {tabID -1} {left no}} {
  # Closes few tabs.
  #   tabID - ID of the current tab or -1 if to close all
  #   left - "yes" if to close all at left of tabID, "no" if at right

  if {$tabID!=-1} {lassign [tab_BarID $tabID] barID icur}
  set tabs [tab_List $barID]
  for {set i [llength $tabs]} {$i} {} {
    incr i -1
    set tID [lindex $tabs $i 0]
    if {$tabID==-1 || ($left && $i<$icur) || (!$left && $i>$icur)} {
      tab_Close $tID no
    }
  }
  bar_Clear $barID
  if {$tabID==-1} {
    Bar_Refill $barID 0 yes
  } else {
    lassign [tab_BarID $tabID] barID icur
    Bar_Refill $barID $icur $left
  }
}
#----------------------------------

proc bts::tab_Insert {barID txt {pos "end"} {img ""}} {
  # Inserts a tab into a bar.
  #   barID - ID of the bar
  #   txt - text of the tab
  #   pos - position of the tab in the tabs' list (e.g. 0, end)
  #   img - image of the tab
  # Returns ID of the created tab or 0.

  if {![Bar_Command $barID -1 -cnew]} {return 0} ;# chosen to not insert
  set tabs [bar_Cget $barID -TABS]
  set tab [Tab_Data $barID [Tab_Label $txt]]
  if {$tab eq ""} {return -1}
  if {$pos eq "end"} {
    lappend tabs $tab
  } else {
    set tabs [linsert $tabs $pos $tab]
  }
  Tab_RemoveLinks $barID -1 $txt
  if {$img ne ""} {
    set imagetabs [bar_Cget $barID -IMAGETABS]
    lappend imagetabs [list $txt $img]
    bar_Configure $barID -IMAGETABS $imagetabs
  }
  bar_Configure $barID -TABS $tabs
  Bar_Refill $barID $pos [expr {$pos ne "end"}]
  return [lindex $tab 0]
}
#----------------------------------

proc bts::tab_MarkList {barID} {
  # Gets a list of marked tabs.
  #   barID - ID of the bar
  # Returns a list of marked tab IDs.

  set res [list]
  foreach tab [tab_FlagList $barID] {
    lassign $tab tID text vis mark
    if {$mark} {lappend res $tID}
  }
  return $res
}
#----------------------------------

proc bts::tab_SelList {barID} {
  # Gets a list of selected tabs (with Ctrl+Button) and current tab ID.
  #   barID - ID of the bar
  # Returns a list of selected tab IDs and current tab ID.

  lassign [bar_Cget $barID -FEWSEL -tabcurrent] fewsel tcurr
  return [list $fewsel $tcurr]
}
#----------------------------------

proc bts::tab_List {barID} {
  # Gets a list of bar tabs.
  #   barID - ID of the bar
  # Returns a list "tabID, text, wb, wb1, wb2, pf".

  set res [list]
  foreach tab [bar_Cget $barID -TABS] {lappend res [Tab_DictItem $tab]}
  return $res
}

#----------------------------------

proc bts::tab_FlagList {barID} {
  # Gets a list of bar's tabs with flags "visible", "marked", "selected".
  #   barID - ID of the bar
  # Returns a list of items "tab ID, tab text, visible, marked, selected".

  lassign [bar_Cget $barID -marktabs -FEWSEL -tabcurrent] marktabs fewsel tcurr
  set res [list]
  foreach tab [tab_List $barID] {
    lassign $tab tabID text wb wb1 wb2 pf
    set visible [expr {[Tab_Is $wb] && $pf ne ""}]
    set marked [expr {[lsearch $marktabs $tabID]>=0}]
    set selected [expr {$tabID == $tcurr || [lsearch $fewsel $tabID]>-1}]
    lappend res [list $tabID $text $visible $marked]
  }
  return $res
}
#----------------------------------

proc bts::tab_Cget {tabID args} {
  # Gets options of the tab.
  #   tabID - ID of the tab
  #   args - list of option names (-text, -wb, -wb1, -wb2)
  # Returns a list of option values or an option value if args is one option.

  variable btData
  lassign [tab_BarID $tabID] barID i tab
  lassign $tab tID tdata
  set llen [dict get $btData $barID -LLEN]
  set res [list]
  foreach opt $args {
    switch -- $opt {
      -barID {lappend res $barID}
      -text - -wb - -wb1 - -wb2 - -pf {
        if {[catch {lappend res [dict get $tdata $opt]}]} {
          lappend res ""
        }
      }
      -llen {lappend res $llen}
      -index {if {$i<($llen-1)} {lappend res $i} {lappend res end}}
      -width {  ;# width of tab widget
        lassign [Tab_DictItem $tab] tID text wb wb1 wb2
        if {![Tab_Is $wb]} {
          lappend res 0
        } else {
          set b1 [ttk::style configure TLabel -borderwidth]
          if {$b1 eq ""} {set b1 0}
          lassign [bar_Cget $barID -bd -expand -static] bd expand static
          set bd [expr {$bd?2*$b1:0}]
          set b2 [expr {[Aux_WidgetWidth $wb2]-3}]
          set expand [expr {$expand||![Tab_Iconic $barID]?2:0}]
          lappend res [expr {[Aux_WidgetWidth $wb1]+$b2+$bd+$expand}]
        }
      }
      default {  ;# user's options
        if {[catch {lappend res [dict get $tdata $opt]}]} {lappend res ""}
      }
    }
  }
  if {[llength $args]==1} {return [lindex $res 0]}
  return $res
}
#----------------------------------

proc bts::tab_Configure {tabID args} {
  # Sets values of options of a tab.
  #   tabID - ID of the tab
  #   args - a list of pairs "option value", e.g. {-text "New name"}
  # To make the changes be active, bar_Draw or tab_Show is called.

  lassign [tab_BarID $tabID] barID i tab
  lassign $tab tID data
  foreach {opt val} $args {dict set data $opt $val}
  set tab [list $tabID $data]
  bar_Configure $barID -TABS [lreplace [bar_Cget $barID -TABS] $i $i $tab]
}

# ____________________________ Event handlers ___________________________ #

proc bts::onEnterTab {barID wb1 wb2 fgo bgo} {
  # Handles the mouse pointer entering a tab.
  #   barID - ID of the bar
  #   wb1 - tab's label
  #   wb2 - tab's button
  #   fgo - foreground of "mouse over the tab"
  #   bgo - background of "mouse over the tab"

  $wb1 configure -foreground $fgo -background $bgo
  if {[Tab_Iconic $barID]} {$wb2 configure -image bts::ImgClose}
}
#----------------------------------

proc bts::onLeaveTab {barID tabID wb1 wb2} {
  # Handles the mouse pointer leaving a tab.
  #   barID - ID of the bar
  #   tabID ID of the tab
  #   wb1 - tab's label
  #   wb2 - tab's button

  if {![winfo exists $wb1] || ![tab_Exists $tabID]} return
  lassign [bar_Cget $barID -FGMAIN -BGMAIN] fgm bgm
  $wb1 configure -foreground $fgm -background $bgm
  Tab_MarkBars $barID
  if {"-image" ni [set attrs [Tab_ImageMarkAttrs $barID $tabID 0 $wb2]] && \
  [Tab_Iconic $barID]} {
    $wb2 configure -image bts::ImgNone
  }
}
#----------------------------------

proc bts::onButtonPress {barID wb1 x} {
  # Handles the mouse clicking a tab.
  #   barID - ID of the bar
  #   wb1 - tab's label
  #   x - x position of the mouse pointer

  bar_Configure $barID -MOVX $x
  set tabID [tab_IDbyName $barID [$wb1 cget -text]]
  tab_Select $tabID
}
#----------------------------------

proc bts::onButtonMotion {barID wb1 x y} {
  # Handles the mouse moving over a tab.
  #   barID - ID of the bar
  #   wb1 - tab's label
  #   x - x position of the mouse pointer
  #   y - y position of the mouse pointer

  lassign [bar_Cget $barID \
    -static -FGMAIN -FGOVER -BGOVER -MOVWIN -MOVX -MOVX0 -MOVY0] \
    static fgm fgo bgo movWin movX movx movY0
  if {$movX eq "" || $static} return
  # dragging the tab
  if {![winfo exists $movWin]} {
    # make the tab's replica to be dragged
    toplevel $movWin
    if {[tk windowingsystem] eq "aqua"} {
      ::tk::unsupported::MacWindowStyle style $movWin help none
    } else {
      wm overrideredirect $movWin 1
    }
    bind $movWin <Leave> "destroy $movWin"
    set movx [set movx1 $x]
    set movX [expr {[winfo pointerx .]-$x}]
    set movY0 [expr {[winfo pointery .]-$y}]
    label $movWin.label -text [$wb1 cget -text] \
      -foreground $fgo -background $bgo  {*}[Tab_Font $barID]
    pack $movWin.label -ipadx 1
    $wb1 configure -foreground $fgm
    bar_Configure $barID -wb1 $wb1 -MOVX1 $movx1 -MOVY0 $movY0
  }
  wm geometry $movWin +$movX+$movY0
  bar_Configure $barID -MOVX [expr {$movX+$x-$movx}] -MOVX0 $x
}
#----------------------------------

proc bts::onButtonRelease {barID wb1o x} {
  # Handles the mouse releasing a tab.
  #   barID - ID of the bar
  #   wb1o - original tab's label
  #   x - x position of the mouse pointer

  lassign [bar_Cget $barID \
    -MOVWIN -MOVX -MOVX1 -MOVY0 -FGMAIN -wb1 -tleft -tright -wbar -static] \
    movWin movX movx1 movY0 fgm wb1 tleft tright wbar static
  bar_Configure $barID -MOVX "" -wb1 ""
  if {[winfo exists $movWin]} {destroy $movWin}
  if {$movX eq "" || $wb1o ne $wb1 || $static} return
  # dropping the tab - find a tab being dropped at
  $wb1 configure -foreground $fgm
  lassign [Aux_InitDraw $barID no] bwidth vislen bd arrlen llen
  set vislen1 $vislen
  set vlist [list]
  set i 0
  set iw1 -1
  set tabssav [set tabs [bar_Cget $barID -TABS]]
  foreach tab $tabs {
    lassign [Tab_DictItem $tab] tID text _wb _wb1 _wb2 _pf
    if {$_pf ne ""} {
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
    Bar_Refill $barID $tleft $left
  }
}
#----------------------------------

proc bts::onCtrlButton {barID tabID} {
  # Handles a selection of few tabs with Ctrl key + click.
  #   barID - ID of the bar
  #   tabID - ID of the current tab

  lassign [bar_Cget $barID -static -FEWSEL] static fewsel
  if {$static} return
  if {[set i [lsearch $fewsel $tabID]]>-1} {
    set fewsel [lreplace $fewsel $i $i]
  } else {
    lappend fewsel $tabID
  }
  bar_Configure $barID -FEWSEL $fewsel
  Tab_MarkBar $barID
}
#----------------------------------

proc bts::onPopup {barID tabID X Y} {
  # Handles the mouse right-clicking on a tab.
  #   barID - ID of the bar
  #   tabID - ID of the tab
  #   X - x position of the mouse pointer
  #   Y - y position of the mouse pointer

  lassign [bar_Cget $barID -wbar -menu -USERMNU -TABS -static -hidearrows -WWID] \
    wbar popup usermnu tabs static hidearr wwid
  if {$static && $hidearr && !$usermnu} {
    lassign $wwid wframe wlarr wrarr
    if {[catch {pack info $wlarr}] && [catch {pack info $wrarr}]} {
      return ;# static absolutely
    }
  }
  set textcur [tab_Cget $tabID -text]
  set pop $wbar.popupMenu
  if {[winfo exist $pop]} {destroy $pop}
  menu $pop -tearoff 0
  set ilist [list]
  foreach p $popup {
    lassign $p typ label comm menu dsbl
    if {$menu ne ""} {set popc $pop.$menu} {set popc $pop}
    foreach opt {label comm menu dsbl} {
      set $opt [string map [list %b $barID %t $tabID %l $textcur] [set $opt]]
    }
    if {[info commands $dsbl] ne ""} {
      ;# 0/1/2 image label hotkey
      lassign [$dsbl $barID $tabID $label] dsbl comimg comlabel hotk
    } else {
      lassign $dsbl dsbl comimg comlabel hotk
      set dsbl [expr {([string is boolean $dsbl] && $dsbl ne "")?$dsbl:0}]
    }
    if {$dsbl eq "2"} continue  ;# 2 - "hide"; 1 - "disable"; 0 - "normal"
    if {$dsbl} {set dsbl "-state disabled"} {set dsbl ""}
    if {$comimg ne ""} {set comimg "-image $comimg"}
    if {$comlabel ne ""} {set label $comlabel}
    if {$comimg eq ""} {set comimg "-image bts::ImgNone"}
    if {$hotk ne ""} {set hotk "-accelerator $hotk"}
    switch [string index $typ 0] {
      "s" {$popc add separator}
      "c" {
        $popc add command -label $label -command $comm \
          {*}$dsbl -compound left {*}$comimg {*}$hotk
      }
      "m" {
        if {$menu eq "bartabs_cascade" && !$usermnu && $static} {
          set popc $pop  ;# no user mnu & static: only list of tabs be shown
        } else {
          menu $popc -tearoff 0
          set popm [string range $popc 0 [string last . $popc]-1]
          $popm add cascade -label $label -menu $popc \
            {*}$dsbl -compound left {*}$comimg {*}$hotk
        }
        if {[string match "bartabs_cascade*" $menu]} {
          set popi $popc
          lappend lpopi $popi
          set ilist [Bar_PopupFillList $barID $popi $tabID $menu]
        }
      }
    }
  }
  foreach popi $lpopi {Bar_PopupTuneList $barID $tabID $popi $ilist $pop}
  lassign [tab_Cget $tabID -wb1 -wb2] wb1 wb2
  bind $pop <Unmap> [list bts::onLeaveTab $barID $tabID $wb1 $wb2]
  tk_popup $pop $X $Y
}

# _________________________ Auxiliary procedures ________________________ #

proc bts::Aux_WidgetWidth {w} {
  # Calculates the width of a widget
  #   w - the widget's path

  if {![winfo exists $w]} {return 0}
  set wwidth [winfo width $w]
  if {$wwidth<2} {set wwidth [winfo reqwidth $w]}
  return $wwidth
}
#----------------------------------

proc bts::Aux_InitDraw {barID {clearpf yes}} {
  # Auxiliary procedure used before the cycles drawing tabs.
  #   barID - ID of the tab's bar
  #   clearpf - if "yes", clear the "-pf" attributes of tabs

  Bar_InitColors $barID
  lassign [bar_Cget $barID \
    -tleft -hidearrows -LLEN -WWID -bd -wbase -wbar -ARRLEN -wproc] \
    tleft hidearr llen wwid bd wbase wbar arrlen wproc
  lassign $wwid wframe wlarr
  if {$arrlen eq ""} {
    set arrlen [winfo reqwidth $wlarr]
    bar_Configure $barID -wbase $wbase -ARRLEN $arrlen
  }
  set bwidth [Bar_Width $barID]
  set vislen [expr {$tleft || !$hidearr ? $arrlen : 0}]
  set tabs [bar_Cget $barID -TABS]
  if {$clearpf} {foreach tab $tabs {tab_Configure [lindex $tab 0] -pf ""}}
  return [list $bwidth $vislen $bd $arrlen $llen $tleft $hidearr $tabs $wframe]
}
#----------------------------------

proc bts::Aux_CheckTabVisible {wb wb1 wb2 i tleft trightN vislenN llen hidearr arrlen bd bwidth tabsN tabID text} {
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
  # Returns "yes", if the tab is visible.

  upvar 1 $trightN tright $tabsN tabs $vislenN vislen
  incr vislen [tab_Cget $tabID -width]
  if {$i>$tleft && ($vislen+(($i+1)<$llen||!$hidearr?$arrlen:0))>$bwidth} {
    pack forget $wb
    set pf ""
  } else {
    set tright $i
    set pf "p"
  }
  tab_Configure $tabID -wb $wb -wb1 $wb1 -wb2 $wb2 -pf $pf
  return [string length $pf]
}
#----------------------------------

proc bts::Aux_EndDraw {barID tleft tright llen} {
  # Auxiliary procedure used after the cycles drawing tabs.
  #   barID - ID of the tab's bar
  #   tleft - left tab's index to be shown
  #   tright - right tab's index to be shown
  #   llen - length of tabs' list

  Bar_ArrowsState $barID $tleft $tright [expr {$tright < ($llen-1)}]
  bar_Configure $barID -tleft $tleft -tright $tright
  Tab_Bindings $barID
  Tab_MarkBar $barID
}
#----------------------------------

proc bts::Aux_IndexInList {ID lst} {
  # Searches ID in a list.
  #   ID - ID
  #   lst - dictionary
  # Returns index of ID if found or -1 if not found.

  set i 0
  foreach it $lst {
    if {[lindex $it 0]==$ID} {return $i}
    incr i
  }
  return -1
}

# _________________________________ EOF _________________________________ #

#RUNF0: test.tcl     ;# to test from e_menu without switching to test*.tcl
#RUNF1: ../tests/test2_pave.tcl
