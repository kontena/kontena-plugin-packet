class Kontena::Plugin::PacketCommand < Kontena::Command
  subcommand 'master', 'Packet master related commands', load_subcommand('kontena/plugin/packet/master_command')
  subcommand 'node', 'Packet node related commands', load_subcommand('kontena/plugin/packet/node_command')
end
