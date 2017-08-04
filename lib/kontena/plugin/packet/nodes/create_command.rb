require 'kontena/plugin/packet/token_option'
require 'kontena/plugin/packet/project_option'
require 'kontena/plugin/packet/type_option'
require 'kontena/plugin/packet/facility_option'
require 'kontena/plugin/packet/ssh_key_option'

module Kontena::Plugin::Packet::Nodes
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Plugin::Packet::TokenOption
    include Kontena::Plugin::Packet::ProjectOption
    include Kontena::Plugin::Packet::TypeOption
    include Kontena::Plugin::Packet::FacilityOption
    include Kontena::Plugin::Packet::SshKeyOption

    parameter "[NAME]", "Node name"

    option "--billing", "BILLING", "Billing cycle", default: 'hourly'
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'

    def execute
      require_api_url
      require_current_grid
      require 'kontena/machine/packet'
      grid = fetch_grid
      provisioner = provisioner(client, token)
      provisioner.run!(
        master_uri: api_url,
        grid_token: grid['token'],
        grid: current_grid,
        project: project,
        billing: billing,
        ssh_key: ssh_key,
        plan: plan,
        facility: facility,
        version: version
      )
    end

    # @param [Kontena::Client] client
    # @param [String] token
    def provisioner(client, token)
      Kontena::Machine::Packet::NodeProvisioner.new(client, token)
    end

    # @return [Hash]
    def fetch_grid
      client.get("grids/#{current_grid}")
    end
  end
end
