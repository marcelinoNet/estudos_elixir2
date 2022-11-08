defmodule ReportsGeneratorTest do
  use ExUnit.Case

  describe "build/1" do
    test "builds the report" do
      file_name = "report_test.csv"

      response = ReportsGenerator.build(file_name)

      expected_response = %{
        "foods" => %{
          "açaí" => 1,
          "churrasco" => 2,
          "esfirra" => 3,
          "hambúrguer" => 2,
          "pastel" => 0,
          "pizza" => 2,
          "prato_feito" => 0,
          "sushi" => 0
        },
        "users" => %{
          "1" => 48,
          "10" => 36,
          "11" => 0,
          "12" => 0,
          "13" => 0,
          "14" => 0,
          "15" => 0,
          "16" => 0,
          "17" => 0,
          "18" => 0,
          "19" => 0,
          "2" => 45,
          "20" => 0,
          "21" => 0,
          "22" => 0,
          "23" => 0,
          "24" => 0,
          "25" => 0,
          "26" => 0,
          "27" => 0,
          "28" => 0,
          "29" => 0,
          "3" => 31,
          "30" => 0,
          "4" => 42,
          "5" => 49,
          "6" => 18,
          "7" => 27,
          "8" => 25,
          "9" => 24
        }
      }

      assert expected_response == response
    end
  end

  describe "build_from_many/1" do
    test "builds the report with multi_process" do
      filenames = ["report_1.csv", "report_2.csv", "report_3.csv"]

      response = ReportsGenerator.build_from_many(filenames)

      expected_response = %{
        "foods" => %{
          "açaí" => 37_742,
          "churrasco" => 37_650,
          "esfirra" => 37_462,
          "hambúrguer" => 37_577,
          "pastel" => 37_392,
          "pizza" => 37_365,
          "prato_feito" => 37_519,
          "sushi" => 37_293
        },
        "users" => %{
          "1" => 278_849,
          "10" => 268_317,
          "11" => 268_877,
          "12" => 276_306,
          "13" => 282_953,
          "14" => 277_084,
          "15" => 280_105,
          "16" => 271_831,
          "17" => 272_883,
          "18" => 271_421,
          "19" => 277_720,
          "2" => 271_031,
          "20" => 273_446,
          "21" => 275_026,
          "22" => 278_025,
          "23" => 276_523,
          "24" => 274_481,
          "25" => 274_512,
          "26" => 274_199,
          "27" => 278_001,
          "28" => 274_256,
          "29" => 273_030,
          "3" => 272_250,
          "30" => 275_978,
          "4" => 277_054,
          "5" => 270_926,
          "6" => 272_053,
          "7" => 273_112,
          "8" => 275_161,
          "9" => 274_003
        }
      }

      assert expected_response == response
    end

    test "when is is not a list should return error" do
      filenames = "report_3.csv"

      response = ReportsGenerator.build_from_many(filenames)

      expected_response = {:error, "Please provide a list of strings"}

      assert expected_response == response
    end
  end

  describe "fetch_higher_cost/2" do
    test "when the option is 'users' should returns the user who spent the most " do
      file_name = "report_test.csv"

      response =
        file_name |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost("users")

      expected_response = {:ok, {"5", 49}}

      assert expected_response == response
    end

    test "when the option is 'foods' should returns the most consumed food" do
      file_name = "report_test.csv"

      response =
        file_name |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost("foods")

      expected_response = {:ok, {"esfirra", 3}}

      assert expected_response == response
    end

    test "when is a invalid option should return error" do
      file_name = "report_test.csv"

      response =
        file_name |> ReportsGenerator.build() |> ReportsGenerator.fetch_higher_cost("banana")

      expected_response = {:error, "Invalid Option!"}

      assert expected_response == response
    end
  end
end
