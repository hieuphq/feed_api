defmodule FeedApi.Lobster do
  @base_url "https://lobste.rs"

  def get_latest() do
    load_lobster()
  end

  defp load_lobster() do
    @base_url
    |> HTTPoison.get()
    |> parse_page()
    |> parse_items()
  end

  defp parse_page({:ok, %HTTPoison.Response{body: data, status_code: 200}}) do
    data
  end

  defp parse_page(_), do: nil

  defp parse_items(html) do
    html
    |> Floki.find("ol.stories > li")
    |> Enum.map(fn itm ->
      id = parse_id(itm)

      vote_number =
        itm
        |> Floki.find("div.voters > div.score")
        |> parse_title()
        |> IntegerHelper.safe_to_integer()

      itm = itm |> Floki.find("div.details") |> List.first()
      url_item = Floki.find(itm, "span > a.u-url")
      url = parse_url(url_item)
      title = parse_title(url_item)
      author_item = Floki.find(itm, "a.u-author")
      author_name = parse_title(url_item)
      date_published = parse_date(Floki.find(itm, "div.byline > span"))

      comments =
        itm
        |> Floki.find("div.byline > span.comments_label > a")
        |> parse_title()
        |> parse_number_comment()

      %{
        id: id,
        url: url,
        title: title,
        author: author_name,
        date_published: date_published,
        comments: comments,
        vote_number: vote_number
      }
    end)
  end

  defp parse_id(nil), do: ""

  defp parse_id(itm) do
    itm
    |> Floki.attribute("data-shortid")
    |> List.first()
  end

  defp parse_items(nil), do: []

  defp parse_date(itm) when is_list(itm) do
    itm_length = length(itm)

    cond do
      itm_length = 2 -> do_parse_date(Enum.at(itm, 0))
      true -> DateTime.utc_now()
    end
  end

  defp do_parse_date(itm) do
    itm
    |> Floki.attribute("title")
    |> DateHelper.do_convert_date()
  end

  defp parse_url(itm) when is_list(itm) do
    if length(itm) > 0 do
      itm
      |> List.first()
      |> Floki.attribute("href")
      |> List.first()
    else
      ""
    end
  end

  defp parse_url(nil), do: ""

  defp parse_title(itm) when is_list(itm) do
    if length(itm) > 0 do
      itm
      |> List.first()
      |> Floki.text()
    else
      ""
    end
  end

  defp parse_title(nil), do: ""

  defp parse_number_comment(itm) do
    itm
    |> StringHelper.nomalize_str()
    |> parse_number_comment_str()
  end

  defp parse_number_comment_str("no comments"), do: 0

  defp parse_number_comment_str(str) do
    regex = ~r/(?<number>\d+) comment/
    captures = Regex.named_captures(regex, str)
    IntegerHelper.safe_to_integer(captures["number"])
  end
end
