*** Settings ***
Suite Setup
Library           ../../src/R2D2/ironbot.py
Library           OperatingSystem

*** Test Cases ***
Errwnd_test
    Sleep    5 seconds
    Comment    Fail    Kaboom
