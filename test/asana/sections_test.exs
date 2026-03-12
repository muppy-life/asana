defmodule Asana.SectionsTest do
  use ExUnit.Case

  test "get_sections_from_project/1 works as expected" do
    {:ok, %{"data" => [project | _rest]}} = Asana.Projects.get_multiple_projects()
    {result, %{"data" => sections}} = Asana.Sections.get_sections_from_project(project["gid"])
    assert is_list(sections)
    assert result == :ok
  end

  test "add_task/2 works as expected" do
    {:ok, %{"data" => [project | _rest]}} = Asana.Projects.get_multiple_projects()
    {:ok, %{"data" => [section | _rest]}} = Asana.Sections.get_sections_from_project(project["gid"])
    {:ok, %{"data" => [task | _rest]}} = Asana.Tasks.get_multiple_tasks(project: project["gid"])

    {result, _data} = Asana.Sections.add_task(section["gid"], task["gid"])
    assert result == :ok
  end
end
