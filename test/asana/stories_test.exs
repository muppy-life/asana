defmodule Asana.StoriesTest do
  use ExUnit.Case

  test "get_stories_from_task/1 works as expected" do
    {:ok, %{"data" => [project | _rest]}} = Asana.Projects.get_multiple_projects()
    {:ok, %{"data" => [task | _rest]}} = Asana.Tasks.get_multiple_tasks(project: project["gid"])

    {result, %{"data" => stories}} = Asana.Stories.get_stories_from_task(task["gid"])
    assert is_list(stories)
    assert result == :ok
  end

  test "create_story/2 works as expected" do
    {:ok, %{"data" => [project | _rest]}} = Asana.Projects.get_multiple_projects()
    {:ok, %{"data" => [task | _rest]}} = Asana.Tasks.get_multiple_tasks(project: project["gid"])

    {result, %{"data" => story}} = Asana.Stories.create_story(task["gid"], "Test comment from integration tests")
    assert story["gid"] != nil
    assert story["resource_type"] == "story"
    assert story["text"] == "Test comment from integration tests"
    assert result == :ok
  end
end
