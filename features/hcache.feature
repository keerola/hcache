Feature: Header cache
  In order to accelerate C/C++ builds
  As a desperate developer
  I want to utilize a header cache

  Scenario: Hot cache
    When I run "make test-hot-cache"
    Then it succeeds
    And "include/test.h" is a miss
    And "include/test.h" is a hit
    And "test" exists

  Scenario: Learning cache
    When I run "make test-learning-cache"
    Then it succeeds
    And "include/test.h" is a miss
    And "include/test.h" is uncached
    And "include/test.h" is a hit
    And "test" exists

  Scenario: Relative cache
    When I run "make test-relative-cache"
    Then it succeeds
    And "include/test.h" is relative
    And "test" exists
    
