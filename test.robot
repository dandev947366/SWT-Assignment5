# Assignment 5
# Class: Software Testing
# Professor: Esa Huiskonen
# Student: Dan Le
# Team : 4

*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}     https://blazedemo.com/

*** Test Cases ***
Verify Welcome Message
    Open Browser    ${URL}    Chrome
    Wait Until Page Contains    Welcome to the Simple Travel Agency!
    [Teardown]    Close Browser
