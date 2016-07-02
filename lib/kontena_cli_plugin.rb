require 'kontena_cli'
require_relative 'kontena/plugin/packet'
require_relative 'kontena/plugin/packet_command'

Kontena::MainCommand.register("packet", "Packet specific commands", Kontena::Plugin::PacketCommand)
