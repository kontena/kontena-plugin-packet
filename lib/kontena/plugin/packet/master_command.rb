class Kontena::Plugin::Packet::MasterCommand < Kontena::Command
  subcommand "create", "Create a new master to Packet", load_subcommand('kontena/plugin/packet/master/create_command')
end
