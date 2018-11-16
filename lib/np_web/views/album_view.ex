defmodule NpWeb.AlbumView do
  use NpWeb, :view
  alias Np.Resources.Album

  def no_links?(%Album{}=album) do
    album.links
    |> Map.from_struct
    |> Map.delete(:id)
    |> Map.values
    |> Enum.all?(&is_nil(&1))
  end

  def links() do
    %Np.Resources.Album.Links{}
    |> Map.from_struct
    |> Map.keys
    |> Enum.reject(fn k -> k == :id end)
  end

  def size(path, size) do
    extless_path = Path.rootname path
    extension    = Path.extname  path

    extless_path <> "-#{size}" <> extension
  end

  def caller(conn) do
    action_name(conn)
  end
end
