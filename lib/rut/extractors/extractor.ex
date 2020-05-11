defmodule Rut.Extract do

  def start_index(document) do
    index = Enum.slice(document, 120..130)
      |> Enum.reduce_while(0, fn x, acc -> 
        content = x
          |> content()
        if is_bitstring(content) and String.starts_with?(content, "Actualización"), do: {:halt, acc+120}, else: {:cont, acc+1}
      end)
    if index < 130, do: index, else: raise "Start index not found, are you sure you are looking in the first page?"
  end

  @doc """
    Extracts nit value. Searches fields within 90pts in x and 20pts in y
  """
  def nit({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 5)
      |> get_xy_pos()
    find_match(values, x, y, 90, 20)
      |> case do
        [] -> 
          IO.puts "nit not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          nit = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :nit, nit)}
      end
  end

  @doc """
    Extracts verification digit value. Searches fields within 20pts in x and 20pts in y
  """
  def dv({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 6)
      |> get_xy_pos()
    find_match(values, x, y, 20, 20)
      |> case do
        [] -> 
          IO.puts "dv not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          dv = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :dv, dv)}
      end
  end

  @doc """
    Extracts person_type value. Searches fields within 20pts in x and 20pts in y
  """
  def person_type({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 11)
      |> get_xy_pos()
    find_match(values, x, y, 20, 20)
      |> case do
        [] -> 
          IO.puts "person_type not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          person_type = content(matched)
          {start_index, titles, values, Map.put(extract_info, :person_type, person_type)}
      end
  end

  @doc """
    Extracts person type code value. Searches fields within 20pts in x and 20pts in y
  """
  def person_type_code({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 11)
      |> get_xy_pos()
    find_match(values, x, y, 150, 20)
      |> Enum.drop(-1)
      |> case do
        [] -> 
          IO.puts "person_type_code not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          person_type_code = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :person_type_code, person_type_code)}
      end
  end

  @doc """
    Extracts business name value. Searches fields within 10pts in x and 20pts in y
  """
  def business_name({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 23)
      |> get_xy_pos()
    find_match(values, x, y, 10, 20)
      |> case do
        [] -> 
          IO.puts "business_name not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          business_name = content(matched)
          {start_index, titles, values, Map.put(extract_info, :business_name, business_name)}
      end
  end

  @doc """
    Extracts country value. Searches fields within 10pts in x and 20pts in y
  """
  def country({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 27)
      |> get_xy_pos()
    find_match(values, x, y, 10, 20)
      |> case do
        [] -> 
          IO.puts "country not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          country = content(matched)
          {start_index, titles, values, Map.put(extract_info, :country, country)}
      end
  end

  @doc """
    Extracts country code value. Searches fields within 150pts in x and 20pts in y
  """
  def country_code({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 27)
      |> get_xy_pos()
    find_match(values, x, y, 150, 20)
    |> Enum.drop(-1)
      |> case do
        [] -> 
          IO.puts "country_code not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          country_code = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :country_code, country_code)}
      end
  end

  @doc """
    Extracts state type code value. Searches fields within 10pts in x and 20pts in y
  """
  def state({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 28)
      |> get_xy_pos()
    find_match(values, x, y, 10, 20)
      |> case do
        [] -> 
          IO.puts "state not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          state = content(matched)
          {start_index, titles, values, Map.put(extract_info, :state, state)}
      end
  end

  @doc """
    Extracts state code value. Searches fields within 190pts in x and 20pts in y
  """
  def state_code({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 28)
      |> get_xy_pos()
    find_match(values, x, y, 190, 20)
    |> Enum.drop(-1)
      |> case do
        [] -> 
          IO.puts "state_code not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          state_code = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :state_code, state_code)}
      end
  end

  @doc """
    Extracts city value. Searches fields within 10pts in x and 20pts in y
  """
  def city({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 29)
      |> get_xy_pos()
    find_match(values, x, y, 10, 20)
      |> case do
        [] -> 
          IO.puts "city not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          city = content(matched)
          {start_index, titles, values, Map.put(extract_info, :city, city)}
      end
  end

  @doc """
    Extracts city code value. Searches fields within 190pts in x and 20pts in y
  """
  def city_code({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 29)
      |> get_xy_pos()
    find_match(values, x, y, 190, 20)
    |> Enum.drop(-1)
      |> case do
        [] -> 
          IO.puts "city_code not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          city_code = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :city_code, city_code)}
      end
  end

  @doc """
    Extracts address value. Searches fields within 20pts in x and 20pts in y
  """
  def address({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 30)
      |> get_xy_pos()
    find_match(values, x, y, 20, 20)
      |> case do
        [] -> 
          IO.puts "address not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          address = content(matched)
          {start_index, titles, values, Map.put(extract_info, :address, address)}
      end
  end

  @doc """
    Extracts email value. Searches fields within 20pts in x and 20pts in y
  """
  def email({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 31)
      |> get_xy_pos()
    find_match(values, x, y, 20, 20)
      |> case do
        [] -> 
          IO.puts "email not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          email = content(matched)
          {start_index, titles, values, Map.put(extract_info, :email, email)}
      end
  end

  @doc """
    Extracts phone number 1 value. Searches fields within 100pts in x and 20pts in y
  """
  def phone_number_1({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 33)
      |> get_xy_pos()
    find_match(values, x, y, 100, 20)
      |> case do
        [] -> 
          IO.puts "phone_number_1 not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          phone_number_1 = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :phone_number_1, phone_number_1)}
      end
  end

  @doc """
    Extracts phone number 2 value. Searches fields within 100pts in x and 20pts in y
  """
  def phone_number_2({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 34)
      |> get_xy_pos()
    find_match(values, x, y, 100, 20)
      |> case do
        [] -> 
          IO.puts "phone_number_2 not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          phone_number_2 = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :phone_number_2, phone_number_2)}
      end
  end

  @doc """
    Extracts main activity value. Searches fields within 20pts in x and 20pts in y
  """
  def main_activity({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 43)
      |> get_xy_pos()
    find_match(values, x-10, y, 20, 20)
      |> case do
        [] -> 
          IO.puts "main_activity not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          main_activity = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :main_activity, main_activity)}
      end
  end

  @doc """
    Extracts secondary activity value. Searches fields within 20pts in x and 20pts in y
  """
  def secondary_activity({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 45)
      |> get_xy_pos()
    find_match(values, x-10, y, 20, 20)
      |> case do
        [] -> 
          IO.puts "secondary_activity not found"
          {start_index, titles, values, extract_info}
        [matched] ->
          secondary_activity = content(matched)
            |> String.replace(" ", "")
            |> String.to_integer
          {start_index, titles, values, Map.put(extract_info, :secondary_activity, [secondary_activity])}
      end
  end

  @doc """
    Extracts responsibilities value. Searches fields within 600pts in x and 100pts in y
  """
  def responsibilities({start_index, titles, values, extract_info}) do
    {x, y} = Enum.at(titles, 78)
      |> get_xy_pos()
    find_match(values, x, y, 600, 100)
      |> case do
        [] -> 
          IO.puts "responsibilities not found"
          {start_index, titles, values, extract_info}
        matched ->
          # IO.inspect(matched, label: "LABEL")
          responsibilities = Enum.map(matched, fn respons -> 
            [code, responsibility] = content(respons)
              |> String.split("-", parts: 2)
            {code, responsibility}
          end)
          {start_index, titles, values, Map.put(extract_info, :responsibilities, responsibilities)}
      end
  end

  @doc """
    Finds matcing element in specified range
  """
  defp find_match(values, posX, posY, errorX, errorY) do
    Enum.filter(values, fn element -> 
      cont = content(element)
        # |> IO.inspect(label: "CONTENT")
      {x, y} = get_xy_pos(element)
      x_distance = x-posX
      y_distance = y-posY
      x_distance >= 0 and x_distance < errorX and y_distance >= 0 and y_distance < errorY and !is_nil(cont)
    end)
  end

  @doc """
    Removes <img> tags from final html document
  """
  def delete_images(document) do
    Enum.filter(document, fn element -> 
      element
        |> elem(0) != "img"
    end)
  end

  @doc """
    Extracts a page from a document
  """
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

  @doc """
    Returns the content of a given element on the array
  """
  def content({_,_,[{"span",_,[content]}]} = element) do
    content
  end
  def content(element) do
    element
      |> elem(2)
      |> Enum.at(0)
      |> elem(2)
      |> Enum.at(0)
  end

  def get_wh({_, [_, {_, styles}], _}) do
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

  @doc """
    Extracts xy coordinates of an element in the document
  """
  def get_xy_pos({_, [{_, styles}], _}) do
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