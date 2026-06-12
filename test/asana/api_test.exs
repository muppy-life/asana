defmodule Asana.ApiTest do
  use ExUnit.Case, async: true

  alias Asana.Api

  describe "split_params/2" do
    test "classifies URL placeholders as path params and the rest as query params" do
      url = "/tasks/:task_gid"
      params = [task_gid: "123", opt_fields: "name,assignee"]

      assert {[task_gid: "123"], [opt_fields: "name,assignee"]} =
               Api.split_params(url, params)
    end

    test "a gid used only as a path param is not duplicated into the query string" do
      url = "/rule_triggers/:rule_trigger_gid/run"

      assert {[rule_trigger_gid: "1215579956175918"], []} =
               Api.split_params(url, rule_trigger_gid: "1215579956175918")
    end

    test "does not match a shorter key against a longer placeholder" do
      # `:project` must not be confused with the `:project_gid` placeholder.
      assert {[], [project: "999"]} =
               Api.split_params("/projects/:project_gid/sections", project: "999")
    end
  end

  describe "merge_query_params/2" do
    test "returns the URL unchanged when there are no query params" do
      url = "/rule_triggers/:rule_trigger_gid/run"
      assert Api.merge_query_params(url, []) == url
    end

    test "appends only the given params as a query string" do
      assert Api.merge_query_params("/tasks/:task_gid", opt_fields: "name") ==
               "/tasks/:task_gid?opt_fields=name"
    end
  end

  describe "regression: rule_triggers/:gid/run URL has no stray query param" do
    test "the path param is never echoed into the query string" do
      url = "/rule_triggers/:rule_trigger_gid/run"
      {_path_params, query_params} = Api.split_params(url, rule_trigger_gid: "1215579956175918")

      # Before the fix this produced ".../run?rule_trigger_gid=1215579956175918",
      # which Asana rejects with a 400.
      assert Api.merge_query_params(url, query_params) == "/rule_triggers/:rule_trigger_gid/run"
    end
  end
end
