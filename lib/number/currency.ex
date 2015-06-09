defmodule Number.Currency do
  @moduledoc """
  Provides functions for converting numbers into formatted currency strings.
  """

  import Number.Delimit, only: [number_to_delimited: 2]

  @doc """
  Converts a number to a formatted currency string.

  ## Examples

      iex> Number.Currency.number_to_currency(nil)
      nil

      iex> Number.Currency.number_to_currency(1000)
      "$1,000"

      iex> Number.Currency.number_to_currency(1000, unit: "£")
      "£1,000"

      iex> Number.Currency.number_to_currency(-1000)
      "-$1,000"

      iex> Number.Currency.number_to_currency(-234234.23)
      "-$234,234.23"

      iex> Number.Currency.number_to_currency(1234567890.50)
      "$1,234,567,890.50"

      iex> Number.Currency.number_to_currency(1234567890.506)
      "$1,234,567,890.51"

      iex> Number.Currency.number_to_currency(1234567890.506, precision: 3)
      "$1,234,567,890.506"

      iex> Number.Currency.number_to_currency(-1234567890.50, negative_format: "(%u%n)")
      "($1,234,567,890.50)"

      iex> Number.Currency.number_to_currency(1234567890.50, unit: "R$", separator: ",", delimiter: "")
      "R$1234567890,50"

      iex> Number.Currency.number_to_currency(1234567890.50, unit: "R$", separator: ",", delimiter: "", format: "%n %u")
      "1234567890,50 R$"
  """
  @spec number_to_currency(number, list) :: String.t
  def number_to_currency(number, options \\ [])
  def number_to_currency(nil, _options), do: nil
  def number_to_currency(number, options) do
    options = Dict.merge(Number.settings, options)
    {number, format} = get_format(number, options)
    number = number_to_delimited(number, options)

    format
    |> String.replace(~r/%u/, options[:unit])
    |> String.replace(~r/%n/, number)
  end

  defp get_format(number, options) when number < 0 do
    {abs(number), options[:negative_format] || "-#{options[:format]}"}
  end
  defp get_format(number, options), do: {number, options[:format]}
end