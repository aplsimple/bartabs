# LAST CHANGES:


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
