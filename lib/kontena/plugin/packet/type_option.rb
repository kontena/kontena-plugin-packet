module Kontena::Plugin::Packet
  module TypeOption

    def self.included(base)
      base.option "--type", "SLUG", "Packet server plan type", attribute_name: :plan
      base.class_eval do
        def default_plan
          require 'packet'

          client = Packet::Client.new(self.token || (self.respond_to?(:default_token) && self.default_token))

          plans = []
          spinner "Retrieving a list of available plans at Packet" do
            plans = client.list_plans
          end

          case plans.size
          when 0
            abort 'You do not have access to any plans on Packet'
          when 1
            unless Kontena.prompt.yes?("You have access to plan '#{plans.first.name}'. Use?")
              abort 'Aborted'
            end
            plans.first.slug
          else
            puts
            puts pastel.bright_blue("Packet plans:")
            puts
            plans.each do |plan|
              puts pastel.green("  #{"%-11s" % "#{plan.name}:"}")
              puts pastel.bright_blue("     #{plan.description}")
            end
            puts

            Kontena.prompt.select "Packet plan:" do |menu|
              plans.each do |plan|
                menu.choice plan.name, plan.slug
              end
            end
          end
        end
      end
    end
  end
end


