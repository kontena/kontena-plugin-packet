require_relative 'master/create_command'

class Kontena::Plugin::Packet::MasterCommand < Kontena::Command

  subcommand "create", "Create a new master to Packet", Kontena::Plugin::Packet::Master::CreateCommand

  def execute
  end
end
