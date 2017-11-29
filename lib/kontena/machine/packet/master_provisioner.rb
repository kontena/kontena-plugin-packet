require 'json'

module Kontena
  module Machine
    module Packet
      class MasterProvisioner
        include RandomName
        include Machine::CertHelper
        include PacketCommon
        include Kontena::Cli::Common

        attr_reader :client, :http_client

        # @param [String] token Packet token
        def initialize(token)
          @client = login(token)
        end

        def run!(opts)
          abort('Project does not exist in Packet') unless project = find_project(opts[:project])
          abort('Facility does not exist in Packet') unless facility = find_facility(opts[:facility])
          abort('Operating system coreos_stable does not exist in Packet') unless os = find_os('coreos_stable')
          abort('Device type does not exist in Packet') unless plan = find_plan(opts[:plan])

          check_or_create_ssh_key(opts[:ssh_key]) if opts[:ssh_key]

          if opts[:ssl_cert]
            abort('Invalid ssl cert') unless File.exists?(File.expand_path(opts[:ssl_cert]))
            ssl_cert = File.read(File.expand_path(opts[:ssl_cert]))
          else
            spinner "Generating a self-signed SSL certificate" do
              ssl_cert = generate_self_signed_cert
            end
          end

          if respond_to?(:certificate_public_key) && !opts[:ssl_cert]
            ssl_cert_public = certificate_public_key(ssl_cert)
          end

          if !opts[:name]
            name = generate_name
          else
            name = opts[:name]
          end

          userdata_vars = opts.merge(
            ssl_cert: ssl_cert,
            server_name: name.sub('kontena-master-', '')
          )

          device = project.new_device(
            hostname: name,
            facility: facility.to_hash,
            operating_system: os.to_hash,
            plan: plan.to_hash,
            billing_cycle: opts[:billing],
            locked: true,
            userdata: user_data(userdata_vars, 'cloudinit_master.yml')
          )

          spinner "Creating a Packet device #{device.hostname.colorize(:cyan)} " do
            api_retry "Packet API reported an error, please try again" do
              response = client.create_device(device)
              raise response.body unless response.success?
            end

            until device && [:active, :provisioning, :powering_on].include?(device.state)
              device = find_device(project.id, device.hostname) rescue nil
              sleep 5
            end
          end

          public_ip = spinner "Looking for device public IP" do
            device_public_ip(device)
          end
          master_url = "https://#{public_ip['address']}"

          Excon.defaults[:ssl_verify_peer] = false
          @http_client = Excon.new("#{master_url}", :connect_timeout => 10)

          spinner "Waiting for #{device.hostname.colorize(:cyan)} to start (estimate 4 minutes)" do
            sleep 0.5 until master_running?
          end

          master_version = nil
          spinner "Retrieving Kontena Master version" do
            master_version = JSON.parse(http_client.get(path: '/').body)["version"] rescue nil
          end

          spinner "Kontena Master #{master_version} is now running at #{master_url}".colorize(:green)

          {
            name: name.sub('kontena-master-', ''),
            public_ip: public_ip['address'],
            code: opts[:initial_admin_code],
            provider: 'packet',
            ssl_certificate: ssl_cert_public,
            version: master_version
          }
        end

        def generate_name
          "kontena-master-#{super}-#{rand(1..9)}"
        end

        def master_running?
          http_client.get(path: '/').status == 200
        rescue
          false
        end

      end
    end
  end
end
