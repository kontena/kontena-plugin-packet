require 'kontena_cli'
require 'kontena/plugin/packet'
require 'kontena/cli/subcommand_loader'

Kontena::MainCommand.register("packet", "Packet specific commands", Kontena::Cli::SubcommandLoader.new('kontena/plugin/packet_command'))
