class Kontena::Plugin::Packet::NodeCommand < Kontena::Command
  subcommand "create", "Create a new node to Packet", load_subcommand('kontena/plugin/packet/nodes/create_command')
  subcommand "restart", "Restart a Packet node", load_subcommand('kontena/plugin/packet/nodes/restart_command')
  subcommand "terminate", "Terminate a Packet node", load_subcommand('kontena/plugin/packet/nodes/terminate_command')
end
