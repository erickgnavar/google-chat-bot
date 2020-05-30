defmodule AlfredWeb.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get "/" do
    conn
    |> put_resp_content_type("text/plain")
    |> send_resp(200, "this is alfred :)")
  end

  post "/chat-webhook" do
    # TODO: replace this with proper plug parser
    with {:ok, raw, _conn} <- Plug.Conn.read_body(conn),
         {:ok, data} <- Jason.decode(raw) do
      encoded = AlfredWeb.BotHandler.parse_event(data)

      send_resp(conn, 200, Jason.encode!(encoded))
    else
      _ ->
        send_resp(conn, 400, "")
    end
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
