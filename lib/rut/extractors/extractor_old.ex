defmodule Rut.ExtractOld do

  def start_index(document) do
    index = Enum.slice(document, 120..130)
      |> Enum.reduce_while(0, fn x, acc -> 
        content = x
          |> content()
        if is_bitstring(content) and String.starts_with?(content, "Actualización"), do: {:halt, acc+120}, else: {:cont, acc+1}
      end)
    if index < 130, do: index, else: raise "Start index not found, are you sure you are looking in the first page?"
  end

  def concept({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      concept({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :concept, content |> String.replace(" ", ""))}
    end
  end

  def num_form({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if content == "", do: num_form({start_index+1, titles, values, extract_info}), else: {start_index+1, titles, values, Map.put(extract_info, :num_form, content)}
  end
  
  def nit({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      nit({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :nit, content |> String.replace(" ", ""))}
    end
  end

  def dv({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      dv({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :dv, content |> String.replace(" ", ""))}
    end
  end

  def sectional_address({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      sectional_address({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :sectional_address, content)}
    end
  end

  def sectional_address_code({start_index, titles, values, extract_info}) do
    digit_1 = Enum.at(values, start_index+1)
      |> content
    if is_nil(digit_1) or digit_1 == "" do
      sectional_address_code({start_index+1, titles, values, extract_info})
    else
      digit_2 = Enum.at(values, start_index+2)
        |> content
      {start_index+2, titles, values, Map.put(extract_info, :sectional_address_code, digit_1<>digit_2)}
    end
  end

  def person_type({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      person_type({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :person_type, content)}
    end
  end

  def person_type_code({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      person_type_code({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :person_type_code, content)}
    end
  end

  defp find_match(values, posX, posY, errorX, errorY) do
    content = Enum.filter(values, fn element -> 
      {x, y} = get_xy_pos(element)
      x_distance = x-posX
      y_distance = y-posY
      x_distance > 0 and x_distance < errorX and y_distance > 0 and y_distance < errorY
    end)
  end

  def delete_images(document) do
    Enum.filter(document, fn element -> 
      # IO.inspect(element, label: "ELEMENT")
      element
        |> elem(0) != "img"
    end)
  end

  def page(document, number) do
    try do
      page = Floki.find(document, "#page#{number}") 
        |> Enum.at(0) 
      {width, height} = get_wh(page)
      {width, height, page |> elem(2)}
        # |> elem(2) # This is the div where content is stored
    rescue e in RuntimeError -> 
      raise "Error: #{e}"
    end
  end

  def content({_,_,[{"span",_,[content]}]} = element) do
    content
  end
  def content(element) do
    IO.inspect(element, label: "ELEMENT")
    element
      |> elem(2)
      |> Enum.at(0)
      |> elem(2)
      |> Enum.at(0)
  end

  def get_wh({_, properties, _} = element) do
    [_, {_, styles}] = properties
    top = String.split(styles, ";")
      |> Enum.at(1)
      |> String.split(":")
      |> Enum.at(-1)
      |> String.replace(~r/[^\d]/, "")
      |> String.to_integer
    left = String.split(styles, ";")
      |> Enum.at(2)
      |> String.split(":")
      |> Enum.at(-1)
      |> String.replace(~r/[^\d]/, "")
      |> String.to_integer
    {left, top}
  end

  def get_xy_pos({_, properties, _} = element) do
    [{_, styles}] = properties
    top = String.split(styles, ";")
      |> Enum.at(-2)
      |> String.split(":")
      |> Enum.at(-1)
      |> String.replace(~r/[^\d]/, "")
      |> String.to_integer
    left = String.split(styles, ";")
      |> Enum.at(-1)
      |> String.split(":")
      |> Enum.at(-1)
      |> String.replace(~r/[^\d]/, "")
      |> String.to_integer
    {left, top}
  end
end