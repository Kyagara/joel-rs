defmodule Intelligence do
  def send_message(prompt) do
    url = "http://localhost:8080/completion"
    headers = [{"Content-Type", "application/json"}]

    body = %{
      prompt: prompt
    }

    # My VM is really slow
    options = [recv_timeout: 120_000]

    case HTTPoison.post(url, Jason.encode!(body), headers, options) do
      {:ok, %{status_code: 200, body: body}} ->
        case Jason.decode(body) do
          {:ok, decoded_body} ->
            case Map.get(decoded_body, "content") do
              nil -> {:error, "Content field not found in response"}
              content -> {:ok, content}
            end

          {:error, _} ->
            {:error, "Failed to decode response body"}
        end

      {:ok, _} = response ->
        response

      {:error, reason} ->
        {:error, reason}
    end
  end
end
