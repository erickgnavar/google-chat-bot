defmodule Alfred.GoogleChatApi do
  @moduledoc """
  Module to interact with google chat api.
  """

  @chat_scope "https://www.googleapis.com/auth/chat.bot"

  @doc """
  Send a message to the given space and thread.
  """
  @spec send_message(String.t(), String.t(), String.t() | nil) :: any
  def send_message(space, message, thread \\ nil) do
    url = build_url(space, thread)

    data = %{"text" => message}

    case Mojito.post(url, headers(), Jason.encode!(data)) do
      {:ok, %Mojito.Response{status_code: 200}} ->
        {:ok, "message posted"}

      {:ok, %Mojito.Response{status_code: status_code, body: body}} ->
        {:error, "HTTP ERROR #{status_code}: #{body}"}
    end
  end

  @spec build_url(String.t(), String.t() | nil) :: String.t()
  defp build_url(space, nil), do: "https://chat.googleapis.com/v1/#{space}/messages"

  defp build_url(space, thread),
    do: "https://chat.googleapis.com/v1/#{space}/messages?threadKey=#{thread}"

  @spec headers :: [tuple]
  defp headers do
    {:ok, token} = Goth.Token.for_scope(@chat_scope)

    [{"Authorization", "Bearer #{token.token}"}]
  end
end
