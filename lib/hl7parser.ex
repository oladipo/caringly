defmodule Hl7parser do
  require Logger

  @moduledoc """
  Documentation for `Hl7parser`.
  """

  @doc """
  params.

  ## Examples
      iex> Hl7parser.query(params)

  """
  def query(params) do
    ## 1. read sample hl7 document/file
    path = "hl7-test.hl7"

    Logger.info("reading hl7 file: #{inspect(path)}")

    doc = File.stream!(path)

    Logger.info("file loaded sucessfully")
    Logger.debug(doc)

    # 2. get segment type from params - field selector
    ## it appears the first three characters of the query represents the segment type.
    ## take the hyphen as well..
    {selector, locator} = String.split_at(params, 4)

    Logger.info(
      "query type is for : #{inspect(selector)} segments with locator: #{inspect(locator)}"
    )

    ## 3. get lines that start with segment.
    output =
      doc
      |> Enum.map(fn x -> String.split_at(x, 3) end)
      |> Enum.filter(fn {segment_id, _contents} -> segment_id == String.slice(selector, 0..2) end)

    case output do
      # nothing found
      [] ->
        {:error, :not_found}

      [{_type, datafields}] ->
        ## TODO: this should be refactored into a function/module..
        # 4. get fields from datafields - fields are separated with pipes "|"
        fields = String.split(datafields, "|")

        Logger.debug("datafields: #{inspect(fields)}")

        # 5. get the field specified in the locator
        locator_parts = parse_locator(locator)

        Logger.debug("locator parts: #{inspect(locator_parts)}")

        # 6. get the datafield from the field in the locator
        datafield = fields |> Enum.at(Enum.at(locator_parts, 0))

        Logger.debug("datafield: #{inspect(datafield)} ")

        # 7. return the component value
        ## components in datafields are separated with the ^ symbol

        components = String.split(datafield, "^")
        Logger.debug("components: #{inspect(components)} ")

        component = components |> Enum.at(Enum.at(locator_parts, 1) - 1)

        Logger.debug("component: #{inspect(component)} ")

        component
    end
  end

  def parse_locator(params) do
    # 1. check if query contains brackets
    case String.match?(params, ~r/\[(.*?)\]/) do
      true ->
        # "52[-1].1" ?? - 52nd Field, -1 repitition, 1st component ??
        # ["52[-1]", "1"]
        String.split(params, ".")
        |> Enum.map(fn x -> parse_brackets(x) end)
        |> List.flatten()
        |> Enum.map(fn x -> Integer.parse(x) end)
        |> Enum.map(fn {x, _y} -> x end)

      false ->
        ## works fine with 2.1 - format
        String.split(params, ".")
        |> Enum.map(fn x -> Integer.parse(x) end)
        |> Enum.map(fn {x, _y} -> x end)
    end
  end

  # check if each index contains a bracket
  # if it does, take the number before the bracket and then take the number inside the bracket
  # not sure what minus means yet in the query..
  def parse_brackets(params) do
    Logger.debug("parsing brackets: #{inspect(params)} ")

    case String.match?(params, ~r/\[(.*?)\]/) do
      true ->
        # remove the brackets and replace with pipes..
        String.replace(params, "[", "|")
        # "52|-1|"
        |> String.replace("]", "|")
        # ["52", "-1", ""]
        |> String.split("|")
        |> Enum.filter(fn x -> x != "" end)

      false ->
        params
    end
  end
end
