require 'kontena/plugin/packet/token_option'
require 'kontena/plugin/packet/project_option'
require 'kontena/plugin/packet/type_option'
require 'kontena/plugin/packet/facility_option'

module Kontena::Plugin::Packet::Master
  class CreateCommand < Kontena::Command
    include Kontena::Cli::Common
    include Kontena::Plugin::Packet::TokenOption
    include Kontena::Plugin::Packet::ProjectOption
    include Kontena::Plugin::Packet::TypeOption
    include Kontena::Plugin::Packet::FacilityOption

    option "--name", "[NAME]", "Set master name"
    option "--ssl-cert", "PATH", "SSL certificate file (optional)"
    option "--billing", "BILLING", "Billing cycle", default: 'hourly'
    option "--ssh-key", "PATH", "Path to ssh public key", default: File.join(Dir.home, '.ssh', 'id_rsa.pub')
    option "--vault-secret", "VAULT_SECRET", "Secret key for Vault (optional)"
    option "--vault-iv", "VAULT_IV", "Initialization vector for Vault (optional)"
    option "--mongodb-uri", "URI", "External MongoDB uri (optional)"
    option "--version", "VERSION", "Define installed Kontena version", default: 'latest'

    def execute
      require 'securerandom'
      require 'kontena/machine/packet'

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
