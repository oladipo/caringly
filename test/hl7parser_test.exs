defmodule Hl7parserTest do
  use ExUnit.Case
  # doctest Hl7parser

  test "pid_2_1_query returns correct output" do
    ## Arrange
    params = "PID-2.1"
    expected = "306648"

    ## Act
    actual = Hl7parser.query(params)

    ## Assert
    assert expected == actual
  end

  test "pid_5_2_query returns correct output" do
    ## Arrange
    params = "PID-5.2"
    expected = "Sandesh"

    ## Act
    actual = Hl7parser.query(params)

    ## Assert
    assert expected == actual
  end

  test "pvi_52_1_1_query returns correct output" do
    ## Arrange
    params = "PV1-52[-1].1"
    expected = "Rainbow"

    ## Act
    actual = Hl7parser.query(params)

    ## Assert
    assert expected == actual
  end

  test "parse_locator matches expected" do

      ## Arrange
      params = "2.1"
      expected = [2, 1]

      ## Act
      actual = Hl7parser.parse_locator(params)

      ## Assert
      assert expected == actual

  end

  test "parse_locator with brackets matches expected" do

    ## Arrange
    params = "52[-1].1"
    expected = [52, -1, 1]

    ## Act
    actual = Hl7parser.parse_locator(params)

    ## Assert
    assert expected == actual

  end
end
