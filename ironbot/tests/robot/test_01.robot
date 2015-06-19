*** Settings ***
Suite Setup       Ironbot Suite Setup
Suite Teardown    Ironbot Suite Teardown
Test Setup        Ironbot Test Setup
Test Teardown     Ironbot Test Teardown
Library           ../../src/R2D2/ironbot.py

*** Test Cases ***
App keywords
    ${v}=    App Launch    nonexistent_app
    Should Not Be True    ${v}
    Run Keyword And Expect Error    WindowsError: [Errno 22] The system cannot find the file specified    App Launch    nonexistent_app    assert
    ${app}=    App Launch    ipy.exe    params    ..\\gui_progs\\winforms\\gui.py    test_teardown    assert
    ${v}=    App State    ${app}    timeout    5s    assert    running
    Should Be True    ${v}
    ${v}=    App State    ${app}    not_running
    Should Not Be True    ${v}
    Run Keyword And Expect Error    IronbotTimeoutException: App State failed: Expected none, got something    App State    ${app}    not_running    assert
    ${v}=    App State    ${app}    kill
    App State    ${app}    assert    not_running
    ${app1}=    App Launch    notepad.exe
    ${app2}=    App Launch    notepad.exe
    ${app3}=    App Launch    notepad.exe
    @{res1}=    Create List    True    True
    ${t}=    Convert To Boolean    True
    ${f}=    Convert To Boolean    False
    ${i1}=    Convert To Integer    1
    ${i2}=    Convert To Integer    2
    ${pl}=    Proc List
    ${pl}=    Proc Filter    ${pl}    name    notepad
    ${apps}=    App Attach    ${pl}    test_teardown
    App State    ${apps}    not_running
    ${state}=    App State    ${apps}    running    assert    all
    Run Keyword And Expect Error    IronbotTimeoutException: App State failed: The result does not match 'any' flag    App State    ${apps}    not_running    assert    any
    AppState    ${app1}    kill
    ${v}=    App State    ${apps}    not_running    assert    any
    Should Be True    ${v}
    ${v}=    App State    ${apps}    not_running    all
    Should Not Be True    ${v}
    ${v}=    App State    ${apps}    not_running
    ${c}=    Get Count    ${v}    ${t}
    Should Be Equal    ${c}    ${i1}
    ${v}=    App State    ${apps}    running
    ${c}=    Get Count    ${v}    ${t}
    Should Be Equal    ${c}    ${i2}
    Run Keyword And Expect Error    IronbotTimeoutException: App State failed: The result does not match 'all' flag    App State    ${apps}    not_running    all    assert

Wnd keywords
    ${app1}=    App Launch    ipy64.exe    params    ..\\gui_progs\\wpf\\gui.py    assert    test_teardown
    ${win1}=    Wnd Get    re_title    ^.*ipy64\.exe$    single    assert    timeout
    ...    5s
    ${app2}=    App Launch    ipy.exe    params    ..\\gui_progs\\wpf\\gui.py    assert    test_teardown
    ${win2}=    Wnd Get    app    ${app2}    re_title    ^.*ipy\\.exe$    single
    ...    assert    timeout    5s
    Comment    App State    ${app1}    not_running    timeout    3s
    ${win2}=    Wnd Get    app    ${app1}    title    IronPythonWPF    single
    ...    timeout    5s    assert
    @{li}=    Wnd Get    app    ${app1}
    ${l}=    Get Length    ${li}
    Should Be Equal As Integers    ${l}    2
    Wnd Attr    ${win1}    do close
    App State    ${app1}    not_running    timeout    ~5s    assert
    ${aid_wnd}=    Wnd Get    app    ${app2}    re_automation_id    ^IronPythonW.F$    single
    ...    timeout    5s    assert
    ${aid_wnd}=    Wnd Get    app    ${app2}    automation_id    IronPythonWPF    single
    ...    timeout    5s    assert
    Wnd Attr    ${aid_wnd}    do close
    Wnd Get    app    ${app2}    none    timeout    15s    assert

