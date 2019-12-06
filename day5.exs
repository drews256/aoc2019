defmodule Computer do
  def compute(input, index) do
    case %{ :input => input, :index => index, :value => parse_instruction(input, index), :term_mode_1 => term_1_mode(input, index), :term_mode_2 => term_2_mode(input, index), :term_mode_3 => term_3_mode(input, index) } do
      %{ :input => input, :index => index, :value => {:ok, "01"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3 } -> Computer.addition(input, index, mode1, mode2)
      %{ :input => input, :index => index, :value => {:ok, "02"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.multiplication(input, index, mode1, mode2)
      %{ :input => input, :index => index, :value => {:ok, "03"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.input(input, index, mode1)
      %{ :input => input, :index => index, :value => {:ok, "04"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.output(input, index, mode1)
      %{ :input => input, :index => index, :value => {:ok, "05"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.jump_if_true(input, index, mode1, mode2)
      %{ :input => input, :index => index, :value => {:ok, "06"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.jump_if_false(input, index, mode1, mode2)
      %{ :input => input, :index => index, :value => {:ok, "07"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.less_than(input, index, mode1, mode2, mode3)
      %{ :input => input, :index => index, :value => {:ok, "08"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.equal(input, index, mode1, mode2, mode3)
      %{ :input => input, :index => index, :value => {:ok, "99"}, :term_mode_1 => mode1, :term_mode_2 => mode2, :term_mode_3 => mode3} -> Computer.finish(input)
    end
  end

  def term_1_mode(input, index) do
    parse_full_instruction(input, index)
      |> Enum.at(2)
      |> String.to_integer
  end

  def term_2_mode(input, index) do
    parse_full_instruction(input, index)
      |> Enum.at(1)
      |> String.to_integer
  end

  def term_3_mode(input, index) do
    parse_full_instruction(input, index)
      |> Enum.at(0)
      |> String.to_integer
  end

  def parse_instruction(input, index) do
    Enum.at(input, index)
      |> Integer.to_string
      |> Computer.instruction
  end

  def parse_full_instruction(input, index) do
    Enum.at(input, index)
      |> Integer.to_string
      |> full_instruction
      |> String.split("", trim: true)
  end

  def full_instruction(string_int) do
    case String.length(string_int) do
      1 -> String.pad_leading(string_int, 5, "0")
      2 -> String.pad_leading(string_int, 5, "0")
      3 -> String.pad_leading(string_int, 5, "0")
      4 -> String.pad_leading(string_int, 5, "0")
      5 -> string_int
    end
  end

  def instruction(value) do
    case String.length(value) do
      1 -> {:ok, String.pad_leading(value, 2, "0")}
      2 -> {:ok, value}
      string_length when string_length > 2 -> {:ok, Enum.join(Enum.slice(String.split(value, "", trim: true), -2..-1))}
    end
  end

  def input(input, index, mode_term_1) do
    input_value = 5
    set_at_index = Enum.at(input, index + 1)
    new_input = Computer.set_new_value(input, set_at_index, input_value)

    Computer.compute(new_input, index+2)
  end

  def output(input, index, mode_term_1) do
    term1 = case mode_term_1 do
      0 -> Enum.at(input, Enum.at(input, index + 1))
      1 -> Enum.at(input, index + 1)
    end

    IO.inspect('output')
    IO.inspect(term1)

    Computer.compute(input, index+2)
  end

  def jump_if_true(input, index, mode_term_1, mode_term_2) do
    term1 = case mode_term_1 do
      0 -> Enum.at(input, Enum.at(input, index + 1))
      1 -> Enum.at(input, index + 1)
    end

    term2 =  case mode_term_2 do
      0 -> Enum.at(input, Enum.at(input, index + 2))
      1 -> Enum.at(input, index + 2)
    end

    if term1 != 0 do
      Computer.compute(input, term2)
    else
      Computer.compute(input, index + 3)
    end
  end

  def jump_if_false(input, index, mode_term_1, mode_term_2) do
    term1 = case mode_term_1 do
      0 -> Enum.at(input, Enum.at(input, index + 1))
      1 -> Enum.at(input, index + 1)
    end

    term2 =  case mode_term_2 do
      0 -> Enum.at(input, Enum.at(input, index + 2))
      1 -> Enum.at(input, index + 2)
    end

    if term1 == 0 do
      Computer.compute(input, term2)
    else
      Computer.compute(input, index + 3)
    end
  end

  def less_than(input, index, mode_term_1, mode_term_2, mode_term_3) do
    term1 = case mode_term_1 do
      0 -> Enum.at(input, Enum.at(input, index + 1))
      1 -> Enum.at(input, index + 1)
    end

    term2 =  case mode_term_2 do
      0 -> Enum.at(input, Enum.at(input, index + 2))
      1 -> Enum.at(input, index + 2)
    end

    term3 = Enum.at(input, index + 3)

    if term1 < term2 do
      new_input = Computer.set_new_value(input, term3, 1)
      Computer.compute(new_input, index + 4)
    else
      new_input = Computer.set_new_value(input, term3, 0)
      Computer.compute(new_input, index + 4)
    end
  end

  def equal(input, index, mode_term_1, mode_term_2, mode_term_3) do
    term1 = case mode_term_1 do
      0 -> Enum.at(input, Enum.at(input, index + 1))
      1 -> Enum.at(input, index + 1)
    end

    term2 =  case mode_term_2 do
      0 -> Enum.at(input, Enum.at(input, index + 2))
      1 -> Enum.at(input, index + 2)
    end

    term3 = Enum.at(input, index + 3)

    if term1 == term2 do
      new_input = Computer.set_new_value(input, term3, 1)
      Computer.compute(new_input, index + 4)
    else
      new_input = Computer.set_new_value(input, term3, 0)
      Computer.compute(new_input, index + 4)
    end
  end

  def addition(input, index, mode_term_1, mode_term_2) do
    term1 = case mode_term_1 do
      0 -> Enum.at(input, Enum.at(input, index + 1))
      1 -> Enum.at(input, index + 1)
    end

    term2 =  case mode_term_2 do
      0 -> Enum.at(input, Enum.at(input, index + 2))
      1 -> Enum.at(input, index + 2)
    end
    value = term1 + term2
    new_input = Computer.set_value_from_index(input, index, value)

    Computer.compute(new_input, index+4)
  end

  def multiplication(input, index, mode_term_1, mode_term_2) do
    factor1 = case mode_term_1 do
      0 -> Enum.at(input, Enum.at(input, index + 1))
      1 -> Enum.at(input, index + 1)
    end

    factor2 =  case mode_term_2 do
      0 -> Enum.at(input, Enum.at(input, index + 2))
      1 -> Enum.at(input, index + 2)
    end

    value = factor1 * factor2
    new_input = Computer.set_value_from_index(input, index, value)

    Computer.compute(new_input, index+4)
  end

  def finish(input) do
    input
  end

  def set_value_from_index(input, index, value) do
    location = Enum.at(input, index + 3)

    set_new_value(input, location, value)
  end

  def set_new_value(input, location, value) do
    {_head, tail} =  Enum.split(input, location + 1)
    {head, _tail} =  Enum.split(input, location)

    head ++ [value] ++ tail
  end
end

input = [
  3,225,1,225,6,6,1100,1,238,225,104,0,1102,27,28,225,1,113,14,224,1001,224,-34,224,4,224,102,8,223,223,101,7,224,224,1,224,223,223,1102,52,34,224,101,-1768,224,224,4,224,1002,223,8,223,101,6,224,224,1,223,224,223,1002,187,14,224,1001,224,-126,224,4,224,102,8,223,223,101,2,224,224,1,224,223,223,1102,54,74,225,1101,75,66,225,101,20,161,224,101,-54,224,224,4,224,1002,223,8,223,1001,224,7,224,1,224,223,223,1101,6,30,225,2,88,84,224,101,-4884,224,224,4,224,1002,223,8,223,101,2,224,224,1,224,223,223,1001,214,55,224,1001,224,-89,224,4,224,102,8,223,223,1001,224,4,224,1,224,223,223,1101,34,69,225,1101,45,67,224,101,-112,224,224,4,224,102,8,223,223,1001,224,2,224,1,223,224,223,1102,9,81,225,102,81,218,224,101,-7290,224,224,4,224,1002,223,8,223,101,5,224,224,1,223,224,223,1101,84,34,225,1102,94,90,225,4,223,99,0,0,0,677,0,0,0,0,0,0,0,0,0,0,0,1105,0,99999,1105,227,247,1105,1,99999,1005,227,99999,1005,0,256,1105,1,99999,1106,227,99999,1106,0,265,1105,1,99999,1006,0,99999,1006,227,274,1105,1,99999,1105,1,280,1105,1,99999,1,225,225,225,1101,294,0,0,105,1,0,1105,1,99999,1106,0,300,1105,1,99999,1,225,225,225,1101,314,0,0,106,0,0,1105,1,99999,1007,677,677,224,102,2,223,223,1005,224,329,101,1,223,223,1108,226,677,224,1002,223,2,223,1005,224,344,101,1,223,223,1008,677,677,224,102,2,223,223,1005,224,359,101,1,223,223,8,226,677,224,1002,223,2,223,1006,224,374,101,1,223,223,108,226,677,224,1002,223,2,223,1006,224,389,1001,223,1,223,1107,226,677,224,102,2,223,223,1005,224,404,1001,223,1,223,7,226,677,224,1002,223,2,223,1005,224,419,101,1,223,223,1107,677,226,224,102,2,223,223,1006,224,434,1001,223,1,223,1107,226,226,224,1002,223,2,223,1006,224,449,101,1,223,223,1108,226,226,224,1002,223,2,223,1005,224,464,101,1,223,223,8,677,226,224,102,2,223,223,1005,224,479,101,1,223,223,8,226,226,224,1002,223,2,223,1006,224,494,1001,223,1,223,1007,226,677,224,1002,223,2,223,1006,224,509,1001,223,1,223,108,226,226,224,1002,223,2,223,1006,224,524,1001,223,1,223,1108,677,226,224,102,2,223,223,1006,224,539,101,1,223,223,1008,677,226,224,102,2,223,223,1006,224,554,101,1,223,223,107,226,677,224,1002,223,2,223,1006,224,569,101,1,223,223,107,677,677,224,102,2,223,223,1006,224,584,101,1,223,223,7,677,226,224,102,2,223,223,1005,224,599,101,1,223,223,1008,226,226,224,1002,223,2,223,1005,224,614,1001,223,1,223,107,226,226,224,1002,223,2,223,1005,224,629,101,1,223,223,7,226,226,224,102,2,223,223,1006,224,644,1001,223,1,223,1007,226,226,224,102,2,223,223,1006,224,659,101,1,223,223,108,677,677,224,102,2,223,223,1005,224,674,1001,223,1,223,4,223,99,226
]

fake = [3,0,4,0,99]
fake2 = [1002,4,3,4,33,99]
fake3 = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
fake4 = [3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,
1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,
999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99]
fake5 = [3,9,8,9,10,9,4,9,99,-1,8]
fake6 = [3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9]
fake7 = [3,3,1105,-1,9,1101,0,0,12,4,12,99,1]

Computer.compute(input, 0)
