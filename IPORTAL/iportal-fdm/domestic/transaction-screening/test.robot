*** Settings ***
Library  SeleniumLibrary

*** Test Cases ***
Open brower
    Open Browser    https://google.com    chrome
    Close Browser