defmodule Intelligence do
  def send_message(prompt) do
    url = "http://localhost:8080/completion"
    headers = [{"Content-Type", "application/json"}]

    body = %{
      prompt: prompt
    }

    case post_request(url, headers, body) do
      {:ok, response} ->
        {:ok, response.body}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp post_request(url, headers, body) do
    case HTTPoison.post(url, Jason.encode!(body), headers) do
      {:ok, response} -> {:ok, response}
      {:error, reason} -> {:error, reason}
    end
  end
end