Ctl keywords
    ${app1}=    App Launch    ipy.exe    params    ..\\gui_progs\\wpf\\gui.py    assert    test_teardown
    ${win1}=    Wnd Get    app    ${app1}    re_title    ^IronPythonWPF$    single
    ...    assert    timeout    5s
    ${b1}=    Ctl Get    button    parent    ${win1}    automation_id    AID_Button1
    ...    single    assert    timeout    5s
    ${b2}=    Ctl Get    button    parent    ${win1}    re_automation_id    A.._Bu....1
    ...    single    assert    timeout    5s
    ${b}=    Ctl Get    button    parent    ${win1}    index    1
    Ctl Attr    ${b1}    click
    @{bs}=    Ctl Get    button    parent    ${win1}    re_automation_id    A.._Bu...n.
    ...    number    2    assert    timeout    5s
    Comment    ${menu}=    Ctl Get    menu    parent    ${win1}
    Comment    ${t}=    Ctl Attr    ${menu}    click
    ${e}=    Ctl Get    edit    parent    ${win1}    automation_id    AID_TextBox1
    ...    single    assert
    ${v}=    Ctl Attr    ${e}    text
    Ctl Attr    ${e}    set text    NEW TEXT
    Sleep    1s
    ${list}=    Ctl Get    list    parent    ${win1}    automation_id    AID_ListBox1
    ...    single
    Ctl Attr    ${list}    wait num_items    6    wait enabled    timeout    5s
    ...    assert
    @{listitems}=    Ctl Attr    ${list}    items
    ${idx_selected}=    Ctl Attr    ${list}    idx_selected
    ${selected}=    Ctl Attr    ${list}    selected
    Ctl Attr    ${list}    set idx_selected    2
    ${idx_selected}=    Ctl Attr    ${list}    idx_selected
    Should Be Equal    '${idx_selected}'    '2'
    Ctl Attr    ${list}    set selected    DEF
    ${selected}=    Ctl Attr    ${list}    selected
    Should Be Equal    '${selected}'    'DEF'

Textbox testcase
    ${app1}=    App Launch    ipy64.exe    params    ..\\gui_progs\\wpf\\gui.py    assert    test_teardown
    ${win}=    Wnd Get    app    ${app1}    title    IronPythonWPF    single
    ...    timeout    5s    assert
    ${text}=    Ctl Get    text    parent    ${win}    automation_id    AID_TextBlock1
    ...    single    timeout    2s    assert
    Ctl Attr    ${text}    do focus

Modal window
    ${app1}=    App Launch    ipy.exe    params    ..\\gui_progs\\winforms\\gui.py    assert
    ${win}=    Wnd Get    app    ${app1}    title    Hello World App    single
    ...    timeout    5s    assert
    Comment    ${win}=    Wnd Get    title    Hello World App    single    timeout
    ...    5s    assert
    Comment    ${dlg}=    Wnd Get    parent    ${win}    single    timeout
    ...    5s    assert
    Wnd Attr    ${win}    do wait_while_busy
    ${b}=    Ctl Get    button    parent    ${win}    name    Click Me
    Ctl Attr    ${b}    do click
    Comment    ${dlg}=    Wnd Get    parent    ${win}    timeout    5s
    ...    assert
    ${dlg}=    Wnd Get    parent    ${win}    timeout    5s    assert
    ...    single
    Wnd Attr    ${dlg}    do wait_while_busy
    Wnd Attr    ${dlg}    do close
    Wnd Attr    ${win}    do close

in_texts testing
    [Tags]    test_tag
    ${app1}=    App Launch    ipy.exe    params    ..\\gui_progs\\winforms\\gui.py    assert    test_teardown
    ${win}=    Wnd Get    app    ${app1}    in_texts    Hello World App    in_texts
    ...    Click Me    re_in_texts    ^Cli...Me$    single    timeout    5s
    ...    assert
    Run Keyword And Expect Error    IronbotException: Wnd Filter failed: The result does not match 'single' flag, found 0 item(s)    Wnd Get    app    ${app1}    in_texts    Hello World App
    ...    in_texts    Click Me    re_in_texts    ^Cli....Me$    single    assert
    Run Keyword And Expect Error    IronbotException: Wnd Filter failed: The result does not match 'single' flag, found 0 item(s)    Wnd Get    app    ${app1}    in_texts    Hello World App
    ...    in_texts    Click Mee    re_in_texts    ^Cli...Me$    single    assert
    Wnd Attr    ${win}    do close

menus
    Comment    ${app1}=    App Launch    ipy64.exe    params    ..\\gui_progs\\wpf\\gui.py    assert
    ${app1}=    App Launch    notepad.exe
    ${win}=    Wnd Get    app    ${app1}    single    timeout    5s
    ...    assert
    Wnd Attr    ${win}    do wait_while_busy
    ${menu}=    Wnd Attr    ${win}    get menu
    ${menu}=    Ctl Get    menu    parent    ${win}    name    Application
    ...    single    assert
    ${about}=    Ctl Attr    ${menu}    get menuitem    Help    About Notepad
    Ctl Attr    ${about}    do click
    ${dlg}=    Wnd Get    parent    ${win}    timeout    5s    assert
    ...    single
    ${btn}=    Ctl Get    button    parent    ${win}    name    OK
    ...    timeout    5s    assert    single
    Ctl Attr    ${btn}    do click
    Wnd Get    parent    ${win}    timeout    5s    assert    none
    Wnd Attr    ${win}    do wait_while_busy
    ${menu}=    Ctl Get    menu    parent    ${win}    name    Application
    ...    single    assert
    ${exit}=    Ctl Attr    ${menu}    click menuitem    File    Exit    <END>
    Comment    Ctl Attr    ${exit}    do click

