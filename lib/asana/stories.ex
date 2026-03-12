defmodule Asana.Stories do
  @moduledoc """
  Functions for interacting with Asana Stories.

  Stories represent activity on a task, including user comments and
  system-generated events (e.g., task assignments, status changes).
  """

  alias Asana.Api

  @doc """
  Returns all stories (comments and activity) for a task.

  The result includes both user comments (`"type": "comment"`) and
  system-generated stories (`"type": "system"`).

  ## Parameters

    * `task_gid` - The globally unique identifier for the task.
    * `params` - Optional query parameters (e.g., `limit`, `opt_fields`).
  """
  def get_stories_from_task(task_gid, params \\ []) do
    url = "/tasks/:task_gid/stories"
    params = Keyword.merge([task_gid: task_gid], params)
    Api.request(:get, url, params)
  end

  @doc """
  Creates a comment on a task.

  The comment is authored by the user associated with the configured access
  token and timestamped when received by the server.

  ## Parameters

    * `task_gid` - The globally unique identifier for the task.
    * `text` - The plain text body of the comment.
    * `opts` - Optional parameters (e.g., `is_pinned`).

  ## Examples

      Asana.Stories.create_story("task_gid", "Looks good to me!")
      Asana.Stories.create_story("task_gid", "Pinned note", is_pinned: true)
  """
  def create_story(task_gid, text, opts \\ []) do
    url = "/tasks/:task_gid/stories"
    params = [task_gid: task_gid]

    body = %{data: Map.merge(%{text: text}, Map.new(opts))}

    Api.request(:post, url, params, body)
  end
end
