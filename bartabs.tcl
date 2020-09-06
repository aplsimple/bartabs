# _______________________________________________________________________ #
#
# The tab bar widget.
#
# Scripted by Alex Plotnikov (aplsimple@gmail.com).
# License: MIT.
# _______________________________________________________________________ #

package require Tk
package provide bartabs 1.0b7
catch {package require tooltip} ;# optional (though necessary everywhere:)

# __________________ Common data of bartabs:: namespace _________________ #

namespace eval bartabs {

  # IDs for new bars & tabs
  variable NewBarID 0 NewTabID 0 NewTabNo 0

  # images used by bartabs, made by base64
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

# __________________ Declaring bartabs class hierarchy __________________ #

oo::class create ::bartabs::Tab {
}

oo::class create ::bartabs::Bar {
  superclass ::bartabs::Tab
}

oo::class create ::bartabs::Bars {
  superclass ::bartabs::Bar
}

# ________________________ Private methods of Tab _______________________ #

oo::define ::bartabs::Tab {

method My {ID} {
  # Creates a caller of method.
  #   ID - ID of the caller
  # Returns the caller's name.

  oo::objdefine [self] "method $ID {args} {set m \[lindex \$args 0\]
if {\$m in {cget configure} && {[string range $ID 0 2]} eq {tab}} {
set args \[lreplace \$args 0 0 Tab_\$m\]}
return \[my {*}\$args\]}"
}
#__________

method ID {} {
  # Gets ID of caller.

  return [lindex [uplevel 1 {self caller}] 2]
}
#__________

method IDs {TID} {
  # Returns a list of tab and bar IDs.
  #   TID tab's ID

  return [list $TID [my $TID cget -BID]]
}
#__________

method Tab_Create {BID TID w text} {
  # Creates a tab widget (consisting of a frame, a label, a button).
  #   BID - bar ID
  #   TID - tab ID
  #   w - a parent frame's name
  #   text - a text of tab
  # Returns a list of created widgets of the tab (frame, label, button).

  lassign [my $BID cget -relief -bd -padx -pady] relief bd padx pady
  set bd [expr {$bd?1:0}]
  lassign [my $TID cget -wb -wb1 -wb2] wb wb1 wb2
  if {![my Tab_Is $wb]} {
    if {$wb eq ""} {
      set ::bartabs::NewTabNo [expr {($::bartabs::NewTabNo+1)%10000000}]
      set wb $w.$TID[format %07d $::bartabs::NewTabNo]
      set wb1 $wb.l
      set wb2 $wb.b
    }
    my $TID configure -wb $wb -wb1 $wb1 -wb2 $wb2
    ttk::frame $wb -relief $relief -borderwidth $bd
    ttk::label $wb1 -relief flat -padding "$padx $pady $padx $pady" \
      {*}[my Tab_Font $BID]
    ttk::button $wb2 -style ClButton$BID -image ::bartabs::ImgNone \
      -command [list [self] $TID tab_Close] -takefocus 0
  } else {
    $wb configure -relief $relief -borderwidth $bd
    $wb1 configure -relief flat -padding "$padx $pady $padx $pady" \
      {*}[my Tab_Font $BID]
  }
  lassign [my Tab_TextEllipsed $BID $text] text ttip
  catch {tooltip::tooltip $wb1 $ttip; tooltip::tooltip $wb2 $ttip}
  $wb1 configure -text $text
  if {[my Tab_Iconic $BID]} {
    $wb2 configure -state normal
  } else {
    $wb2 configure -state disabled -image {}
  }
  return [list $wb $wb1 $wb2]
}
#__________

method Tab_DictItem {TID {data ""}} {
  # Gets a tab item data from a dictionary item (ID + data).
  #   TID - tab ID or the tab item (ID + data).
  #   data - the tab's data (list of option-value pairs)
  # If 'data' argument omitted, TID is a dictionary item (ID + data).
  # If the tab's attribute is absent, it's considered being empty ("").
  # Returns a list of attributes: "ID, text, wb, wb1, wb2, pf".

  if {$data eq ""} {lassign $TID TID data}
  set res [list $TID]
  foreach a {-text -wb -wb1 -wb2 -pf} {
    if {[dict exists $data $a]} {
      lappend res [dict get $data $a]
    } else {
      lappend res ""
    }
  }
  return $res
}
#__________

method Tab_ItemDict {TID text {wb ""} {wb1 ""} {wb2 ""} {pf ""}} {
  # Gets a dictionary item (ID + data) from a tab item data.
  #   TID - tab ID
  #   text - text of tab's label;
  #   wb - tab's frame
  #   wb1 - tab's label
  #   wb2 - tab's button
  #   pf - "p" if the tab under pack or "" if pack forget
  # Returns a dictionary tab item containing ID and a dictionary of attributes.

  return [list $TID [list -text $text -wb $wb -wb1 $wb1 -wb2 $wb2 -pf $pf]]
}
#__________

method Tab_Data {BID text} {
  # Creates data of a new tab.
  #   BID - ID of the new tab's bar
  #   text - the new tab's text
  # For sure, the bar is checked for a duplicate of the 'text'.
  # Returns a tab item or "" (if duplicated).

  variable btData
  if {[dict exists $btData $BID] && [my $BID getTabID $text] ne ""} {return ""}
  my My tab[incr ::bartabs::NewTabID]
  return [my Tab_ItemDict tab$::bartabs::NewTabID $text]
}
#__________

method Tab_BID {TID {act ""}} {
  # Gets BID from TID.
  #   TID - tab ID
  #   act - if "check", only checks the existance of TID
  # If 'act' is "check" and a bar not found, -1 is returned, otherwise bar ID.
  # Returns a list containing 1) bar's ID (or -1 if no bar found) 2) index of
  # the tab in tabs' list 3) the found tab data.

  variable btData
  set BID ""
  dict for {bID bInfo} $btData {
    set tabs [my $bID cget -TABS]
    if {[set i [my Aux_IndexInList $TID $tabs]] > -1} {
      set BID $bID
      break
    }
  }
  if {$act eq "check"} {return $BID}
  if {$BID eq ""} {
    return -code error "bartabs: tab ID $TID not found in the bars"
  }
  return [list $BID $i [lindex $tabs $i]]
}
#__________

method Tab_Bindings {BID} {
  # Sets bindings on events of tabs.
  #   BID - bar ID

  lassign [my $BID cget -static -FGOVER -BGOVER] static fgo bgo
  foreach tab [my $BID listTab] {
    lassign $tab TID text wb wb1 wb2
    if {[my Tab_Is $wb]} {
      set bar "[self] $BID"
      set tab "[self] $TID"
      set ctrlBP "$tab OnCtrlButton ; break"
      foreach w [list $wb $wb1 $wb2] {
        bind $w <Enter> "$bar OnEnterTab $wb1 $wb2 $fgo $bgo"
        bind $w <Leave> "[self] $TID OnLeaveTab $wb1 $wb2"
        bind $w <Button-3> "[self] $TID OnPopup %X %Y"
        bind $w <Control-ButtonPress> $ctrlBP
      }
      bind $wb <Control-ButtonPress> $ctrlBP
      bind $wb <ButtonPress> "[self] $BID OnButtonPress $wb1 {}"
      bind $wb1 <ButtonPress> "[self] $BID OnButtonPress $wb1 %x"
      bind $wb1 <ButtonRelease> "[self] $BID OnButtonRelease $wb1 %x"
      bind $wb1 <Motion> "[self] $BID OnButtonMotion $wb1 %x %y"
    }
  }
}
#__________

method Tab_Font {BID} {
  # Gets a font option for a tab label.
  #   BID - bar ID

  set font [my $BID cget -font]
  if {$font eq ""} {
    if {[set font [ttk::style configure TLabel -font]] eq ""} {
      set font TkDefaultFont
    }
    set font [font configure $font]
  }
  return "-font {$font}"
}
#__________

method Tab_ImageMarkAttrs {BID TID {withbg yes} {wb2 ""}} {
  # Gets image & mark attributes of marks.
  #   BID - bar ID
  #   TID - ID of the current tab
  #   withbg - if true, gets also background
  #   wb2 - path to a button
  # Returns string of mark attributes or empty string.

  lassign [my $BID cget \
    -marktabs -imagemark -fgmark -bgmark -IMAGETABS -FGMAIN -BGMAIN] \
    marktabs imagemark fgm bgm imagetabs fgmain bgmain
  set res ""
  if {[lsearch $marktabs $TID]>-1} {
    if {$imagemark eq ""} {
      if {$fgm eq ""} {set fgm $fgmain}  ;# empty value - no markable tabs
      set res " -foreground $fgm"
      if {$withbg} {
        if {$bgm eq ""} {set bgm $bgmain}
        append res " -background $bgm"
      }
      if {$wb2 ne ""} {$wb2 configure -image ::bartabs::ImgNone}
    }
  } else {
    set imagemark ""
    set text [my $TID cget -text] 
    if {[set i [lsearch -index 0 -exact $imagetabs $text]]>-1} {
      set imagemark [lindex $imagetabs $i 1]
    } elseif {$wb2 ne ""} {
      $wb2 configure -image ::bartabs::ImgNone
    }
  }
  if {$imagemark ne ""} {
    set res " -image $imagemark -compound left"
    if {$wb2 ne ""} {$wb2 configure {*}$res}
  }
  return $res
}
#__________

method Tab_SelAttrs {fnt fgsel bgsel} {
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
#__________

method Tab_MarkBar {BID {TID -1}} {
  # Marks the tabs of a bar with color & underlining.
  #   BID - bar ID
  #   TID - ID of the current tab

  lassign [my $BID cget -tabcurrent -fgsel -bgsel -FEWSEL -FGMAIN -BGMAIN] \
    tID fgs bgs fewsel fgm bgm
  if {$TID in {"" "-1"}} {set TID $tID}
  foreach tab [my $BID listTab] {
    lassign $tab tID text wb wb1 wb2
    if {[my Tab_Is $wb]} {
      set font [my Tab_Font $BID]
      set selected [expr {$tID == $TID || [lsearch $fewsel $tID]>-1}]
      if {$selected} {set font [my Tab_SelAttrs $font $fgs $bgs]}
      $wb1 configure {*}$font
      set attrs [my Tab_ImageMarkAttrs $BID $tID [expr {!$selected}] $wb2]
      if {$attrs ne "" && "-image" ni $attrs } {
        $wb1 configure {*}$attrs
      } elseif {!$selected} {
        $wb1 configure -foreground $fgm -background $bgm
      }
    }
  }
  my $BID configure -tabcurrent $TID
}
#__________

method Tab_MarkBars {{BID -1} {TID -1}} {
  # Marks the tabs with color & underlinement.
  #   BID - bar ID (if omitted, all bars are scanned)
  #   TID - ID of the current tab

  variable btData
  if {$BID == -1} {
    dict for {BID barInfo} $btData {my Tab_MarkBar $BID}
  } else {
    my Tab_MarkBar $BID $TID
  }
}
#__________

method Tab_TextEllipsed {BID text {lneed -1}} {
  # Gets a tab's label (possibly ellipsed) and tooltip
  #   BID - bar ID
  #   text - text of tab label
  #   lneed - label length anyway
  # Returns a pair "label tooltip".

  lassign [my $BID cget -lablen -ELLIPSE] lablen ellipse
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
#__________

method Tab_Iconic {BID} {
  # Gets a flag "tabs with icons".
  #   BID - bar ID
  # Returns "yes", if tabs are supplied with icons.

  lassign [my $BID cget -static -IMAGETABS] static imagetabs
  return [expr {!$static}]
  #return [expr {[llength $imagetabs] || !$static}]
}
#__________

method Tab_Pack {BID TID wb wb1 wb2} {
  # Packs a tab widget.
  #   BID - bar ID
  #   TID - tab ID
  #   wb - frame
  #   wb1 - label
  #   wb2 - button

  lassign [my $BID cget -static -expand] static expand
  if {[my Tab_Iconic $BID]} {
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
  my $TID configure -pf "p"
}
#__________

method Tab_RemoveLinks {BID TID {txt ""}} {
  # Removes a tab's links from the internal lists.
  #   BID - bar ID
  #   TID - tab ID or -1, if for the tab's text only
  #   txt - tab's text

  set imagetabs [my $BID cget -IMAGETABS]
  if {$TID>-1} {set txt [my $TID cget -text]}
  if {[set i [lsearch -index 0 -exact $imagetabs $txt]]>-1} {
    set imagetabs [lreplace $imagetabs $i $i]
    my $BID configure -IMAGETABS $imagetabs
  }
  if {$TID>-1} {my unmark $TID}
}
#__________

method Tab_Is {wb} {
  # Checks if 'wb' is a path to an existing tab.
  #   wb - path to be checked

  return [expr {$wb ne "" && [winfo exists $wb]}]
}
#__________

method Tab_CloseFew {{TID -1} {left no}} {
  # Closes few tabs of bar.
  #   TID - ID of the current tab or -1 if to close all
  #   left - "yes" if to close all at left of TID, "no" if at right

  set BID [my ID]
  if {$TID!=-1} {lassign [my Tab_BID $TID] BID icur}
  set tabs [my $BID listTab]
  for {set i [llength $tabs]} {$i} {} {
    incr i -1
    set tID [lindex $tabs $i 0]
    if {$TID==-1 || ($left && $i<$icur) || (!$left && $i>$icur)} {
      my $tID tab_Close no
    }
  }
  my $BID clear
  if {$TID==-1} {
    my $BID Refill 0 yes
  } else {
    lassign [my Tab_BID $TID] BID icur
    my $BID Refill $icur $left
  }
}
#__________

method Tab_Cmd {opt} {
  # Executes a command bound to an action on a tab.
  #   opt - command option (-csel, -cmov, -cdel)
  # The commands can include wildcards: %b for bar ID, %t for tab ID,
  # %l for tab label. 
  # Returns "yes", if no command set or the command returned "yes".

  variable btData
  lassign [my IDs [my ID]] TID BID
  if {[dict exists $btData $BID $opt]} {
    set com [dict get $btData $BID $opt]
    if {$TID>-1} {
      set label [my $TID cget -text]
    } else {
      set label ""
    }
    set label [string map {\{ ( \} )} $label]
    set com [string map [list %b $BID %t $TID %l $label] $com]
    if {[catch {set res [{*}$com]}]} {set res yes}
    if {$res eq "" || !$res} {return no} ;# chosen "don't"
  }
  return yes
}
#__________

method Tab_cget {args} {
  # Gets options of the tab.
  #   args - list of option names (-text, -wb, -wb1, -wb2)
  # Returns a list of option values or an option value if args is one option.

  variable btData
  lassign [my Tab_BID [set TID [my ID]]] BID i tab
  lassign $tab tID tdata
  set llen [dict get $btData $BID -LLEN]
  set res [list]
  foreach opt $args {
    switch -- $opt {
      -BID {lappend res $BID}
      -text - -wb - -wb1 - -wb2 - -pf {
        if {[catch {lappend res [dict get $tdata $opt]}]} {
          lappend res ""
        }
      }
      -index {if {$i<($llen-1)} {lappend res $i} {lappend res end}}
      -width {  ;# width of tab widget
        lassign [my Tab_DictItem $tab] tID text wb wb1 wb2
        if {![my Tab_Is $wb]} {
          lappend res 0
        } else {
          set b1 [ttk::style configure TLabel -borderwidth]
          if {$b1 eq ""} {set b1 0}
          lassign [my $BID cget -bd -expand -static] bd expand static
          set bd [expr {$bd?2*$b1:0}]
          set b2 [expr {[my Aux_WidgetWidth $wb2]-3}]
          set expand [expr {$expand||![my Tab_Iconic $BID]?2:0}]
          lappend res [expr {[my Aux_WidgetWidth $wb1]+$b2+$bd+$expand}]
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
#__________

method Tab_configure {args} {
  # Sets values of options of a tab.
  #   args - a list of pairs "option value", e.g. {-text "New name"}
  # To make the changes be active, bar's draw or tab's show is called.

  lassign [my Tab_BID [set TID [my ID]]] BID i tab
  lassign $tab tID data
  foreach {opt val} $args {dict set data $opt $val}
  set tab [list $TID $data]
  my $BID configure -TABS [lreplace [my $BID cget -TABS] $i $i $tab]
}
#__________

method Tab_BeCurrent {} {
  # Makes the tab be current.

  if {[set TID [my ID]] in {"" "-1"}} return
  set BID [my $TID cget -BID]
  my $TID Tab_Cmd -csel
  my Tab_MarkBar $BID $TID
  if {[set wb2 [my $TID cget -wb2]] ne "" && \
  ![string match "::bartabs::*" [$wb2 cget -image]] &&
  $TID ni [my $BID listMark]} {
    $wb2 configure -image ::bartabs::ImgNone
  }
}

# ____________________________ Event handlers ___________________________ #

method OnEnterTab {wb1 wb2 fgo bgo} {
  # Handles the mouse pointer entering a tab.
  #   wb1 - tab's label
  #   wb2 - tab's button
  #   fgo - foreground of "mouse over the tab"
  #   bgo - background of "mouse over the tab"

  $wb1 configure -foreground $fgo -background $bgo
  if {[my Tab_Iconic [my ID]]} {$wb2 configure -image ::bartabs::ImgClose}
}
#__________

method OnLeaveTab {wb1 wb2} {
  # Handles the mouse pointer leaving a tab.
  #   wb1 - tab's label
  #   wb2 - tab's button

  lassign [my IDs [my ID]] TID BID
  if {![winfo exists $wb1]} return
  lassign [my $BID cget -FGMAIN -BGMAIN] fgm bgm
  $wb1 configure -foreground $fgm -background $bgm
  my Tab_MarkBars $BID
  if {"-image" ni [set attrs [my Tab_ImageMarkAttrs $BID $TID 0 $wb2]] && \
  [my Tab_Iconic $BID]} {
    $wb2 configure -image ::bartabs::ImgNone
  }
}
#__________

method OnButtonPress {wb1 x} {
  # Handles the mouse clicking a tab.
  #   wb1 - tab's label
  #   x - x position of the mouse pointer

  my [set BID [my ID]] configure -MOVX $x
  set TID [my $BID getTabID [$wb1 cget -text]]
  my $TID Tab_BeCurrent
}
#__________

method OnButtonMotion {wb1 x y} {
  # Handles the mouse moving over a tab.
  #   wb1 - tab's label
  #   x - x position of the mouse pointer
  #   y - y position of the mouse pointer

  lassign [my [set BID [my ID]] cget \
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
      -foreground $fgo -background $bgo  {*}[my Tab_Font $BID]
    pack $movWin.label -ipadx 1
    $wb1 configure -foreground $fgm
    my $BID configure -wb1 $wb1 -MOVX1 $movx1 -MOVY0 $movY0
  }
  wm geometry $movWin +$movX+$movY0
  my $BID configure -MOVX [expr {$movX+$x-$movx}] -MOVX0 $x
}
#__________

method OnButtonRelease {wb1o x} {
  # Handles the mouse releasing a tab.
  #   wb1o - original tab's label
  #   x - x position of the mouse pointer

  lassign [my [set BID [my ID]] cget \
    -MOVWIN -MOVX -MOVX1 -MOVY0 -FGMAIN -wb1 -tleft -tright -wbar -static] \
    movWin movX movx1 movY0 fgm wb1 tleft tright wbar static
  my $BID configure -MOVX "" -wb1 ""
  if {[winfo exists $movWin]} {destroy $movWin}
  if {$movX eq "" || $wb1o ne $wb1 || $static} return
  # dropping the tab - find a tab being dropped at
  $wb1 configure -foreground $fgm
  lassign [my Aux_InitDraw $BID no] bwidth vislen bd arrlen llen
  set vislen1 $vislen
  set vlist [list]
  set i 0
  set iw1 -1
  set tabssav [set tabs [my $BID cget -TABS]]
  foreach tab $tabs {
    lassign [my Tab_DictItem $tab] tID text _wb _wb1 _wb2 _pf
    if {$_pf ne ""} {
      if {$_wb1 eq $wb1} {
        set vislen0 $vislen
        set tab1 $tab
        set iw1 $i
        set TID $tID
      }
      set wl [expr {[winfo reqwidth $_wb1]+[winfo reqwidth $_wb2]}]
      lappend vlist [list $i $vislen $wl]
      incr vislen $wl
    }
    incr i
  }
  if {$iw1==-1} return  ;# for sure
  if {![my $TID Tab_Cmd -cmov]} return ;# chosen to not move
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
    my $BID configure -TABS $tabs
    my $BID Refill $tleft $left
  }
}
#__________

method OnCtrlButton {} {
  # Handles a selection of few tabs with Ctrl key + click.

  lassign [my IDs [my ID]] TID BID
  lassign [my $BID cget -static -FEWSEL] static fewsel
  if {$static} return
  if {[set i [lsearch $fewsel $TID]]>-1} {
    set fewsel [lreplace $fewsel $i $i]
  } else {
    lappend fewsel $TID
  }
  my $BID configure -FEWSEL $fewsel
  my Tab_MarkBar $BID
}
#__________

method OnPopup {X Y} {
  # Handles the mouse right-clicking on a tab.
  #   X - x position of the mouse pointer
  #   Y - y position of the mouse pointer

  lassign [my IDs [my ID]] TID BID
  lassign [my $BID cget -wbar -menu -USERMNU -TABS -static -hidearrows -WWID] \
    wbar popup usermnu tabs static hidearr wwid
  if {$static && $hidearr && !$usermnu} {
    lassign $wwid wframe wlarr wrarr
    if {[catch {pack info $wlarr}] && [catch {pack info $wrarr}]} {
      return ;# static absolutely
    }
  }
  set textcur [my $TID cget -text]
  set pop $wbar.popupMenu
  if {[winfo exist $pop]} {destroy $pop}
  menu $pop -tearoff 0
  set ilist [list]
  foreach p $popup {
    lassign $p typ label comm menu dsbl
    if {$menu ne ""} {set popc $pop.$menu} {set popc $pop}
    foreach opt {label comm menu dsbl} {
      set $opt [string map [list %b $BID %t $TID %l $textcur] [set $opt]]
    }
    if {[info commands [lindex $dsbl 0]] ne ""} {
      ;# 0/1/2 image label hotkey
      lassign [{*}$dsbl $BID $TID $label] dsbl comimg comlabel hotk
    } else {
      lassign $dsbl dsbl comimg comlabel hotk
      set dsbl [expr {([string is boolean $dsbl] && $dsbl ne "")?$dsbl:0}]
    }
    if {$dsbl eq "2"} continue  ;# 2 - "hide"; 1 - "disable"; 0 - "normal"
    if {$dsbl} {set dsbl "-state disabled"} {set dsbl ""}
    if {$comimg ne ""} {set comimg "-image $comimg"}
    if {$comlabel ne ""} {set label $comlabel}
    if {$comimg eq ""} {set comimg "-image ::bartabs::ImgNone"}
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
          if {[winfo exist $popc]} {destroy $popc}
          menu $popc -tearoff 0
          set popm [string range $popc 0 [string last . $popc]-1]
          $popm add cascade -label $label -menu $popc \
            {*}$dsbl -compound left {*}$comimg {*}$hotk
        }
        if {[string match "bartabs_cascade*" $menu]} {
          set popi $popc
          lappend lpopi $popi
          set ilist [my $BID PopupFillList $popi $TID $menu]
        }
      }
    }
  }
  foreach popi $lpopi {my Bar_PopupTuneList $BID $TID $popi $ilist $pop}
  lassign [my $TID cget -wb1 -wb2] wb1 wb2
  bind $pop <Unmap> [list [self] $TID OnLeaveTab $wb1 $wb2]
  tk_popup $pop $X $Y
}

# _________________________ Public methods of Tab _______________________ #

method tab_Exists {TID} {
  # Checks if a tab object exists.
  #   TID - tab ID
  # Returns true if the tab exists, otherwise returns false.

  return [expr {[my Tab_BID $TID check] ne ""}]
}
#__________

method tab_Show {{anyway no}} {
  # Shows a tab in a bar and sets it as current.
  #   anyway - if "yes", refill the bar anyway (for choosing from menu)

  lassign [my IDs [my ID]] TID BID
  if {$anyway} {my $BID clear}
  set itab 0
  foreach tab [my $BID listTab]  {
    lassign $tab tID text wb wb1 wb2 pf
    if {$TID==$tID} {
      set anyway [expr {$pf eq ""}]  ;# check if visible
      break
    }
    incr itab
  }
  if {$anyway} {my $BID Refill $itab no yes}
  my $TID Tab_BeCurrent
}
#__________

method tab_Close {{doupdate yes}} {
  # Closes (deletes) a tab and updates the bar.
  #   doupdate - if "yes", update the bar and select the new tab
  # Returns "yes" if the deletion was successful.

  lassign [my Tab_BID [set TID [my ID]]] BID icurr
  if {![my $TID Tab_Cmd -cdel]} {return no} ;# chosen to not close
  if {$doupdate} {my $BID clear}
  lassign [my $BID cget -TABS -tleft -tright -tabcurrent] tabs tleft tright tcurr
  my Tab_RemoveLinks $BID $TID
  destroy [my $TID cget -wb]
  set tabs [lreplace $tabs $icurr $icurr]
  my $BID configure -TABS $tabs
  if {$doupdate} {
    if {$icurr>=$tleft && $icurr<$tright} {
      my $BID draw
      my [lindex $tabs $icurr 0] Tab_BeCurrent
    } else {
      if {[set TID [lindex $tabs end 0]] ne ""} {
        my $TID tab_Show 1 ;# last tab deleted: show a new last tab if any
      }
    }
  }
  return yes
}
} ;# --- bartabs::Tab

# ________________________ Private methods of Bar _______________________ #

oo::define ::bartabs::Bar {

method Bar_Data {barOptions} {
  # Puts data of a new bar in btData dictionary.
  #   barOptions - the new bar's options
  # Returns ID of the new bar.

  variable btData
  set BID bar[incr ::bartabs::NewBarID]
  # set defaults:
  set barinfo [dict create -wbar ""  -wbase "" -wproc "" \
    -static no -hidearrows no -redraw 1 -scrollsel yes -lablen 0 -tiplen 0 \
    -tleft 0 -tright end -tabcurrent -1 -marktabs [list] -fgmark #800080 \
    -relief groove -fgsel "." -bd 1 -padx 2 -pady 4 -expand 1 \
    -ELLIPSE "\u2026" -MOVWIN ".bt_move" -ARRLEN 0 -USERMNU 0]
  set tabinfo [set imagetabs [set popup [list]]]
  my Bar_PopupInfo $BID popup
  foreach {optnam optval} $barOptions {
    switch -exact -- $optnam {
      -tab {
        # no duplicate tabs allowed:
        if {[lsearch -index {1 1} -exact $tabinfo $optval]==-1} {
          lappend tabinfo [my Tab_Data $BID $optval]
          dict set barinfo -TABS $tabinfo
          dict set barinfo -LLEN [llength $tabinfo]
        }
      }
      -imagetab {  ;# a label and its image
        lappend imagetabs $optval
        dict set barinfo -IMAGETABS $imagetabs
      }
      -menu {
        lappend popup {*}$optval
        dict set barinfo -menu $popup
        dict set barinfo -USERMNU 1
      }
      default {
        dict set barinfo $optnam $optval
      }
    }
  }
  set wbar [dict get $barinfo -wbar]
  if {$wbar eq ""} {return -code error "bartabs: -wbar option is obligatory"}
  set wbase [dict get $barinfo -wbase]
  set wproc [dict get $barinfo -wproc]
  if {$wbase ne "" && $wproc eq ""} {
    dict set barinfo -wproc "expr {\[winfo width $wbase\]-80}" ;# 80 for ornaments
  }
  dict set btData $BID $barinfo
  return $BID
}
#__________

method Bar_PopupInfo {BID popName} {
  # Creates a popup menu items in a tab bar.
  #   BID - bar ID
  #   popName - variable name for popup's data

  upvar 1 $popName pop
  set bar "[self] $BID"
  set dsbl "{$bar CheckDsblPopup}"
  foreach item [list \
  "m {List} {} bartabs_cascade" \
  "m {Move to} {} bartabs_cascade2 $dsbl" \
  "s {} {} {} $dsbl" \
  "c {Close} {[self] tab%t tab_Close} {} $dsbl" \
  "c {Close all} {$bar Tab_CloseFew} {} $dsbl" \
  "c {Close all at left} {$bar Tab_CloseFew %t 1} {} $dsbl" \
  "c {Close all at right} {$bar Tab_CloseFew %t} {} $dsbl"] {
    lappend pop $item
  }
}
#__________

method Bar_PopupTuneList {BID TID popi ilist {pop ""}} {
  # Tunes "List of tabs" item of popup menu (colors & underlining).
  #   BID - bar ID
  #   TID - clicked tab ID
  #   popi - menu of the tab items
  #   ilist - list of "s" (separators) and IDs of tabs
  #   pop - menu to be themed

  if {$pop eq ""} {set pop $popi}
  catch {::apave::paveObj themePopup $pop}
  lassign [my $BID cget -tabcurrent -FEWSEL -FGOVER -BGOVER] \
    tabcurr fewsel fgo bgo
  for {set i 0} {$i<[llength $ilist]} {incr i} {
    if {[set tID [lindex $ilist $i]] eq "s"} continue
    set opts [my Tab_ImageMarkAttrs $BID $tID]
    if {"-image" ni $opts} {
      append opts " -image ::bartabs::ImgNone -compound left"
    }
    set font [list -font [font configure TkDefaultFont]]
    if {$tID==$tabcurr || [lsearch $fewsel $tID]>-1} {
      set font [my Tab_SelAttrs $font "" ""]
    }
    append opts " $font"
    if {$tID==$TID} {append opts " -foreground $fgo -background $bgo"}
    $popi entryconfigure $i {*}$opts
  }
}
#__________

method InitColors {} {
  # Initializes colors of a bar.

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
  my [my ID] configure -FGMAIN $fgmain -BGMAIN $bgmain -FGOVER $fgo -BGOVER $bgo
}
#__________

method Style {} {
  # Sets styles a bar's widgets.

  set BID [my ID]
  ttk::style configure ClButton$BID [ttk::style configure TButton]
  ttk::style configure ClButton$BID -relief flat \
    -padx 0 -bd 0 -highlightthickness 0
  ttk::style map       ClButton$BID [ttk::style map TButton]
  ttk::style layout    ClButton$BID [ttk::style layout TButton]
}
#__________

method ScrollCurr {dir} {
  # Scrolls the current tab to the left/right.
  #   dir - -1 if scrolling to the left; 1 if to the right

  lassign [my [set BID [my ID]] cget -scrollsel -tabcurrent] sccur tcurr
  if {!$sccur || $tcurr eq ""} {return no}
  set tabs [my $BID listFlag]
  if {[set i [my Aux_IndexInList $tcurr $tabs]]==-1} {return no}
  incr i $dir
  if {[lindex $tabs $i 2] eq "1"} { ;# is the next/previous tab visible?
    my [lindex $tabs $i 0] Tab_BeCurrent  ;# yes, set it current
    return yes
  }
  return no
}
#__________

method ArrowsState {tleft tright sright} {
  # Sets a state of scrolling arrows.
  #   tleft - index of left tab
  #   tright - index of right tab
  #   sright - state of a right arrow ("no" for "disabled")

  lassign [my [set BID [my ID]] cget -WWID -hidearrows -tiplen] wwid hidearr tiplen
  lassign $wwid wframe wlarr wrarr
  set tabs [my $BID listTab]
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
      set text [lindex [my Tab_TextEllipsed $BID [lindex $tabs $i 1]] 0]
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
      set text [lindex [my Tab_TextEllipsed $BID [lindex $tabs $i 1]] 0]
      append tip "$text\n"
    }
  }
  catch {tooltip::tooltip $wrarr [string trim $tip]}
}
#__________

method PopupFillList {popi {TID -1} {mnu ""}} {
  # Fills "List of tabs" item of popup menu.
  #   popi - menu of the tab items
  #   TID - clicked tab ID
  #   mnu - root menu name
  # Return a list of menu items types (s - separator, ID - tab ID)

  set vis [set seps 0] ;# flags for separators before/after visible items
  set res [list]
  foreach tab [my [set BID [my ID]] listFlag] {
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
    if {$TID == -1 || $mnu eq "bartabs_cascade"} {
      set comm "[self] $tID tab_Show 1"
    } else {
      set comm "[self] move $TID $tID"
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
#__________

method Width {} {
  # Calculates the width of a bar to place tabs.
  # Returns the width of bar.

  lassign [my [set BID [my ID]] cget \
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
    set bwidth2 [{*}[string map [list %b $BID] $wproc]]
  }
  if {$bwidth2<2 && [set wbase_exist [winfo exists $wbase]]} {
    # 'wbase' is a base widget to get the bartabs' width from
    set bwidth2 [my Aux_WidgetWidth $wbase]
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
#__________

method FillFromLeft {{ileft ""} {tright "end"}} {
  # Fills a bar with tabs from the left to the right (as much tabs as possible).
  #   ileft - index of a left tab
  #   tright - index of a right tab

  lassign [my Aux_InitDraw [set BID [my ID]]] bwidth vislen bd arrlen llen tleft hidearr tabs wframe
  if {$ileft ne ""} {set tleft $ileft}
  for {set i $tleft} {$i<$llen} {incr i} {
    lassign [my Tab_DictItem [lindex $tabs $i]] TID text wb wb1 wb2 pf
    lassign [my Tab_Create $BID $TID $wframe $text] wb wb1 wb2
    if {[my Aux_CheckTabVisible $wb $wb1 $wb2 $i $tleft tright vislen \
    $llen $hidearr $arrlen $bd $bwidth tabs $TID $text]} {
      my Tab_Pack $BID $TID $wb $wb1 $wb2
    }
  }
  my Aux_EndDraw $BID $tleft $tright $llen
}
#__________

method FillFromRight {tleft tright behind} {
  # Fills a bar with tabs from the right to the left (as much tabs as possible).
  #   tleft - index of a left tab
  #   tright - index of a right tab
  #   behind - flag "go behind the right tab"

  set llen [my [set BID [my ID]] cget -LLEN]
  if {$tright eq "end" || $tright>=$llen} {set tright [expr {$llen-1}]}
  my $BID configure -tleft $tright -tright $tright
  lassign [my Aux_InitDraw $BID] bwidth vislen bd arrlen llen tleft hidearr tabs wframe
  set totlen 0
  for {set i $tright} {$i>=0} {incr i -1} {
    lassign [my Tab_DictItem [lindex $tabs $i]] TID text wb wb1 wb2 pf
    lassign [my Tab_Create $BID $TID $wframe $text] wb wb1 wb2
    incr vislen [set wlen [my $TID cget -width]]
    if {$i<$tright && ($vislen+($tright<($llen-1)||!$hidearr?$arrlen:0))>$bwidth} {
      set pf ""
    } else {
      set tleft $i
      set pf "p"
      incr totlen $wlen
    }
    set tabs [lreplace $tabs $i $i [my Tab_ItemDict $TID $text $wb $wb1 $wb2 $pf]]
  }
  set i $tright
  while {$behind && [incr i]<($llen-1) && $totlen<$bwidth} {
    # try to go behind the right tab as far as possible
    lassign [my Tab_DictItem [lindex $tabs $i]] TID text wb wb1 wb2 pf
    lassign [my Tab_Create $BID $TID $wframe $text] wb wb1 wb2
    incr totlen [my $TID cget -width]
    if {($totlen+($i<($llen-1)||!$hidearr?$arrlen:0))>$bwidth} {
      set pf ""
    } else {
      set tright $i
      set pf "p"
    }
    set tabs [lreplace $tabs $i $i [my Tab_ItemDict $TID $text $wb $wb1 $wb2 $pf]]
  }
  for {set i $tleft} {$i<$llen} {incr i} {
    lassign [my Tab_DictItem [lindex $tabs $i]] TID text wb wb1 wb2 pf
    if {[my Tab_Is $wb] && $pf ne ""} {my Tab_Pack $BID $TID $wb $wb1 $wb2}
  }
  my Aux_EndDraw $BID $tleft $tright $llen
}
#__________

method Refill {itab left {behind false}} {
  # Fills a bar with tabs.
  #   itab - index of tab
  #   left - if "yes", the bar is filled from the left to the right
  #   behind - flag "go behind the right tab"

  my [set BID [my ID]] clear
  if {$itab eq "end" || $itab==([my $BID cget -LLEN]-1)} {
    set left 0  ;# checking for the end
  }
  if {$left} {
    my $BID FillFromLeft $itab
  } else {
    my $BID FillFromRight 0 $itab $behind
  }
}
#__________

method ScrollLeft {} {
  # Scrolls the bar tabs to the left.

  if {[my [set BID [my ID]] ScrollCurr -1]} return
  lassign [my $BID cget -tleft -LLEN -scrollsel] tleft llen sccur
  if {![string is integer -strict $tleft]} {set tleft 0}
  if {$tleft && $tleft<$llen} {
    incr tleft -1
    set tID [lindex [my $BID listTab] $tleft 0]
    my $BID configure -tleft $tleft
    my $BID Refill $tleft yes
    if {$sccur} {my $tID Tab_BeCurrent}
  }
}
#__________

method ScrollRight {} {
  # Scrolls the bar tabs to the right.

  if {[my [set BID [my ID]] ScrollCurr 1]} return
  lassign [my $BID cget -tright -LLEN -scrollsel] tright llen sccur
  if {![string is integer -strict $tright]} {set tright [expr {$llen-2}]}
  if {$tright<($llen-1)} {
    incr tright
    set tID [lindex [my $BID listTab] $tright 0]
    my $BID configure -tright $tright
    my $BID Refill $tright no
    if {$sccur} {my $tID Tab_BeCurrent}
  }
}
#__________

method CheckDsblPopup {BID TID mnuit} {
  # Controls disabling of "Close" menu items.
  #   BID - bar ID
  #   TID - ID of the clicked tab
  #   mnuit - menu label
  # Returns "yes" for disabled menu item

  lassign [my Tab_BID $TID] BID icur
  lassign [my $BID cget -static -LLEN] static llen
  switch -exact -- $mnuit {
    "Move to" {
      if {$static} {return 2}
      lassign [my Tab_TextEllipsed $BID [my $TID cget -text] 16] mnuit
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
#__________

method NeedDraw {} {
  # Redraws a bar at need.

  set BID [my ID]
  lassign [my $BID cget -wproc -BWIDTH -ARRLEN] wproc bwo arrlen
  set bw [{*}[string map [list %b $BID] $wproc]]
  if {$bwo eq "" || [set need [expr {abs($bwo-$bw)>$arrlen} && $bw>10]]} {
    my $BID configure -BWIDTH $bw
  }
  if {$bwo ne "" && $arrlen ne "" && $need} {
    after idle [list [self] $BID draw]
  }
}

# _________________________ Public methods of Bar _______________________ #

method remove {} {
  # Removes a bar info from btData dictionary and destroys it.
  # Returns "yes", if the bar was successfully removed.

  set BID [my ID]
  variable btData
  if {[dict exists $btData $BID]} {
    lassign [my $BID cget -BINDWBASE] wb bnd
    if {$wb ne ""} {bind $wb <Configure> $bnd}
    set bar [dict get $btData $BID]
    foreach wb [dict get $bar -WWID] {catch {destroy $wb}}
    dict unset btData $BID
    return yes
  }
  return no
}
#__________

method popList {X Y} {
  # Shows a stand-alone popup menu of tabs.
  #   X - x coordinate of mouse pointer
  #   Y - y coordinate of mouse pointer

  set BID [my ID]
  set wbar [my $BID cget -wbar]
  set popi $wbar.popupList
  catch {destroy $popi}
  menu $popi -tearoff 0
  if {[set plist [my $BID PopupFillList $popi]] eq "s"} {
    destroy $popi
  } else {
    my Bar_PopupTuneList $BID -1 $popi $plist
    tk_popup $popi $X $Y
  }
}
#__________

method draw {{doupdate yes}} {
  # Draws the bar tabs. Used at changing their contents.
  #   doupdate - if "yes", performs 'update' before redrawing

  if {$doupdate} update
  set BID [my ID]
  lassign [my Aux_InitDraw $BID] bwidth vislen bd arrlen llen tleft hidearr tabs wframe
  set tright [expr {$llen-1}]
  for {set i $tleft} {$i<$llen} {incr i} {
    lassign [my Tab_DictItem [lindex $tabs $i]] TID text wb wb1 wb2 pf
    lassign [my Tab_Create $BID $TID $wframe $text] wb wb1 wb2
    if {[my Aux_CheckTabVisible $wb $wb1 $wb2 $i $tleft tright vislen $llen $hidearr $arrlen $bd $bwidth tabs $TID $text]} {
      my Tab_Pack $BID $TID $wb $wb1 $wb2
    }
  }
  my Aux_EndDraw $BID $tleft $tright $llen
  my Tab_MarkBar $BID
}
#__________

method clear {} {
  # Forgets the currently shown tabs of a bar.

  foreach tab [my [my ID] listTab] {
    lassign $tab TID text wb wb1 wb2 pf
    if {[my Tab_Is $wb] && $pf ne ""} {
      pack forget $wb
      my $TID configure -pf ""
    }
  }
}
#__________

method unselect {args} {
  # Removes few or all of multi-selections and redraws a bar.
  #   args - list of TID to unselect or {} if to unselect all

  set BID [my ID]
  if {[llength $args]} {
    set fewsel [my $BID cget -FEWSEL]
    foreach tID $args {
      if {[set i [lsearch $fewsel $tID]]>-1} {
        set fewsel [lreplace $fewsel $i $i]
      }
    }
  } else {
    set fewsel {}
  }
  my $BID configure -FEWSEL $fewsel
  my $BID draw
}
#__________

method listMark {} {
  # Gets a list of marked tabs.
  # Returns a list of marked tab IDs.

  set res [list]
  foreach tab [my [my ID] listFlag] {
    lassign $tab tID text vis mark
    if {$mark} {lappend res $tID}
  }
  return $res
}
#__________

method listSel {} {
  # Gets a list of selected tabs (with Ctrl+Button) and current tab ID.
  # Returns a list of selected tab IDs and current tab ID.

  lassign [my [my ID] cget -FEWSEL -tabcurrent] fewsel tcurr
  return [list $fewsel $tcurr]
}
#__________

method listTab {} {
  # Gets a list of bar tabs.
  # Returns a list "TID, text, wb, wb1, wb2, pf".

  set res [list]
  foreach tab [my [my ID] cget -TABS] {lappend res [my Tab_DictItem $tab]}
  return $res
}

#__________

method listFlag {} {
  # Gets a list of bar's tabs with flags "visible", "marked", "selected".
  # Returns a list of items "tab ID, tab text, visible, marked, selected".

  set BID [my ID]
  lassign [my $BID cget -marktabs -FEWSEL -tabcurrent] marktabs fewsel tcurr
  set res [list]
  foreach tab [my $BID listTab] {
    lassign $tab TID text wb wb1 wb2 pf
    set visible [expr {[my Tab_Is $wb] && $pf ne ""}]
    set marked [expr {[lsearch $marktabs $TID]>=0}]
    set selected [expr {$TID == $tcurr || [lsearch $fewsel $TID]>-1}]
    lappend res [list $TID $text $visible $marked]
  }
  return $res
}
#__________

method insertTab {txt {pos "end"} {img ""}} {
  # Inserts a tab into a bar.
  #   txt - text of the tab
  #   pos - position of the tab in the tabs' list (e.g. 0, end)
  #   img - image of the tab
  # Returns ID of the created tab or 0.

  set tabs [my [set BID [my ID]] cget -TABS]
  set tab [my Tab_Data $BID $txt]
  if {$tab eq ""} {return -1}
  if {$pos eq "end"} {
    lappend tabs $tab
  } else {
    set tabs [linsert $tabs $pos $tab]
  }
  my Tab_RemoveLinks $BID -1 $txt
  if {$img ne ""} {
    set imagetabs [my $BID cget -IMAGETABS]
    lappend imagetabs [list $txt $img]
    my $BID configure -IMAGETABS $imagetabs
  }
  my $BID configure -TABS $tabs
  my $BID Refill $pos [expr {$pos ne "end"}]
  return [lindex $tab 0]
}
#__________

method getTabID {txt} {
  # Gets a tab ID by its text.
  #   txt - a text of tab
  # Returns the tab's ID (if found) or -1 (if not).

  set BID [my ID]
  if {[catch {set ellipse [my $BID cget -ELLIPSE]}]} {return ""}
  if {[string first $ellipse $txt]} {
    set pattern [string map [list $ellipse "*"] $txt]
  } else {
    set pattern ""
  }
  foreach tab [my $BID listTab] {
    lassign $tab tID ttxt
    if {$txt eq $ttxt} {return $tID}
    if {$pattern ne "" && [string match $pattern $ttxt]} {return $tID}
  }
  return ""
}
#__________

method cget {args} {
  # Gets values of options. Applied for bars & tabs.
  #   args - a list of options, e.g. {-tabcurrent -width -MyOpt}
  # Return a list of option values or an option value if args is one option.

  set BID [my ID]
  variable btData
  set res [list]
  foreach opt $args {
    if {$opt eq "-listlen"} {
      lappend res [dict get $btData $BID -LLEN]
    } elseif {$opt eq "-width"} {
      lassign [dict get [dict get $btData $BID] -wbar] wbar
      lappend res [my Aux_WidgetWidth $wbar]
    } elseif {[dict exists $btData $BID $opt]} {
      lappend res [dict get $btData $BID $opt]
    } else {
      lappend res ""
    }
  }
  if {[llength $args]==1} {return [lindex $res 0]}
  return $res
}
#__________

method configure {args} {
  # Sets values of options. Applied for bars & tabs.
  #   args - a list of pairs "option value", e.g. {{-tleft 1} {-scrollsel 1}}
  # To make the changes be active, updateAll is called.

  set BID [my ID]
  variable btData
  foreach {opt val} $args {
    dict set btData $BID $opt $val
    if {$opt eq "-TABS"} {dict set btData $BID -LLEN [llength $val]}
  }
  if {[dict exists $args -static]} {my $BID Style}
}

# _______________________ Auxiliary methods of Bar ______________________ #

method Aux_WidgetWidth {w} {
  # Calculates the width of a widget
  #   w - the widget's path

  if {![winfo exists $w]} {return 0}
  set wwidth [winfo width $w]
  if {$wwidth<2} {set wwidth [winfo reqwidth $w]}
  return $wwidth
}
#__________

method Aux_InitDraw {BID {clearpf yes}} {
  # Auxiliary procedure used before the cycles drawing tabs.
  #   BID - bar ID
  #   clearpf - if "yes", clear the "-pf" attributes of tabs

  my $BID InitColors
  lassign [my $BID cget \
    -tleft -hidearrows -LLEN -WWID -bd -wbase -wbar -ARRLEN -wproc] \
    tleft hidearr llen wwid bd wbase wbar arrlen wproc
  lassign $wwid wframe wlarr
  if {$arrlen eq ""} {
    set arrlen [winfo reqwidth $wlarr]
    my $BID configure -wbase $wbase -ARRLEN $arrlen
  }
  set bwidth [my $BID Width]
  set vislen [expr {$tleft || !$hidearr ? $arrlen : 0}]
  set tabs [my $BID cget -TABS]
  if {$clearpf} {foreach tab $tabs {my [lindex $tab 0] configure -pf ""}}
  return [list $bwidth $vislen $bd $arrlen $llen $tleft $hidearr $tabs $wframe]
}
#__________

method Aux_CheckTabVisible {wb wb1 wb2 i tleft trightN vislenN llen hidearr arrlen bd bwidth tabsN TID text} {
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
  #   TID - the tab's ID
  #   text - the tab's label
  # Returns "yes", if the tab is visible.

  upvar 1 $trightN tright $tabsN tabs $vislenN vislen
  incr vislen [my $TID cget -width]
  if {$i>$tleft && ($vislen+(($i+1)<$llen||!$hidearr?$arrlen:0))>$bwidth} {
    pack forget $wb
    set pf ""
  } else {
    set tright $i
    set pf "p"
  }
  my $TID configure -wb $wb -wb1 $wb1 -wb2 $wb2 -pf $pf
  return [string length $pf]
}
#__________

method Aux_EndDraw {BID tleft tright llen} {
  # Auxiliary procedure used after the cycles drawing tabs.
  #   BID - bar ID
  #   tleft - left tab's index to be shown
  #   tright - right tab's index to be shown
  #   llen - length of tabs' list

  my $BID ArrowsState $tleft $tright [expr {$tright < ($llen-1)}]
  my $BID configure -tleft $tleft -tright $tright
  my Tab_Bindings $BID
  my Tab_MarkBar $BID
}
#__________

method Aux_IndexInList {ID lst} {
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
} ;# --- bartabs::Bar

# ___________________________ Methods of Bars ___________________________ #

oo::define ::bartabs::Bars {

variable btData ;# dictionary of bars & tabs data

constructor {args} {
  set btData [dict create]
  if {[llength [self next]]} { next {*}$args }
  oo::objdefine [self] "method tab-1 {args} {return {}}"
}

destructor {
  my removeAll
  unset btData
  if {[llength [self next]]} next
}
#__________

method Bars_Method {mtd args} {
  # Executes a method for all tab bars.
  #   mtd - method to be run
  #   args - arguments of the method

  foreach BID [lsort -decreasing [dict keys $btData]] {my $BID $mtd {*}$args}
}
#__________

method create {barName barInfo} {
  # Creates a tab bar.
  #   barName  - name of variable for the bar
  #   barInfo - list of bar's data

  upvar 1 $barName bar
  set w [dict get $barInfo -wbar] ;# parent window (a frame, most likely)
  set wframe $w.frame ;# frame for tabs
  set wlarr $w.larr   ;# left scrolling button
  set wrarr $w.rarr   ;# right scrolling button
  lappend barInfo -WWID [list $wframe $wlarr $wrarr]
  my My [set BID [my Bar_Data $barInfo]]
  my $BID Style
  ttk::button $wlarr -style ClButton$BID -image ::bartabs::ImgLeftArr \
    -command [list [self] $BID ScrollLeft] -takefocus 0
  ttk::button $wrarr -style ClButton$BID -image ::bartabs::ImgRightArr \
    -command [list [self] $BID ScrollRight] -takefocus 0
  ttk::frame $wframe -relief flat
  pack $wlarr -side left -padx 0 -pady 0 -anchor e
  pack $wframe -after $wlarr -side left -padx 0 -pady 0 -fill x -expand 1
  pack $wrarr -after $wframe -side right -padx 0 -pady 0 -anchor w
  foreach w {wlarr wrarr} {
    bind [set $w] <Button-3> "[self] $BID popList %X %Y"
  }
  lassign [my $BID cget -wbase -redraw] wbase redraw
  if {$wbase ne "" && $redraw} {
    my $BID configure -BINDWBASE [list $wbase [bind $wbase <Configure>]]
    bind $wbase <Configure> [list + [self] $BID NeedDraw]
  }
  after idle [list [self] $BID NeedDraw ; [self] $BID draw]
}
#__________

method updateAll {} {
  # Updates all tab bars.

  my Bars_Method Refill 0 yes
}
#__________

method drawAll {{doupdate yes}} {
  # Redraws all tab bars.
  #   doupdate - if "yes", performs 'update' before redrawing

 if {$doupdate} update
 my Bars_Method draw no
}
#__________

method removeAll {} {
  # Removes all tab bars.

  my Bars_Method remove
}
#__________

method mark {args} {
  # Marks tab(s) in bars.
  #   args - list of ID of tabs to be marked

  foreach TID $args {
    if {$TID ne ""} {
      set BID [lindex [my Tab_BID $TID] 0]
      set marktabs [my $BID cget -marktabs]
      if {[lsearch $marktabs $TID]<0} {
        lappend marktabs $TID
        my $BID configure -marktabs $marktabs
      }
    }
  }
  my Tab_MarkBars
}
#__________

method unmark {args} {
  # Unmarks tab(s) in bars.
  #   args - list of ID of tabs to be unmarked

  foreach TID $args {
    set BID [lindex [my Tab_BID $TID] 0]
    set marktabs [my $BID cget -marktabs]
    if {[set i [lsearch $marktabs $TID]]>=0} {
      my $BID configure -marktabs [lreplace $marktabs $i $i]
    }
  }
  my Tab_MarkBars
}
#__________

method move {TID1 TID2} {
  # Moves a tab to a new position.
  #   TID1 - ID of the moved tab
  #   TID2 - ID of a tab the moved tab should be behind
  # TID1 and TID2 should be of the same bar.

  lassign [my Tab_BID $TID1] BID1 i1
  lassign [my Tab_BID $TID2] BID2 i2
  if {$i1!=$i2 && $BID1 eq $BID2} {
    set tabs [my $BID1 cget -TABS]
    set tab [lindex $tabs $i1]
    set tabs [lreplace $tabs $i1 $i1]
    set i [expr {$i1>$i2?($i2+1):$i2}]
    my $BID1 configure -TABS [linsert $tabs $i $tab]
    my $TID1 tab_Show 1
  }
}
} ;# --- bartabs::Bars

# __________________________ Tests for e_menu ___________________________ #

#RUNF0: test.tcl
#RUNF1: ../tests/test2_pave.tcl
