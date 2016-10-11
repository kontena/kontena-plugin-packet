module Kontena::Plugin::Packet
  module ProjectOption

    def self.included(base)
      base.option "--project", "PROJECT_ID", "Packet project ID", environment_variable: 'PACKET_PROJECT'
      base.class_eval do
        def default_project
          require 'packet'

          client = Packet::Client.new(self.token || (self.respond_to?(:default_token) && self.default_token))

          projects = []
          spinner "Retrieving a list of available projects on Packet" do
            projects = client.list_projects
          end

          case projects.size
          when 0
            abort 'You do not have access to any Projects on Packet'
          when 1
            unless Kontena.prompt.yes?("You have access to project '#{projects.first.name}'. Use?")
              abort 'Aborted'
            end
            projects.first.id
          else
            Kontena.prompt.select "Packet Project:" do |menu|
              projects.each do |project|
                menu.choice project.name, project.id
              end
            end
          end
        end
      end
    end
  end
end

