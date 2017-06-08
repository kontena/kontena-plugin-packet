module Kontena
  module Machine
    module Packet
      class NodeDestroyer
        include RandomName
        include PacketCommon
        include Kontena::Cli::ShellSpinner

        attr_reader :client, :api_client

        # @param [Kontena::Client] api_client Kontena api client
        # @param [String] token Packet api token
        def initialize(api_client, token)
          @api_client = api_client
          @client = login(token)
        end

        def run!(grid, project_id, name)
          device = client.list_devices(project_id).find{|d| d.hostname == name}
          abort("Device #{name.colorize(:cyan)} not found in Packet") unless device

          spinner "Terminating Packet device #{name.colorize(:cyan)} " do
            begin
              response = client.delete_device(device.id)
              raise unless response.success?
            rescue
              abort "Cannot delete device #{name.colorize(:cyan)} in Packet"
            end
          end

          node = api_client.get("grids/#{grid['id']}/nodes")['nodes'].find{|n| n['name'] == name}
          if node
            spinner "Removing node #{name.colorize(:cyan)} from grid #{grid['name'].colorize(:cyan)} " do
              Kontena.run!(['node', 'rm', '--force', '--grid', grid['id'], name])
            end
          end
        end
      end
    end
  end
end
