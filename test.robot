# Assignment 5
# Class: Software Testing
# Professor: Esa Huiskonen
# Student: Dan Le
# Team : 4
*** Settings ***
Library    SeleniumLibrary

*** Variables ***
${URL}                       https://blazedemo.com/
${FROM_CITY}                 Boston
${TO_CITY}                   Cairo
${DEPARTURE_XPATH}           //select[@name='fromPort']
${DESTINATION_XPATH}         //select[@name='toPort']
${FIND_FLIGHTS_BTN_XPATH}    //input[@type='submit']
${RESULTS_CONTAINER_XPATH}   //div[@class='container']
${FLIGHT_TABLE_XPATH}        //table/tbody
${SELECT_FLIGHT_XPATH}       //table/tbody/tr[1]/td[1]/input
${CARD_MONTH}                11
${CARD_YEAR}                 2018

*** Test Cases ***
Verify City Selection and Purchase Flight
    Open Browser    ${URL}    Chrome
    Wait Until Page Contains    Welcome to the Simple Travel Agency!

    # Select starting and destination cities
    Select From List By Value    xpath=${DEPARTURE_XPATH}    ${FROM_CITY}
    Select From List By Value    xpath=${DESTINATION_XPATH}    ${TO_CITY}

    # Verify selected values
    ${selected_from_city}=    Get Selected List Value    xpath=${DEPARTURE_XPATH}
    Should Be Equal As Strings    ${selected_from_city}    ${FROM_CITY}
    ${selected_to_city}=    Get Selected List Value    xpath=${DESTINATION_XPATH}
    Should Be Equal As Strings    ${selected_to_city}    ${TO_CITY}

    # Check if the Find Flights button is enabled and click
    Element Should Be Enabled    xpath=${FIND_FLIGHTS_BTN_XPATH}
    Click Button    xpath=${FIND_FLIGHTS_BTN_XPATH}

    # Verify results page and select flight
    Page Should Contain    Flights from ${FROM_CITY} to ${TO_CITY}:
    Element Should Be Visible    xpath=${FLIGHT_TABLE_XPATH}
    Click Button    xpath=${SELECT_FLIGHT_XPATH}

    # Store flight details
    ${airline}=    Get Text    xpath=//p[1]
    ${flight_number}=    Get Text    xpath=//p[2]
    ${price}=    Get Text    xpath=//p[3]


    # Log flight details
    Log    Airline: ${airline}
    Log    Flight Number: ${flight_number}
    Log    Price: ${price}

    # Verify flight details on purchase page
    Should Contain    ${airline}    ${airline}
    Should Contain    ${flight_number}    ${flight_number}
    Should Contain    ${price}    ${price}

    # Input card details and purchase flight
    Input Card Details
    Click Button    xpath=//input[@type='submit']

    # Check expiration time
    ${expiration_time}=    Get Text    xpath=//table/tbody/tr[5]/td[2]
    ${expected_expiration}=    Set Variable    ${CARD_MONTH} /${CARD_YEAR}
    Should Be Equal As Strings    ${expiration_time}    ${expected_expiration}

    [Teardown]    Close Browser

*** Keywords ***
Input Card Details
    Input Text    xpath=//*[@id="inputName"]         Dan Le
    Input Text    xpath=//*[@id="address"]           123 Helsinki, Finland 00400
    Input Text    xpath=//*[@id="city"]              Helsinki
    Input Text    xpath=//*[@id="state"]             Uusimaa
    Input Text    xpath=//*[@id="zipCode"]           00400
    Input Text    xpath=//*[@id="creditCardNumber"]  123456789
    Select From List By Value    xpath=//*[@id="cardType"]    dinersclub
    Input Text    xpath=//*[@id="creditCardMonth"]   ${CARD_MONTH}
    Input Text    xpath=//*[@id="creditCardYear"]    ${CARD_YEAR}
    Input Text    xpath=//*[@id="nameOnCard"]        Dan Le
