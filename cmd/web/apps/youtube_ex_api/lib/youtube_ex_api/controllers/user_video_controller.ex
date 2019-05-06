defmodule YoutubeExApi.UserVideoController do
  use YoutubeExApi, :controller

  alias YoutubeEx.Contents
  alias YoutubeEx.Contents.Video

  action_fallback YoutubeExApi.FallbackController

  def index(conn, %{"id" => id}) do
    videos = Contents.list_user_videos(id)
    render(conn, "index.json", videos: videos)
  end

  def create(conn, %{"id" => id, "video" => video_params}) do
    {video_upload, video_params} = Map.pop(video_params, :source)

    case Path.extname(video_upload.filename) do
      extension when extension in [".mp4", ".avi"] ->
        File.cp(video_upload.path, "/media/#{video_params.id}#{extension}")

        with {:ok, %Video{} = video} <- Contents.create_video(video_params) do
          conn
          |> put_status(:created)
          |> render("show.json", video: video)
        end

      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("400.json", code: "", error_stack: []) # TODO: Send stack error
    end
  end
end