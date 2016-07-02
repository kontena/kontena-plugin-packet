require_relative 'packet/master_command'
require_relative 'packet/node_command'

class Kontena::Plugin::PacketCommand < Kontena::Command

  subcommand 'master', 'Packet master related commands', Kontena::Plugin::Packet::MasterCommand
  subcommand 'node', 'Packet node related commands', Kontena::Plugin::Packet::NodeCommand

  def execute
  end
end