checkboxes
    ${app1}=    App Launch    ipy.exe    params    ..\\gui_progs\\wpf\\gui.py    assert    test_teardown
    ${win1}=    Wnd Get    app    ${app1}    re_title    ^IronPythonWPF$    single
    ...    assert    timeout    5s
    ${cbox1}=    Ctl Get    checkbox    parent    ${win1}    automation_id    checkBox1
    ...    single    assert
    ${false}=    Ctl Attr    ${cbox1}    checked
    ${true}=    Ctl Attr    ${cbox1}    unchecked
    Should Not Be True    ${false}
    Should Be True    ${true}
    Ctl Attr    ${cbox1}    do click
    ${true}=    Ctl Attr    ${cbox1}    checked
    ${false}=    Ctl Attr    ${cbox1}    unchecked
    Should Not Be True    ${false}
    Should Be True    ${true}
    Ctl Attr    ${cbox1}    set checked    FaLsE
    ${false}=    Ctl Attr    ${cbox1}    checked
    ${true}=    Ctl Attr    ${cbox1}    unchecked
    Should Not Be True    ${false}
    Should Be True    ${true}
    Ctl Attr    ${cbox1}    set unchecked    FaLsE
    ${true}=    Ctl Attr    ${cbox1}    checked
    ${false}=    Ctl Attr    ${cbox1}    unchecked
    Should Not Be True    ${false}
    Should Be True    ${true}
    Ctl Attr    ${cbox1}    set unchecked    True
    ${false}=    Ctl Attr    ${cbox1}    checked
    ${true}=    Ctl Attr    ${cbox1}    unchecked
    Should Not Be True    ${false}
    Should Be True    ${true}
    Ctl Attr    ${cbox1}    set checked    True
    ${true}=    Ctl Attr    ${cbox1}    checked
    ${false}=    Ctl Attr    ${cbox1}    unchecked
    Should Not Be True    ${false}
    Should Be True    ${true}

Radiobuttons and tabs
    ${app1}=    App Launch    ipy.exe    params    ..\\gui_progs\\wpf\\gui.py    assert    test_teardown
    ${win1}=    Wnd Get    app    ${app1}    re_title    ^IronPythonWPF$    single
    ...    assert    timeout    5s
    ${tab}=    Ctl Get    tab    parent    ${win1}    single    assert
    @{pages}=    Ctl Attr    ${tab}    tabpages
    ${num_pages}=    Ctl Attr    ${tab}    num_tabpages
    Should Be Equal As Integers    ${num_pages}    2
    ${num_pages}=    Get Length    ${pages}
    Should Be Equal As Integers    ${num_pages}    2
    ${pn1}=    Ctl Attr    @{pages}[0]    name
    Should Be Equal    ${pn1}    tabItem1
    ${pn2}=    Ctl Attr    @{pages}[1]    name
    Should Be Equal    ${pn2}    tabItem2
    ${idx_sel}=    Ctl Attr    ${tab}    idx_selected
    Should Be Equal As Integers    ${idx_sel}    0
    Ctl Attr    ${tab}    set idx_selected    1
    ${idx_sel}=    Ctl Attr    ${tab}    idx_selected
    Should Be Equal As Integers    ${idx_sel}    1
    ${pn2}=    Ctl Attr    ${tab}    name_selected
    Should Be Equal    ${pn2}    tabItem2
    Ctl Attr    ${tab}    set name_selected    tabItem1
    ${idx_sel}=    Ctl Attr    ${tab}    idx_selected
    Should Be Equal As Integers    ${idx_sel}    0
    Ctl Attr    ${tab}    set name_selected    tabItem2
    ${rb1}=    Ctl Get    radio    parent    ${win1}    name    RadioButton1
    ...    single    assert
    ${rb2}=    Ctl Get    radio    parent    ${win1}    name    RadioButton2
    ...    single    assert
    ${c1}=    Ctl Attr    ${rb1}    checked
    ${c2}=    Ctl Attr    ${rb2}    checked
    Should Not Be True    ${c1}
    Should Not Be True    ${c2}
    ${uc1}=    Ctl Attr    ${rb1}    unchecked
    ${uc2}=    Ctl Attr    ${rb2}    unchecked
    Should Be True    ${uc1}
    Should Be True    ${uc2}
    Ctl Attr    ${rb1}    do click
    ${c1}=    Ctl Attr    ${rb1}    checked
    ${c2}=    Ctl Attr    ${rb2}    checked
    Should Be True    ${c1}
    Should Not Be True    ${c2}
    ${uc1}=    Ctl Attr    ${rb1}    unchecked
    ${uc2}=    Ctl Attr    ${rb2}    unchecked
    Should Not Be True    ${uc1}
    Should Be True    ${uc2}
    Ctl Attr    ${rb2}    do click
    ${c1}=    Ctl Attr    ${rb1}    checked
    ${c2}=    Ctl Attr    ${rb2}    checked
    Should Not Be True    ${c1}
    Should Be True    ${c2}
    ${uc1}=    Ctl Attr    ${rb1}    unchecked
    ${uc2}=    Ctl Attr    ${rb2}    unchecked
    Should Be True    ${uc1}
    Should Not Be True    ${uc2}
