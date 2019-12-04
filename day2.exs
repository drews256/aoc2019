defmodule Computer do
  def compute(input, index) do
    case %{ :input => input, :index => index, :value => Enum.fetch(input, index)} do
      %{ :input => input, :index => index, :value => {:ok, 1} } -> Computer.addition(input, index)
      %{ :input => input, :index => index, :value => {:ok, 2} } -> Computer.multiplication(input, index)
      %{ :input => input, :index => index, :value => {:ok, 99} } -> Computer.finish(input)
    end
  end

  def addition(input, index) do
    value = Enum.at(input, Enum.at(input, index + 1)) + Enum.at(input, Enum.at(input, index + 2))
    new_input = Computer.set_value_from_index(input, index, value)

    Computer.compute(new_input, index+4)
  end

  def multiplication(input, index) do
    value = Enum.at(input, Enum.at(input, index + 1)) * Enum.at(input, Enum.at(input, index + 2))
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

  def find_noun_verb(input, match) do
    nouns_and_verbs = 0..99
    original_input = input
    Enum.map(nouns_and_verbs,
      fn noun ->
        input_with_noun = set_new_value(original_input, 1, noun)
        Enum.map(nouns_and_verbs,
          fn verb ->
            input_with_noun_and_verb = set_new_value(input_with_noun, 2, verb)
            {_head, tail1} =  Enum.split(original_input, 3)
            {_head, tail2} =  Enum.split(input_with_noun_and_verb, 3)

            if match == Enum.at(Computer.compute(input_with_noun_and_verb, 0), 0) do
              IO.inspect(match == Computer.compute(input_with_noun_and_verb, 0))
              IO.inspect(noun)
              IO.inspect(verb)
              IO.inspect(100 * noun + verb)
            end
          end
            )
      end
        )
  end
end

input = [
 1,12,2,3,1,1,2,3,1,3,4,3,1,5,0,3,2,1,9,19,1,19,5,23,2,6,23,27,1,6,27,31,2,31,9,35,1,35,6,39,1,10,39,43,2,9,43,47,1,5,47,51,2,51,6,55,1,5,55,59,2,13,59,63,1,63,5,67,2,67,13,71,1,71,9,75,1,75,6,79,2,79,6,83,1,83,5,87,2,87,9,91,2,9,91,95,1,5,95,99,2,99,13,103,1,103,5,107,1,2,107,111,1,111,5,0,99,2,14,0,0
]

fake = [1,0,0,0,2,0,0,0,99]

match = 19_690_720

Computer.find_noun_verb(input, match)
# Computer.compute(input, 0)
