defmodule Rut.Extract.Natural do
  def document_type({start_index, titles, values, %{person_type_code: "1"} = extract_info}) do
    IO.puts "document_type: No existe este dato para personas jurídicas"
    {start_index, titles, values, extract_info}
  end
  def document_type({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      document_type({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :document_type, content)}
    end
  end

  def document_type_code({start_index, titles, values, %{person_type_code: "1"} = extract_info}) do
    IO.puts "document_type_code: No existe este dato para personas jurídicas"
    {start_index, titles, values, extract_info}
  end
  def document_type_code({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      document_type_code({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :document_type_code, content |> String.replace(" ", ""))}
    end
  end

  def document_number({start_index, titles, values, %{person_type_code: "1"} = extract_info}) do
    IO.puts "document_number: No existe este dato para personas jurídicas"
    {start_index, titles, values, extract_info}
  end
  def document_number({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      document_number({start_index+1, titles, values, extract_info})
    else
      {start_index+1, titles, values, Map.put(extract_info, :document_number, content |> String.replace(" ", ""))}
    end
  end

  def document_expedition_date({start_index, titles, values, %{person_type_code: "1"} = extract_info}) do
    IO.puts "document_expedition_date: No existe este dato para personas jurídicas"
    {start_index, titles, values, extract_info}
  end
  def document_expedition_date({start_index, titles, values, extract_info}) do
    content = Enum.at(values, start_index+1)
      |> content
    if is_nil(content) or content == "" do
      document_expedition_date({start_index+1, titles, values, extract_info})
    else
      <<year::binary-size(4), month::binary-size(2), day ::binary-size(2)>> = content |> String.replace(" ", "")
      {:ok, date} = Date.from_iso8601("#{year}-#{month}-#{day}")
      {start_index+1, titles, values, Map.put(extract_info, :document_expedition_date, date)}
    end
  end

  def content(element) do
    element
      |> elem(2)
      |> Enum.at(0)
      |> elem(2)
      |> Enum.at(0)
  end
end