require 'spec_helper'
require 'kontena/plugin/packet/nodes/terminate_command'

describe Kontena::Plugin::Packet::Nodes::TerminateCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  let(:provisioner) do
    spy(:provisioner)
  end

  let(:client) do
    spy(:client)
  end

  describe '#run' do
    before(:each) do
      allow(subject).to receive(:require_current_grid).and_return('test-grid')
      allow(subject).to receive(:require_api_url).and_return('http://master.example.com')
      allow(subject).to receive(:api_url).and_return('http://master.example.com')
      allow(subject).to receive(:require_token).and_return('12345')
      allow(subject).to receive(:client).and_return(client)
    end

    it 'raises usage error if no options are defined' do
      expect {
        subject.run([])
      }.to raise_error(Clamp::UsageError)
    end

    it 'passes options to provisioner' do
      options = [
        '--token', 'secretone',
        '--project', 'some-id',
        'my-node'
      ]
      expect(subject).to receive(:destroyer).with(client, 'secretone').and_return(provisioner)
      expect(provisioner).to receive(:run!)
      subject.run(options)
    end
  end
end
