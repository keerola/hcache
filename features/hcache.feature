Feature: Header cache
  In order to accelerate C/C++ builds
  As a desperate developer
  I want to utilize a header cache

  Scenario: Cold cache
    Given empty cache "hcache-dir"
    When I run "make clean"
    And I run "make test1"
    Then it succeeds
    And it says "MISS.*include/test1.h"
    And "test1" exists
    
  Scenario: Hot cache
    Given empty cache "hcache-dir"
    When I run "make clean"
    And I run "make test2"
    Then it succeeds
    And it says "MISS.*include/test2.h"
    And it says "HIT.*include/test2.h"
    And "test2" exists
    
