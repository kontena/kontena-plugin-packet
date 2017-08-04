module Kontena::Plugin::Packet
  module SshKeyOption

    DEFAULT_PATH = File.join(Dir.home, '.ssh', 'id_rsa.pub')

    def self.included(base)
      base.option "--ssh-key", "PATH", "Path to ssh public key", attribute_name: :ssh_key_path, default: DEFAULT_PATH
      base.class_eval do
        def ssh_key
          if ssh_key_path
            begin
              return File.read(ssh_key_path).strip
            rescue => ex
              unless ssh_key_path == DEFAULT_PATH
                raise ex
              end
            end
          end

          require 'packet'
          client = Packet::Client.new(self.token || (self.respond_to?(:default_token) && self.default_token))

          keys = client.list_ssh_keys

          if keys.empty?
            prompt.ask('SSH public key: (enter an ssh key in OpenSSH format "ssh-xxx xxxxx key_name")') do |q|
              q.validate /^ssh-rsa \S+ \S+$/
            end
          else
            keys.first.key
          end
        end
      end
    end
  end
end
