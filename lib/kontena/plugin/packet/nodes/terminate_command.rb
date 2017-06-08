require 'kontena/plugin/packet/token_option'
require 'kontena/plugin/packet/project_option'

module Kontena::Plugin::Packet::Nodes
  class TerminateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions

    parameter "NAME", "Node name"

    include Kontena::Plugin::Packet::TokenOption
    include Kontena::Plugin::Packet::ProjectOption

    def execute
      require_api_url
      require_current_grid
      require 'kontena/machine/packet'
      grid = client(require_token).get("grids/#{current_grid}")
      destroyer = destroyer(client(require_token), token)
      destroyer.run!(grid, project, name)
    end

    # @param [Kontena::Client] client
    # @param [String] token
    def destroyer(client, token)
      Kontena::Machine::Packet::NodeDestroyer.new(client, token)
    end
  end
end
