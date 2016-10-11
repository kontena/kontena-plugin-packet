module Kontena::Plugin::Packet
  module TokenOption
    def self.included(base)
      base.option "--token", "TOKEN", "Packet API token", environment_variable: 'PACKET_TOKEN'
      base.class_eval do
        def default_token
          Kontena.prompt.ask("Packet API token:")
        end
      end
    end
  end
end
