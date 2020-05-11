defmodule Rut do

  alias Rut.Extract

  def get(route, fields \\ []) do
    if File.exists?(route) do
      new_file_name = parse_name(route)
      stream = File.stream!(route)
      System.cmd("mutool", ["draw", "-o", "#{new_file_name}.html", "-q", "-F", "html", route]) # -q is for quiet mode (no logs)
      case File.read(new_file_name <> ".html") do
          {:ok, hmtl} -> 
            {:ok, document} = Floki.parse_document(hmtl)
            document = Floki.find(document, "#page1")
            info = get_info(document, fields)
            File.rm!(new_file_name <> ".html")
            info
          {:error, :enoent} -> raise "Rut: File does not exist"
          error ->
              IO.inspect(error, label: "Error") 
              raise "Rut: File conversion unsuccesful"
      end
    else
      raise "Rut: File does not exist! Make sure you give a valid route."
    end
  end

  def get_info(document, fields) do
    {width, height, page1} = Extract.page(document, 1)
    page1 = Extract.delete_images(page1)
    # From this index we're going to start to fetch the rest of data
    start_index = Extract.start_index(page1)
      # |> IO.inspect(label: "START")
    
    # Now, we use the start index to sort titles
    titles = page1
      |> Enum.slice(0..start_index)
      |> Enum.sort_by( fn element ->
        {x, y} = get_xy_pos(element)
        y*width + x
      end)
    
    # Use this for debugging purposes (finding where is each field)
    # titles
    #   |> Enum.slice(25..60)
    #   |> IO.inspect(label: "Titles")
    
    values = page1
      |> Enum.slice(start_index..-1)
      |> Enum.sort_by( fn element ->
        {x, y} = get_xy_pos(element)
        y*width + x
      end)

    {_,_,_, extract_data} = Enum.reduce(fields, {start_index, titles, values, %{}}, fn x, acc -> 
      if Keyword.has_key?(Extract.__info__(:functions), x) do
        apply(Extract, x, [acc])
      else
        IO.puts "Rut: Invalid attribute: #{x}... skipping"
        acc
      end
    end)
    
    # {_,_,_, extract_data} = {start_index, titles, values, %{}}
    #   |> Extract.nit()
    #   |> Extract.dv
    #   |> Extract.person_type
    #   |> Extract.person_type_code
    #   |> Extract.business_name
    #   |> Extract.country
    #   |> Extract.country_code
    #   |> Extract.state
    #   |> Extract.state_code
    #   |> Extract.city
    #   |> Extract.city_code
    #   |> Extract.address
    #   |> Extract.email
    #   |> Extract.phone_number_1
    #   |> Extract.phone_number_2
    #   |> Extract.main_activity
    #   |> Extract.secondary_activity
    #   |> Extract.responsibilities

    extract_data
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

  def parse_name(name) do
    [head | tail] = String.split(name, "/")
      |> Enum.at(-1)
      |> String.split(".")
      |> Enum.reverse

    Enum.reverse(tail)
        |> List.foldr("", fn frag, acc -> acc<>frag end)
  end
  
  def hello do
    :world
  end
end
