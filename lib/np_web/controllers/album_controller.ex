defmodule NpWeb.AlbumController do
  use NpWeb, :controller

  alias Np.Repo
  alias Np.Resources
  alias Np.Resources.Album

  def index(conn, _params) do
    redirect(conn, to: "/")
  end

  def new(conn, _params) do
    changeset = %Album{} |> Repo.preload(:tags) |> Resources.change_album()
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"album" => album_params}) do
    case Resources.create_album(album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album created successfully.")
        |> redirect(to: Routes.album_path(conn, :show, album.hash, album.slug))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"hash" => hash}) do
    album = Resources.get_album!(hash)
    render(conn, "show.html", album: album)
  end

  def edit(conn, %{"id" => id}) do
    album = Resources.get_album!(id)
    changeset = Resources.change_album(album)
    render(conn, "edit.html", album: album, changeset: changeset)
  end

  def update(conn, %{"id" => id, "album" => album_params}) do
    album = Resources.get_album!(id)

    case Resources.update_album(album, album_params) do
      {:ok, album} ->
        conn
        |> put_flash(:info, "Album updated successfully.")
        |> redirect(to: Routes.album_path(conn, :show, album))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", album: album, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    album = Resources.get_album!(id)
    {:ok, _album} = Resources.delete_album(album)

    conn
    |> put_flash(:info, "Album deleted successfully.")
    |> redirect(to: Routes.album_path(conn, :index))
  end
end
