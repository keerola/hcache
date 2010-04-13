Feature: Header cache
  In order to accelerate C/C++ builds
  As a desperate developer
  I want to utilize a header cache

  Scenario: Cold cache
    When I run "make clean"
    And I run "make test1"
    Then it succeeds
    And "include/test1.h" is a miss
    And "test1" exists
    
  Scenario: Hot cache
    When I run "make clean"
    And I run "make test2"
    Then it succeeds
    And "include/test2.h" is a miss
    And "include/test2.h" is a hit
    And "test2" exists
    
