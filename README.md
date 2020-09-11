  The *bartabs* package provides Tcl/Tk bar widget containing tabs that are

    - scrollable
    - markable
    - moveable
    - closeable
    - disabled and enabled
    - static and changeable
    - selectable and multi-selectable
    - configureable
    - enhanceable with popup menu

  The *bartabs* defines three TclOO classes:

    - Tab deals with tabs
    - Bar deals with a bar of tabs
    - Bars deals with bars of tabs

  However, only the *Bars* class is used to create bars along with tabs. It can be also used to deal with any bars and tabs, providing all necessary interface.

  The *Bar* does not create a real TclOO object, rather it provides *syntax sugar* for a convenient access to the bar methods.

  The *Tab* does not create a real TclOO object as well. It serves actually for structuring *bartabs* code as for tab methods. Thus, its methods are accessible through the *Bars* ("real" TclOO) and *Bar* ("sugar") objects.

  A common work flow with *bartabs* looks like this:

  Firstly, we create a *Bars* object, e.g.
  
   `bartabs::Bars create NS::bars`

  Then we create a *Bar* object, e.g.
  
   `NS::bars create NS::bar $barOptions`

  If a tab of the bar should be displayed (with its possible contents), we show the bar and select the current tab:

    `set TID [NS::bar tabID "tab label"]  ;# get the tab's ID by its label`

    `NS::bar $TID show  ;# show the bar and select the tab`

  or just draw the bar without mind-breaking about a tab:

    `NS::bar draw  ;# show the bar without selecting a tab`

  The rest actions include:

    - responses to a selection of tab (through `-csel command` option of *Bar* object)
    - responses to a deletion of tab (through `-cdel command` option of *Bar* object)
    - responses to a reorganization of bar (through `-cmov command` option of *Bar* object)
    - inserting and renaming tabs
    - disabling and enabling tabs
    - marking tabs with colors or icons
    - processing the marked tabs
    - processing multiple tabs selected with Ctrl+click
    - scrolling tabs to left/right through key bindings
    - calling other handlers through key bindings and *bartabs* menu
    - using `cget` and `configure` methods to change the bar/tab appearance
    - redrawing bars at some events
    - removing and creating as much bars as required

--------------

Documentation:

https://aplsimple.github.io/en/tcl/bartabs

Reference:

https://aplsimple.github.io/en/tcl/bartabs/bartabs.html
