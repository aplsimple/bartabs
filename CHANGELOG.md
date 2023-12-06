# LAST CHANGES:


Version `1.6.7 (27 Nov'23)`

  - CHANGE: adaptation to Tcl 9.0


Version `1.6.6 (31 Mar'23)`

  - NEW   : delete "tab" method at TID deletion
  - DELETE: Tab_create method


Version `1.6.5 (7 Mar'23)`

  - BUGFIX: click on tabs with ellipses, differing only in parts after ellipse


Version `1.6.4 (1 Mar'23)`

  - NEW   : %ID wildcard for -comlist command (tab's ID)


Version `1.6.3 (25 Jan'23)`

  - CHANGE: "Visible" method become "visible"


Version `1.6.2 (12 Jan'23)`

  - NEW   : sort method's arguments: "mode" (-incr/-decr) and "cmd" (compare command)
  - CHANGE: images squeezed
  - CHANGE: show method: arguments' defaults ("show no no" means no moving tabs)
  - CHANGE: unit tree & clearances
  - CHANGE: test.tcl ("-expand 3" for 4th bar)
  - CHANGE: docs


Version `1.6.1 (11 Jan'23)`

  - NEW   : moveTab method: moves a tab to a position
  - NEW   : "-menu" items: checkbutton, tip and varname
  - NEW   : "-lifoest" option: to force placing a tab to 1st position
  - CHANGE: "-nocase" for comparetext
  - CHANGE: show method's arguments: "no" by default


Version `1.6.0 (28 Nov'22)`

  - BUGFIX: (in Windows) border issue with frame containers of tabs, at -bd>0
  - NEW   : -first option: to control closing first tab vs others
  - NEW   : -withicon option: to control closing tabs by icon [x] vs otherwise
  - NEW   : -expand may be a number>1 meaning "do expand only when tabs' number > it"
            which makes "smart expanding"
  - NEW   : -sortlist & -comlist options for the file list menu
  - NEW   : -tearoff for the file list menu when run by popList (externally)
  - CHANGE: PrepareCmd & Tab_Cmd: args to be counted
  - CHANGE: update docs
  - CHANGE: clear & arrange bartabs' code
  - CHANGE: tab's background color taken from TButton
  - CHANGE: *sortedList* argument for popList
  - CHANGE: -dictionary option for sort


Version `1.5.8 (16 Sep'22)`

  - NEW   : sort method of Bar


Version `1.5.7 (22 Jun'22)`

  - CHANGE: at right-clicking outside of tabs, "List" added to user menu


Version `1.5.6 (8 Jun'22)`

  - CHANGE: -csel3 option: a command to run at (un)selecting tabs (Ctrl+click)
