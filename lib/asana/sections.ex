defmodule Asana.Sections do
  @moduledoc """
  Functions for interacting with Asana Sections.

  Sections are subdivisions of a project that group tasks together.
  """

  alias Asana.Api

  @doc """
  Returns a list of all sections in the given project.

  ## Parameters

    * `project_gid` - The globally unique identifier for the project.
    * `params` - Optional query parameters (e.g., `limit`, `opt_fields`).
  """
  def get_sections_from_project(project_gid, params \\ []) do
    url = "/projects/:project_gid/sections"
    params = Keyword.merge([project_gid: project_gid], params)
    Api.request(:get, url, params)
  end

  @doc """
  Moves an existing task into a section.

  If the task is already in another section of the same project, it will be
  removed from the old section and placed in the new one. The task is inserted
  at the top of the section unless `insert_before` or `insert_after` is provided.

  ## Parameters

    * `section_gid` - The globally unique identifier for the target section.
    * `task_gid` - The globally unique identifier for the task to move.
    * `opts` - Optional positioning parameters:
      * `insert_before` - A task GID. The task will be placed before this task.
      * `insert_after` - A task GID. The task will be placed after this task.

  ## Examples

      Asana.Sections.add_task("section_gid", "task_gid")
      Asana.Sections.add_task("section_gid", "task_gid", insert_after: "other_task_gid")
  """
  def add_task(section_gid, task_gid, opts \\ []) do
    url = "/sections/:section_gid/addTask"
    params = [section_gid: section_gid]

    body = %{data: Map.merge(%{task: task_gid}, Map.new(opts))}

    Api.request(:post, url, params, body)
  end
end
