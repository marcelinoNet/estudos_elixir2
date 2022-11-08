defmodule ReportsGenerator do
  # usando case
  def build_case(filename) do
    case File.read("reports/#{filename}") do
      {:ok, result} -> result
      {:error, reason} -> reason
    end
  end

  # usando pipe
  def build_pipe(filename) do
    "reports/#{filename}"
    |> File.read()
    |> handle_file()
  end

  defp handle_file({:ok, file_content}), do: file_content
  defp handle_file({:error, _reason}), do: "Error while opening file!"

  # usando stream

  @available_foods [
    "açaí",
    "churrasco",
    "esfirra",
    "hambúrguer",
    "pastel",
    "pizza",
    "prato_feito",
    "sushi"
  ]

  @options ["foods", "users"]

  def build(filename) do
    filename
    |> ReportsGenerator.Parser.parse_file()
    |> Enum.reduce(report_acc(), fn line, report -> sum_values(line, report) end)
  end

  def build_from_many(filenames) when not is_list(filenames) do
    {:error, "Please provide a list of strings"}
  end

  def build_from_many(filenames) do
    filenames
    |> Task.async_stream(&build/1)
    |> Enum.reduce(report_acc(), fn {:ok, result}, report -> sum_reports(report, result) end)
  end

  defp sum_reports(%{"foods" => foods1, "users" => users1}, %{
         "foods" => foods2,
         "users" => users2
       }) do
    foods = merge_maps(foods1, foods2)
    users = merge_maps(users1, users2)

    build_reports(foods, users)
  end

  defp merge_maps(map1, map2) do
    Map.merge(map1, map2, fn _key, value1, value2 -> value1 + value2 end)
  end

  def fetch_higher_cost(report, option) when option in @options do
    {:ok, Enum.max_by(report[option], fn {_key, value} -> value end)}
  end

  def fetch_higher_cost(_report, _option), do: {:error, "Invalid Option!"}

  defp sum_values([id, food_name, price], %{"foods" => foods, "users" => users} = report) do
    users = Map.put(users, id, users[id] + price)
    foods = Map.put(foods, food_name, foods[food_name] + 1)

    # report
    # |> Map.put("users", users)
    # |> Map.put("foods", foods)

    %{report | "users" => users, "foods" => foods}
  end

  defp report_acc do
    foods = Enum.into(@available_foods, %{}, &{&1, 0})
    users = Enum.into(1..30, %{}, &{Integer.to_string(&1), 0})

    build_reports(foods, users)
  end

  defp build_reports(foods, users), do: %{"users" => users, "foods" => foods}
end
