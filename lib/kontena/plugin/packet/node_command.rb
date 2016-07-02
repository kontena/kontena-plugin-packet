require_relative 'nodes/create_command'
require_relative 'nodes/restart_command'
require_relative 'nodes/terminate_command'

class Kontena::Plugin::Packet::NodeCommand < Kontena::Command

  subcommand "create", "Create a new node to Packet", Kontena::Plugin::Packet::Nodes::CreateCommand
  subcommand "restart", "Restart a Packet node", Kontena::Plugin::Packet::Nodes::RestartCommand
  subcommand "terminate", "Terminate a Packet node", Kontena::Plugin::Packet::Nodes::TerminateCommand

  def execute
  end
end
