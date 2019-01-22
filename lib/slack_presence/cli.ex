defmodule SlackPresence.CLI do

  @slack_api_endpoint ~s(https://slack.com/api)
  @usage ~s(
  Slack Presence -- set the presence of you in slack

  usage:
    ./slack_presence msg

  opts:
    --channel -> slack channel to send msg on
    --token -> slack token to use
    --set-status -> set status. msg should have the following format: "status_text status_emoji"
    --set-presence -> set presence. msg would be the presence text. msg could be either "auto" or "away"

  Note:
    You can also, set channel and token in the SLACK_CHANNEL, SLACK_AUTH_TOKEN envs respectively
    prefrence order for the channel and token is
    args > envs
  )

  def main(args) do
    with {:ok, args} <- parse_args(args),
         {:ok, {url, headers, body}} <- prepare_params(args),
         {:ok, %{body: body}} <- HTTPoison.post(url, body, headers),
         %{"ok" => true} = body <- Jason.decode!(body)
    do
      IO.inspect body, label: "Got the following reply"
    else
      body ->
        IO.puts("[!] #{inspect body}")

      {:error, error} ->
        IO.puts("[!] #{inspect error}")
        usage()
    end
  end

  defp parse_args(args) do
    case OptionParser.parse(args, strict: [channel: :string, token: :string, set_status: :boolean, set_presence: :boolean]) do
      {args, [msg], []} ->
        do_parse_args(Keyword.put(args, :msg, msg))

      {_args, [], _invalid_args} ->
        {:error, "no msg provided"}

      {_args, _extra, invalid_args} ->
        {:error, IO.inspect(invalid_args, label: "invalid args provided")}
    end
  end

  defp do_parse_args(args) do
    with {:channel, channel} when not is_nil(channel) <- {:channel, args[:channel] || System.get_env("SLACK_CHANNEL")},
         {:token, token} when not is_nil(token) <- {:token, args[:token] || System.get_env("SLACK_AUTH_TOKEN")}
    do
      args =
        args
        |> Keyword.put(:channel, channel)
        |> Keyword.put(:token, token)

      {:ok, args}
    else
      {:channel, _} ->
        {:error, "no channel provided"}

      {:token, _} ->
        {:error, "no token provided"}
    end
  end

  defp prepare_params(params) do
    {method_url, body} =
      cond do
        params[:set_status] ->
          do_prepare_params_for(:status, params)

        params[:set_presence] ->
          do_prepare_params_for(:presence, params)

        true ->
          do_prepare_params_for(:chat, params)
      end

    headers = [
      {"User-Agent", "SlackPresence"},
      {"Authorization", "Bearer #{params[:token]}"},
      {"Content-type", "application/json"}
    ]
    body = Jason.encode!(body)
    {:ok, {method_url, headers, body}}
  end

  def do_prepare_params_for(:status, params) do
    method_url = ~s(#{@slack_api_endpoint}/users.profile.set)
    {status_text, status_emoji} =
      case String.split(params[:msg]) do
        [] -> {"", ""}
        [status_text | result] -> {status_text, Enum.join(result, " ")}
      end
    body = %{profile: %{status_text: status_text, status_emoji: status_emoji, status_expiration: 0}, as_user: true}
    {method_url, body}
  end

  def do_prepare_params_for(:presence, params) do
    method_url = ~s(#{@slack_api_endpoint}/users.setPresence)
    body = %{presence: params[:msg], as_user: true}
    {method_url, body}
  end

  def do_prepare_params_for(:chat, params) do
    method_url = ~s(#{@slack_api_endpoint}/chat.postMessage)
    body = %{text: params[:msg], as_user: true, channel: params[:channel]}
    {method_url, body}
  end

  def usage, do: IO.puts @usage
end
