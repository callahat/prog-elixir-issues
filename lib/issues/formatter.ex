defmodule Issues.Formatter do

  @moduledoc """
  Format a list of Github issues into a simple text table
  for the given columns.
  """

  def print_table_for_columns(issues_list, columns) do
    split_into_columns(issues_list,columns)
    |> right_pad
    |> List.zip
    |> Enum.map(&Tuple.to_list/1)
    |> print_table
  end

  def split_into_columns(issues_list, columns) do
    for column <- columns do
      [ column | for(issue <- issues_list, do: stringify( issue[column] )) ]
    end
  end

  def stringify(item) when is_integer(item), do: to_string(item)
  def stringify(item), do: item

  def right_pad(column_data) do
    for column <- column_data do
      right_pad_helper(column, Enum.map(column, &String.length/1) |> Enum.max )
    end
  end

  defp right_pad_helper(column, column_width) do
    for row <- column, do: String.pad_trailing(row, column_width)
  end

  def print_table([header | data_rows]) do
    IO.puts(Enum.join(header, " | "))
    IO.puts(header_bar(header))
    print_row_data(data_rows)
  end

  def header_bar(header_row) do
    for(header <- header_row, do: String.duplicate("-", String.length(header)))
    |> Enum.join("-+-")
  end

  defp print_row_data([ head | tail ]) do
    IO.puts(Enum.join(head, " | "))
    print_row_data tail
  end
  defp print_row_data([]), do: :ok
end
