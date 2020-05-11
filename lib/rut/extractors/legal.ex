defmodule Rut.Extract.Legal do
  def business_name({start_index, titles, values, %{person_type_code: "2"} = extract_info}) do
    IO.puts "document_type: No existe este dato para personas naturales"
    {start_index, titles, values, extract_info}
  end
  def business_name({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      business_name({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :business_name, content)}
    end
  end

  def business_name({start_index, titles, values, %{person_type_code: "2"} = extract_info}) do
    IO.puts "document_type: No existe este dato para personas naturales"
    {start_index, titles, values, extract_info}
  end
  def business_name({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      business_name({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :business_name, content)}
    end
  end

  def tradename({start_index, titles, values, %{person_type_code: "2"} = extract_info}) do
    IO.puts "document_type: No existe este dato para personas naturales"
    {start_index, titles, values, extract_info}
  end
  def tradename({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(values, start_index+1)
      |> get_xy_pos()
      |> IO.inspect(label: "X Y POS")
    {start_index+1, titles, values, extract_info}

    # {_, properties} = Enum.at(values, start_index)
    #   |> properties
    # styles_1= properties
    #   |> String.split(";")
    #   |> Enum.at(-1)
    # {_, properties} = Enum.at(values, start_index+1)
    #   |> properties
    # styles_2= properties
    #   |> String.split(";")
    #   |> Enum.at(-1)
    # if styles_2 == styles_1 do
    #   content = Enum.at(values, start_index+1)
    #     |> content
    #   if is_nil(content) or content == "" do
    #     business_name({start_index+1, titles, values, extract_info})
    #   else
    #     {start_index+1, titles, values, Map.put(extract_info, :tradename, content)}
    #   end
    # else
    #   IO.puts "tradename: No existe el atributo"
    #   {start_index, titles, values, extract_info}
    # end
    
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
  
  def content(element) do
    element
      |> elem(2)
      |> Enum.at(0)
      |> elem(2)
      |> Enum.at(0)
  end

  def properties(element) do
    element
      |> elem(2)
      |> Enum.at(0)
      |> elem(1)
      |> Enum.at(0)
  end
end