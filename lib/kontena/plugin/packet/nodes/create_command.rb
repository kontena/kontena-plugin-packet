require_relative '../token_option'
require_relative '../project_option'
require_relative '../type_option'
require_relative '../facility_option'

module Kontena::Plugin::Packet::Nodes
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Cli::GridOptions
    include Kontena::Plugin::Packet::TokenOption
    include Kontena::Plugin::Packet::ProjectOption
    include Kontena::Plugin::Packet::TypeOption
    include Kontena::Plugin::Packet::FacilityOption

    parameter "[NAME]", "Node name"

    option "--billing", "BILLING", "Billing cycle", default: 'hourly'
    option "--ssh-key", "PATH", "Path to ssh public key", default: File.join(Dir.home, '.ssh', 'id_rsa.pub')
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'

    def execute
      require_api_url
      require_current_grid

      require_relative '../../../machine/packet'
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
