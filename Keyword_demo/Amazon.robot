*** Settings ***
Documentation   This is some basic info about the whole suite
Library         SeleniumLibrary

*** Variables ***


*** Test Cases ***
User can search for products
    [Documentation]  This is some basic info about the test
    [Tags]  Smoke
    Open Browser                            http://www.amazon.com    Chrome      
    Wait Until Page Contains                Your Amazon.com
    Input Text                              id=twotabsearchtextbox      Ferrari 458
    Click Button                            xpath=//*[@id="nav-search"]/form/div[2]/div/input
    Wait Until Page Contains                results for "Ferrari 458"
    Close Browser

User can view a product
    [Documentation]  This is some basic info about the test
    [Tags]  Smoke
    Open Browser                            http://www.amazon.com    Chrome
    Wait Until Page Contains                Your Amazon.com
    Input Text                              id=twotabsearchtextbox      Ferrari 458
    Click Button                            xpath=//*[@id="nav-search"]/form/div[2]/div/input
    Wait Until Page Contains                results for "Ferrari 458"
    Click Link                              css=#result_0 a.s-access-detail-page
    Wait Until Page Contains                Back to search results
    Close Browser

User can add product to cart
    [Documentation]  This is some basic info about the test
    [Tags]  Smoke
    Open Browser                            http://www.amazon.com    Chrome  
    Wait Until Page Contains                Your Amazon.com
    Input Text                              id=twotabsearchtextbox      Ferrari 458
    Click Button                            xpath=//*[@id="nav-search"]/form/div[2]/div/input
    Wait Until Page Contains                results for "Ferrari 458"
    Click Link                              css=#result_0 a.s-access-detail-page
    Wait Until Page Contains                Back to search results
    Click Button                            id=add-to-cart-button
    Wait Until Page Contains                1 item added to Cart
    Close Browser

User must sign in to check out
    [Documentation]  This is some basic info about the test
    [Tags]  Smoke
    Open Browser                            http://www.amazon.com    Chrome       
    Wait Until Page Contains                Your Amazon.com
    Input Text                              id=twotabsearchtextbox      Ferrari 458
    Click Button                            xpath=//*[@id="nav-search"]/form/div[2]/div/input
    Wait Until Page Contains                results for "Ferrari 458"
    Click Link                              css=#result_0 a.s-access-detail-page
    Wait Until Page Contains                Back to search results
    Click Button                            id=add-to-cart-button
    Wait Until Page Contains                1 item added to Cart
    Click Link                              Proceed to Checkout
    Page Should Contain Element             ap_signin1a_pagelet_title
    Element Text Should Be                  ap_signin1a_pagelet_title   Sign In
    Close Browser

*** Keywords ***
