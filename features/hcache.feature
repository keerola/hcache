Feature: Header cache
  In order to accelerate C/C++ builds
  As a desperate developer
  I want to utilize a header cache

  Scenario: Usage information #1
    When I run "../bin/hcache"
    Then it fails
    And the error text is "Usage: hcache [--relative] gcc ..."

  Scenario: Usage information #2
    When I run "../bin/hcache --relative"
    Then it fails
    And the error text is "Usage: hcache [--relative] gcc ..."

  Scenario: Usage information #3
    When I run "../bin/hcache --foobar"
    Then it fails
    And the error text is "Usage: hcache [--relative] gcc ..."

  Scenario: Hot cache
    When I run "make test-hot-cache"
    Then it succeeds
    And "include/test.h" is a miss
    And "include/test.h" is a hit
    And "./test" prints "Hello World"

  Scenario: Learning cache
    When I run "make test-learning-cache"
    Then it succeeds
    And "include/test.h" is a miss
    And "include/test.h" is uncached
    And "include/test.h" is a hit
    And "./test" prints "Hello World"

  Scenario: Relative cache
    When I run "make test-relative-cache"
    Then it succeeds
    And "include/test.h" is relative
    And "./test" prints "Hello World"

  Scenario: Configuration
    Given configuration contains "foobar"
    When I run "make test-configuration"
    Then it succeeds
    And "include/test.h" is excluded
    And "./test" prints "Hello World"

