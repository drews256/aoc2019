require IEx

defmodule Numbers do
  def find_in_range(range) do
    valid_values = []
    Enum.reduce(range, valid_values, fn value, valid_values ->
      with {:ok, value} <- Numbers.check_doubles(value),
           {:ok, value} <- Numbers.check_tidy(value),
           {:ok, value} <- Numbers.only_larger_groups(value)
      do
          Numbers.add_to_value_values(valid_values, value)
      else
        _error ->
          {:error, "not quite"}
          valid_values
      end
      end
    )
  end

  def add_to_value_values(valid_values, value) do
    [value] ++ valid_values
  end

  def check_doubles(value) do
    if Numbers.adjacent_integer(value) do
      {:ok, value}
    else
      {:error, "wrong"}
    end
  end

  def check_tidy(value) do
    if Numbers.tidy_integer(value) do
      {:ok, value}
    else
      {:error, "wrong"}
    end
  end

  def adjacent_integer(value) do
    Enum.any?(0..4, fn index ->
        Enum.at(Integer.digits(value), index) == Enum.at(Integer.digits(value), index+1)
      end
    )
  end

  def tidy_integer(value) do
    !Enum.any?(0..4, fn index ->
        (Enum.at(Integer.digits(value), index) > Enum.at(Integer.digits(value), index + 1))
      end
    )
  end

  def only_larger_groups(value) do
    possible_violation = Enum.any?(Map.values(Numbers.number_of_same_integers(value)), fn value ->
      case value do
        6 -> true
        5 -> true
        4 -> true
        3 -> true
        2 -> false
        1 -> false
        0 -> false
      end
    end
    )

    if possible_violation do
      violation5 = Enum.find(Map.values(Numbers.number_of_same_integers(value)), fn value ->
        value == 5
      end
      )

      violation6 = Enum.find(Map.values(Numbers.number_of_same_integers(value)), fn value ->
        value == 6
      end
      )

      violation3 = Enum.find(Map.values(Numbers.number_of_same_integers(value)), fn value ->
        value == 3
      end
      ) && !Enum.find(Map.values(Numbers.number_of_same_integers(value)), fn value ->
        value == 2
      end
      )

      violation4 = Enum.find(Map.values(Numbers.number_of_same_integers(value)), fn value ->
        value == 4
      end
      ) && !Enum.find(Map.values(Numbers.number_of_same_integers(value)), fn value ->
        value == 2
      end
      )


      if violation6 || violation5 || violation3 || violation4 do
        {:error, "error"}
      else
        {:ok, value}
      end
    else
      {:ok, value}
    end
  end

  def number_of_same_integers(value) do
    number_of_values = %{}
    Enum.reduce(0..9, number_of_values, fn int, number_of_values ->
      Map.put(number_of_values, int, Enum.count(Enum.scan(Integer.digits(value), 0, fn value, value2 -> value == int end ), fn value -> value end
      ))
    end
    )
  end
end

test_range = [111122,111222,123444,112233,111111,122340,123456,800000]

test_valid_values = Numbers.find_in_range(test_range)
IO.inspect(test_valid_values)

range = 359_282..820_401
valid_values = Numbers.find_in_range(range)
IO.inspect(length(valid_values))
