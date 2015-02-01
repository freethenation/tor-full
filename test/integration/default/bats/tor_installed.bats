#!/usr/bin/env bats

@test "tor binary is found in PATH" {
  run which tor
  [ "$status" -eq 0 ]
}