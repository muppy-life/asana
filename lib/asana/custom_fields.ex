defmodule Asana.CustomFields do
  alias Asana.Api

  def get_workspace_custom_fields(workspace_gid, params \\ [limit: 10]) do
    url = "/workspaces/:workspace_gid/custom_fields"
    params = Keyword.merge([workspace_gid: workspace_gid], params)
    Api.request(:get, url, params)
  end

  @doc """
  Creates a new enum option on an enum custom field.

  `attrs` must include `:name` and may include `:color`, `:insert_before`,
  or `:insert_after`.
  """
  def create_enum_option(custom_field_gid, attrs) do
    url = "/custom_fields/:custom_field_gid/enum_options"
    params = [custom_field_gid: custom_field_gid]
    body = %{data: Map.new(attrs)}
    Api.request(:post, url, params, body)
  end

  @doc """
  Updates an existing enum option. Use `%{enabled: false}` to disable an
  option in use by existing tasks (Asana rejects hard deletes of in-use
  options).
  """
  def update_enum_option(enum_option_gid, attrs) do
    url = "/enum_options/:enum_option_gid"
    params = [enum_option_gid: enum_option_gid]
    body = %{data: Map.new(attrs)}
    Api.request(:put, url, params, body)
  end
end
