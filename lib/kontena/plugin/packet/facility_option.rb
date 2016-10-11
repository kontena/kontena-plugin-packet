module Kontena::Plugin::Packet
  module FacilityOption

    def self.included(base)
      base.option "--facility", "CODE", "Packet facility"
      base.class_eval do
        def default_facility
          require 'packet'

          client = Packet::Client.new(self.token || (self.respond_to?(:default_token) && self.default_token))

          facilities = []
          spinner "Retrieving a list of available facilities at Packet" do
            facilities = client.list_facilities
          end

          case facilities.size
          when 0
            abort 'You do not have access to any facilities on Packet'
          when 1
            unless Kontena.prompt.yes?("You have access to facility '#{facilities.first.name}'. Use?")
              abort 'Aborted'
            end
            facilities.first.code
          else
            Kontena.prompt.select "Packet plan:" do |menu|
              facilities.each do |facility|
                if facility.features.empty?
                  feats = ""
                else
                  feats = "(#{facility.features.join(',')})"
                end
                menu.choice "#{facility.name} #{feats}", facility.code
              end
            end
          end
        end
      end
    end
  end
end



