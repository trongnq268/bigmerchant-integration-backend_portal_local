*** Settings ***
Library    SeleniumLibrary

*** Test Cases ***
Test case 1
    Do Something
    Do Something Else
Open Chrome Browser
    # Create Webdriver    Chrome    executable_path=/path/to/chromedriver
    Open Browser    https://www.google.com.vn/    Chrome
    Close Browser

Test case 2
    Do Anther Thing
    Do Something Else


*** Keywords ***
Do Something
    Log    I am doing something....
Do Something Else
    Log    I am doing something else
Do Anther Thing
    Log    I am doing another thing
