require 'securerandom'

module Kontena::Plugin::Packet::Master
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common

    option "--token", "TOKEN", "Packet API token", required: true
    option "--project", "PROJECT ID", "Packet project id", required: true
    option "--ssl-cert", "PATH", "SSL certificate file (optional)"
    option "--type", "TYPE", "Server type (baremetal_0, baremetal_1, ..)", default: 'baremetal_0', attribute_name: :plan
    option "--facility", "FACILITY CODE", "Facility", default: 'ams1'
    option "--billing", "BILLING", "Billing cycle", default: 'hourly'
    option "--ssh-key", "PATH", "Path to ssh public key (optional)"
    option "--vault-secret", "VAULT_SECRET", "Secret key for Vault (optional)"
    option "--vault-iv", "VAULT_IV", "Initialization vector for Vault (optional)"
    option "--mongodb-uri", "URI", "External MongoDB uri (optional)"
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'

    def execute
      require_relative '../../../machine/packet'

      provisioner = provisioner(token)
      provisioner.run!(
          project: project,
          billing: billing,
          ssh_key: ssh_key,
          ssl_cert: ssl_cert,
          plan: plan,
          facility: facility,
          version: version,
          vault_secret: vault_secret || SecureRandom.hex(24),
          vault_iv: vault_iv || SecureRandom.hex(24),
          initial_admin_code: SecureRandom.hex(16),
          mongodb_uri: mongodb_uri
      )
    end

    # @param [String] token
    def provisioner(token)
      Kontena::Machine::Packet::MasterProvisioner.new(token)
    end
  end
end
