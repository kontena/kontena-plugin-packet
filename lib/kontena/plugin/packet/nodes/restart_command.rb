module Kontena::Plugin::Packet::Nodes
  class RestartCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions

    parameter "NAME", "Node name"
    option "--token", "TOKEN", "Packet API token", required: true
    option "--project", "PROJECT ID", "Packet project id", required: true

    def execute
      require_relative '../../../machine/packet'

      restarter = Kontena::Machine::Packet::NodeRestarter.new(token)
      restarter.run!(project, name)
    end
  end
end
