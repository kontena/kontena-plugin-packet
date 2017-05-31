require 'spec_helper'
require 'kontena/plugin/packet/master_command'

describe Kontena::Plugin::Packet::MasterCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  describe '#run' do
    it 'raises help wanted' do
      expect {
        subject.run([])
      }.to raise_error(Clamp::HelpWanted)
    end

    it 'raises help wanted for create' do
      expect {
        subject.run(['create', '--help'])
      }.to raise_error(Clamp::HelpWanted)
    end

    it 'raises error otherwise' do
      expect {
        subject.run(['unknown'])
      }.to raise_error(Clamp::UsageError)
    end
  end
end
