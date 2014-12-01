require 'buckaroo_client/configuration'

describe BuckarooClient::Configuration do
  RSpec.shared_examples 'getter/setter' do |name|
    it "defines `#{name}' getter and setter" do
      subject.public_send("#{name}=", 'bla')
      expect(subject.public_send(name)).to eq 'bla'
    end
  end

  describe '#websitekey' do
    include_examples 'getter/setter', 'websitekey'
  end

  describe '#secret' do
    include_examples 'getter/setter', 'secret'
  end

  describe '#environment' do
    include_examples 'getter/setter', 'environment'

    it 'defaults to \'test\'' do
      expect(subject.environment).to eq 'test'
    end
  end

end
