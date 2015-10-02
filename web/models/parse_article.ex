defmodule ElixirExtract.ParseArticle do

  def parse(markdown) do
    to_html(markdown)
      |> to_floki
      |> to_clean_html
  end

  def to_html(markdown) do
    Earmark.to_html(markdown)
  end

  def to_floki(html) do
    Floki.parse html
  end

  def to_clean_html(floki) do
    clean_tags(floki)
  end

  defp clean_tags({tag_name, attrs, children}) do
    case Enum.member?(allowed_tags, tag_name) do
      true -> "<#{tag_name}#{clean_attrs(tag_name, attrs)}>#{clean_tags(children)}</#{tag_name}>"
      false -> clean_tags(children)
    end
  end

  defp clean_tags([head | tail]) do
    "#{clean_tags(head)}#{clean_tags(tail)}"
  end

  defp clean_tags(content) do
    content
  end

  defp clean_attrs(_tag_name, []) do
    ""
  end

  defp clean_attrs(tag_name, attrs) do
    Enum.map(attrs, (fn (attr) -> clean_attr(tag_name, attr) end))
      |> Enum.reject(fn (attr_str) -> attr_str == nil end)
      |> Enum.join(" ")
  end

  defp clean_attr(tag_name, {property, value}) do
    case allow_attr?(tag_name, property) && valid_attr?(property, value) do
      true -> " #{property}=\"#{value}\""
      false -> nil
    end
  end

  defp allow_attr?(tag_name, property) do
    Map.has_key?(allowed_attrs, tag_name) && Enum.member?(allowed_attrs[tag_name], property)
  end

  defp valid_attr?("href", value) do
    String.starts_with?(value, "http")
  end

  defp valid_attr?(_property, value) do
    true
  end

  defp allowed_attrs do
    %{"a" => ["href"]}
  end

  defp allowed_tags do
    ["p", "a"]
  end

end