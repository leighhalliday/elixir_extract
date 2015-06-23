defmodule ElixirExtract.ParseArticleTest do
  use ElixirExtract.Case, async: false
  alias ElixirExtract.ParseArticle

  test "converts to html" do
    markdown = "I want [link to](http://www.google.com) article"
    clean_html = ParseArticle.parse(markdown)

    assert clean_html == "<p>I want <a href=\"http://www.google.com\">link to</a> article</p>"
  end

  test "removes excluded tags" do
    markdown = "I want [link to](http://www.google.com) hey <strong>article</strong>"
    clean_html = ParseArticle.parse(markdown)

    assert clean_html == "<p>I want <a href=\"http://www.google.com\">link to</a> hey article</p>"
  end

  test "removes excluded attributes" do
    markdown = "I want <a href=\"http://www.google.com\" target=\"_blank\">link to</a> article"
    clean_html = ParseArticle.parse(markdown)

    assert clean_html == "<p>I want <a href=\"http://www.google.com\">link to</a> article</p>"
  end

  test "removes illegal attribute values" do
    markdown = "I want <a href=\"javascript:alert('xss')\">hacked</a> article"
    clean_html = ParseArticle.parse(markdown)

    assert clean_html == "<p>I want <a>hacked</a> article</p>"
  end
end