defmodule Joel.Embeds do
  @moduledoc false

  import Nostrum.Struct.Embed

  def create_joel_embed() do
    root = Application.fetch_env!(:joel, :root_dir)
    path = Path.join([root, "assets", "gifs"])

    files = Path.wildcard("#{path}/*.gif")
    image_path = Enum.random(files)

    {%Nostrum.Struct.Embed{}
     |> put_title("MOMENT")
     |> put_image("attachment://#{Path.basename(image_path)}")
     |> put_footer("JOEL MOMENT"), image_path}
  end
end
