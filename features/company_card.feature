Feature: Company card

  Background:
    Given A company
      | name      | ticker_code |
      | Apple Inc | AAPL        |
    And I visit the homepage
    And I click on "Apple Inc"

  Scenario: Click on the company
    Then I should be on the "Apple Inc" card page
    And I should see "Apple Inc"

  Scenario: The company is not found on the external web service
    Then I should see:
      | Ticker Code    | AAPL |
      | Latest Price   | N/A  |
      | As Of          | N/A  |
      | Latest Stories | N/A  |

  Scenario: The company is found but there is no story feed
    Then I should see:
      | Ticker Code    | AAPL        |
      | Latest Price   | 1945        |
      | As Of          | 2014-10-19  |
      | Latest Stories | N/A         |

  Scenario: The company is found and it has a story feed
    Given A company
      | name       | ticker_code |
      | Google Inc | GOOG        |
    And I visit the homepage
    When I click on "Google Inc"
    Then I should see:
      | Ticker Code    | GOOG            |
      | Latest Price   | 54407           |
      | As Of          | 2015-10-19      |
      | Latest Stories |                 |
      | Headline       | Going strong    |
      | Body           | Apple Inc is    |
      | Headline       | Google revenue  | 
      | Body           | Stocks finished |




