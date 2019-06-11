defmodule Gateway.ErrorViewTest do
  use Gateway.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  test "renders 404.json" do
    assert render(Gateway.ErrorView, "404.json", []) == %{message: "Not Found"}
  end

  test "renders 500.json" do
    assert render(Gateway.ErrorView, "500.json", []) ==
             %{message:  "Internal Server Error"}
  end
end
