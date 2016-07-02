require 'spec_helper'
require 'kontena/plugin/digital_ocean_command'

describe Kontena::Plugin::DigitalOcean::Master::CreateCommand do

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
        '--token', 'secretone'
      ]
      expect(subject).to receive(:provisioner).with('secretone').and_return(provisioner)
      expect(provisioner).to receive(:run!).with(
        hash_including(ssh_key: '~/.ssh/id_rsa.pub')
      )
      subject.run(options)
    end
  end
end
