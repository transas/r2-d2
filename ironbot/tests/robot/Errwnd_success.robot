*** Settings ***
Library           ../../src/R2D2/ironbot.py

*** Test Cases ***
Test_01
    Setup Monitors    10s    30s    Errmon.txt    WPF_KILLER    WINFORMS_KILLER
    Dream    20s
    ${app1}=    App Launch    ipy.exe    params    ..\\gui_progs\\wpf\\gui.py    assert    test_teardown
    ${app2}=    App Launch    ipy.exe    params    ..\\gui_progs\\winforms\\gui.py    assert
    App State    ${app1}    not_running    assert    timeout    ~20s
    App State    ${app2}    not_running    assert    timeout    ~20s
    Finalize Monitors
