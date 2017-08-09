require 'spec_helper'
require 'kontena/plugin/packet/master/create_command'
require 'ostruct'

describe Kontena::Plugin::Packet::Master::CreateCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  let(:provisioner) do
    spy(:provisioner)
  end

  before(:each) do
    subject.config.servers << Kontena::Cli::Config::Server.new(
      name: 'foo',
      url: 'http://foo',
      token: Kontena::Cli::Config::Token.new(
        access_token: 'foo'
      ),
      account: :master
    )
    subject.config.current_server='foo'
    allow(subject).to receive(:ssh_key).and_return("abcd")
  end

  describe '#run' do
    it 'passes options to provisioner' do
      options = [
        '--token', 'secretone',
        '--project', 'some-id',
        '--type', 'some-plan',
        '--no-prompt',
        '--skip-auth-provider',
        '--name', 'some_name',
        '--facility', 'some_facility'
      ]
      expect(subject).to receive(:provisioner).with('secretone').and_return(provisioner)
      expect(provisioner).to receive(:run!).with(
        hash_including(project: 'some-id')
      )
      subject.run(options)
    end
  end
end
