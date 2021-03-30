defmodule Hl7parserTest do
  use ExUnit.Case
  # doctest Hl7parser

  test "pid_2_1_query returns correct output" do

    ##Arrange
    params = ""
    expected = 306648

    ##Act
    actual = Hl7parser.query(params)

    ##Assert

    assert actual == expected

  end

  test "pid_5_2_query returns correct output" do

    ##Arrange
    params = ""
    expected = "Sandesh"

    ##Act
    actual = Hl7parser.query(params)

    ##Assert

    assert actual == expected

  end

  test "pvi_5_2_1_1query returns correct output" do

    ##Arrange
    params = ""
    expected = "Rainbow"

    ##Act
    actual = Hl7parser.query(params)

    ##Assert

    assert actual == expected

  end

end
