defmodule Asana.RuleTriggers do
  @moduledoc """
  Functions for running Asana rules through rule triggers.

  Rules configured with an "incoming web request" trigger expose a unique
  endpoint that external applications can call to run the rule on demand.
  The rule's checks (e.g. "task is in section X") are still evaluated at run
  time: Asana responds with an error when they are not met and the rule's
  actions are not executed.
  """

  alias Asana.Api

  @doc """
  Runs a rule which uses an "incoming web request" trigger.

  ## Parameters

    * `rule_trigger_gid` - The identifier of the incoming web request trigger.
      It is the numeric segment of the web request URL Asana generates when
      the trigger is added to the rule.
    * `task_gid` - The globally unique identifier for the task the rule should
      act on. The task must belong to the rule's project.
    * `action_data` - Optional map of variables accessible from within the
      rule. Asana requires the key to be present even when the rule uses no
      variables, so it defaults to an empty map.

  ## Examples

      Asana.RuleTriggers.run("rule_trigger_gid", "task_gid")
      Asana.RuleTriggers.run("rule_trigger_gid", "task_gid", %{status: "In progress"})
  """
  def run(rule_trigger_gid, task_gid, action_data \\ %{}) do
    url = "/rule_triggers/:rule_trigger_gid/run"
    params = [rule_trigger_gid: rule_trigger_gid]

    body = %{data: %{resource: task_gid, action_data: action_data}}

    Api.request(:post, url, params, body)
  end
end
