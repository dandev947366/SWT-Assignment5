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
${DEPARTURE_XPATH}          /html/body/div[3]/form/select[@name='fromPort']
${DESTINATION_XPATH}        /html/body/div[3]/form/select[@name='toPort']
${FIND_FLIGHTS_BTN_XPATH}   /html/body/div[3]/form/div/input
${RESULTS_CONTAINER_XPATH}   /html/body/div[2]
${FLIGHT_TABLE_XPATH}       /html/body/div[2]/table/tbody
${SELECT_FLIGHT_XPATH}      /html/body/div[2]/table/tbody/tr[1]/td[1]/input  # XPath to the input to select the flight
${TOTAL_COST_XPATH}         /html/body/div[2]/p[5]  # XPath for total cost
*** Variables ***
${CARD_MONTH}      12  # Example month
${CARD_YEAR}       2025  # Example year
*** Test Cases ***
Verify City Selection and Find Flights Button
    Open Browser    ${URL}    Chrome
    Sleep    2s

    Wait Until Page Contains    Welcome to the Simple Travel Agency!
    Sleep    2s

    # Select Boston as the starting city
    Select From List By Value    xpath=${DEPARTURE_XPATH}    ${FROM_CITY}
    Sleep    2s

    # Select Cairo as the destination city
    Select From List By Value    xpath=${DESTINATION_XPATH}    ${TO_CITY}
    Sleep    2s

    # Verify the selected values
    ${selected_from_city}=    Get Selected List Value    xpath=${DEPARTURE_XPATH}
    Sleep    2s
    Should Be Equal As Strings    ${selected_from_city}    ${FROM_CITY}
    Sleep    2s

    ${selected_to_city}=    Get Selected List Value    xpath=${DESTINATION_XPATH}
    Sleep    2s
    Should Be Equal As Strings    ${selected_to_city}    ${TO_CITY}
    Sleep    2s

    # Check if the Find Flights button is enabled
    Element Should Be Enabled    xpath=${FIND_FLIGHTS_BTN_XPATH}
    Sleep    2s

    # Click the Find Flights button
    Click Button    xpath=${FIND_FLIGHTS_BTN_XPATH}
    Sleep    2s

    # Verify the page says "Flights from Boston to Cairo:"
    ${expected_text}=    Set Variable    Flights from ${FROM_CITY} to ${TO_CITY}:
    Sleep    2s
    Page Should Contain    ${expected_text}
    Sleep    2s

    # Check the content of the results container
    ${results_text}=    Get Text    xpath=${RESULTS_CONTAINER_XPATH}
    Sleep    2s
    Should Contain    ${results_text}    ${expected_text}
    Sleep    2s

    # Check that the flight table is visible
    Element Should Be Visible    xpath=${FLIGHT_TABLE_XPATH}
    Sleep    2s

    # Select one of the flights (first flight in the table)
    Click Button    xpath=${SELECT_FLIGHT_XPATH}
    Sleep    2s

    # Store the price, number, and airline of the selected flight
    ${airline}=    Get Text    xpath=/html/body/div[2]/p[1]  # Airline
    Sleep    2s
    ${flight_number}=    Get Text    xpath=/html/body/div[2]/p[2]  # Flight Number
    Sleep    2s
    ${price}=    Get Text    xpath=/html/body/div[2]/p[3]  # Price
    Sleep    2s
 # Store the total cost in a new variable
    ${total_cost}=    Get Text    xpath=${TOTAL_COST_XPATH}  # Get total cost
    Sleep    2s

    # Log the flight details
    Log    Selected Flight Details:
    Log    Airline: ${airline}
    Log    Flight Number: ${flight_number}
    Log    Price: ${price}
    Log    Total Cost: ${total_cost}

    # Verify that the details are found on the new page
    Should Contain    ${airline}    ${airline}  # Verify airline
    Should Contain    ${flight_number}    ${flight_number}  # Verify flight number
    Should Contain    ${price}    ${price}  # Verify price
    Should Contain    ${total_cost}    ${total_cost}  # Verify total cost

     # Click "Remember me"
    Click Button    xpath=//*[@id="rememberMe"]
    Sleep    2s

    # Click "Purchase Flight"
    Click Button    xpath=/html/body/div[2]/form/div[11]/div/input
    Sleep    2s

    [Teardown]    Close Browser

*** Keywords ***
Fill In Passenger Information
    # Input passenger information
    Input Text    xpath=//*[@id="inputName"]    Dan Le
    Input Text    xpath=//*[@id="address"]    123 Helsinki, Finland 00400
    Input Text    xpath=//*[@id="city"]    Helsinki
    Input Text    xpath=//*[@id="state"]    Uusimaa
    Input Text    xpath=//*[@id="zipCode"]    00400
    Input Text    xpath=//*[@id="creditCardNumber"]    4111111111111111  # Example Visa number

    # Select Diner's Club as the card type
    Select From List By Value    xpath=//*[@id="cardType"]    Diner's Club

    Input Text    xpath=//*[@id="creditCardMonth"]    ${CARD_MONTH}
Input Text    xpath=//*[@id="creditCardYear"]    ${CARD_YEAR}

    # Input name on card
    Input Text    xpath=//*[@id="nameOnCard"]    Dan Le