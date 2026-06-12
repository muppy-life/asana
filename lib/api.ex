defmodule Asana.Api do
  use Tesla
  require Logger

  alias Asana.Utils

  plug Tesla.Middleware.BaseUrl, Utils.get_base_url()
  plug Tesla.Middleware.BearerAuth, token: Utils.get_access_key()
  plug Tesla.Middleware.PathParams
  plug Tesla.Middleware.JSON

  def request(:get, url, params) do
    {path_params, query_params} = split_params(url, params)

    url
    |> merge_query_params(query_params)
    |> get(opts: [path_params: path_params])
    |> manage_request()
  end

  def request(:post, url, params, body) do
    {path_params, query_params} = split_params(url, params)

    url
    |> merge_query_params(query_params)
    |> post(body, opts: [path_params: path_params])
    |> manage_request()
  end

  def request(:put, url, params, body) do
    {path_params, query_params} = split_params(url, params)

    url
    |> merge_query_params(query_params)
    |> put(body, opts: [path_params: path_params])
    |> manage_request()
  end

  defp manage_request(req) do
    case req do
      {:ok, %Tesla.Env{status: status, body: body}} when status in [200, 201] ->
        {:ok, body}

      error ->
        manage_error(error)
    end
  end

  defp manage_error({:ok, %Tesla.Env{body: msg, status: code}}) do
    msg
    |> inspect()
    |> then(& "Response status: #{code} -> #{&1}")
    |> Logger.error()

    {:error, msg}
  end

  defp manage_error({:error, msg} = error) do
    msg
    |> inspect()
    |> Logger.error()

    error
  end

  @doc """
  Splits `params` into `{path_params, query_params}` for the given `url`.

  A param is a path param when its name appears as a `:name` placeholder in the
  URL template (the same tokens `Tesla.Middleware.PathParams` substitutes); every
  other param is a query param. Keeping them apart prevents a path param from
  also being appended to the query string, which some Asana endpoints — notably
  `/rule_triggers/:rule_trigger_gid/run` — reject with a `400 Invalid payload
  format` naming the duplicated field.
  """
  def split_params(url, params) do
    Enum.split_with(params, fn {key, _value} -> path_param?(url, key) end)
  end

  defp path_param?(url, key) do
    Regex.match?(~r/:#{Regex.escape(to_string(key))}(?![A-Za-z0-9_])/, url)
  end

  def merge_query_params(url, []), do: url

  def merge_query_params(url, params) do
    params
    |> Enum.reduce(url <> "?", fn {key, val}, acc -> acc <> "#{key}=#{val}&" end)
    |> String.trim_trailing("&")
  end
end
