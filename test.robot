# Assignment 5
# Class: Software Testing
# Professor: Esa Huiskonen
# Student: Dan Le
# Team : 4

*** Settings ***
Library    SeleniumLibrary
Library    String

*** Variables ***
${URL}                       https://blazedemo.com/
${FROM_CITY}                 Boston
${TO_CITY}                   Cairo
${DEPARTURE_XPATH}           //select[@name='fromPort']
${DESTINATION_XPATH}         //select[@name='toPort']
${FIND_FLIGHTS_BTN_XPATH}    //input[@type='submit']
${FLIGHT_TABLE_XPATH}        //table/tbody
${SELECT_FLIGHT_XPATH}       //table/tbody/tr[1]/td[1]/input
${CARD_MONTH}                11
${CARD_YEAR}                 2018

*** Test Cases ***
Test Flight Purchase Flow
    # Open the browser and navigate to the URL
    Open Browser    ${URL}    Chrome
    Wait Until Page Contains    Welcome to the Simple Travel Agency!

    # Check that the page contains the welcome message
    Page Should Contain    Welcome to the Simple Travel Agency!

    # Select "Boston" as the starting city and store it in a variable
    Select From List By Value    xpath=${DEPARTURE_XPATH}    ${FROM_CITY}

    # Select "Cairo" as the destination and store it in a variable
    Select From List By Value    xpath=${DESTINATION_XPATH}    ${TO_CITY}

    # Verify selected cities
    ${selected_from_city}=    Get Selected List Value    xpath=${DEPARTURE_XPATH}
    ${selected_to_city}=    Get Selected List Value    xpath=${DESTINATION_XPATH}
    Should Be Equal As Strings    ${selected_from_city}    ${FROM_CITY}
    Should Be Equal As Strings    ${selected_to_city}    ${TO_CITY}

    # Check if the Find Flights button is selectable and press it
    Element Should Be Enabled    xpath=${FIND_FLIGHTS_BTN_XPATH}
    Click Button    xpath=${FIND_FLIGHTS_BTN_XPATH}

    # Check that the page says "Flights from Boston to Cairo"
    Page Should Contain    Flights from ${FROM_CITY} to ${TO_CITY}:

    # Ensure that at least one flight option is visible
    Element Should Be Visible    xpath=${FLIGHT_TABLE_XPATH}

    # Select the first flight and store airline, flight number, and price in variables
    Click Button    xpath=${SELECT_FLIGHT_XPATH}
    ${airline}=    Get Text    xpath=//p[1]
    ${flight_number}=    Get Text    xpath=//p[2]
    ${price}=    Get Text    xpath=//p[3]

    # Verify that the selected flight details are displayed on the purchase page
    Should Contain    ${airline}    ${airline}
    Should Contain    ${flight_number}    ${flight_number}
    Should Contain    ${price}    ${price}

    # Fill in the passenger and credit card information
    Input Card Details

    # Click "Remember me" and "Purchase Flight"
    Click Element    xpath=//input[@id='rememberMe']
    Click Button    xpath=//input[@type='submit']

    # Check that the confirmation page says "Thank you for your purchase today!"
    Page Should Contain    Thank you for your purchase today!

    # Check that the expiration time is correct
    ${expiration_time}=    Get Text    xpath=//table/tbody/tr[5]/td[2]
    ${expected_expiration}=    Set Variable    ${CARD_MONTH} /${CARD_YEAR}
    Should Be Equal As Strings    ${expiration_time}    ${expected_expiration}

    # Verify that the total price on the confirmation page is correct
    ${confirmation_total_price}=    Get Text    xpath=//table/tbody/tr[7]/td[2]

    # Close the browser
    Close Browser

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
