defmodule Api.Web.VideoFormatView do
  use Api.Web, :view

  def render("video_format.json", %{video_format: video_format}) do
    IO.inspect(video_format)

    Map.put(%{}, video_format.code, video_format.uri)
    |> IO.inspect()
  end
end
