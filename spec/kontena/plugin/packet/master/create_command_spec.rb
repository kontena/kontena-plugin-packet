require 'spec_helper'
require 'kontena/plugin/packet_command'

describe Kontena::Plugin::Packet::Master::CreateCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  let(:provisioner) do
    spy(:provisioner)
  end

  describe '#run' do
    it 'raises usage error if no options are defined' do
      expect {
        subject.run([])
      }.to raise_error(Clamp::UsageError)
    end

    it 'passes options to provisioner' do
      options = [
        '--token', 'secretone',
        '--project', 'some-id'
      ]
      expect(subject).to receive(:provisioner).with('secretone').and_return(provisioner)
      expect(provisioner).to receive(:run!).with(
        hash_including(project: 'some-id')
      )
      subject.run(options)
    end
  end
end
