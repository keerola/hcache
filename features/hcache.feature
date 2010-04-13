Feature: Header cache
  In order to accelerate C/C++ builds
  As a desperate developer
  I want to utilize a header cache

  Scenario: Simple build
    Given working directory "examples"
    When I run "make test1"
    Then it succeeds
    And "test1" exists
    
