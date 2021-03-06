require_relative "../spec_helper"

describe Kong::KeyAuth do
  let(:valid_attribute_names) do
    %w(id key consumer_id)
  end

  describe 'ATTRIBUTE_NAMES' do
    it 'contains valid names' do
      expect(subject.class::ATTRIBUTE_NAMES).to eq(valid_attribute_names)
    end
  end

  describe 'API_END_POINT' do
    it 'contains valid end point' do
      expect(subject.class::API_END_POINT).to eq('/key-auth/')
    end
  end

  describe '#init_attributes' do
    it 'uses correct api end point if api_id is present' do
      subject = described_class.new({ consumer_id: ':consumer_id' })
      expect(subject.api_end_point).to eq('/consumers/:consumer_id/key-auth/')
    end
  end

  describe '#create' do
    it 'remove consumer_id from request body' do
      headers = {'Content-Type' => 'application/json'}
      attributes = {'consumer_id' => 'aaaaaaaa-aaaa-4aaa-aaaa-aaaaaaaaaaaa', 'key' => 'bbbbbbbb-bbbb-4bbb-bbbb-bbbbbbbbbbbb'}
      api_attributes = {'key' => 'bbbbbbbb-bbbb-4bbb-bbbb-bbbbbbbbbbbb'}
      expect(Kong::Client.instance).to receive(:post).with('/consumers/aaaaaaaa-aaaa-4aaa-aaaa-aaaaaaaaaaaa/key-auth/', api_attributes, nil, headers).and_return(attributes)
      subject = described_class.new(attributes)
      subject.create
    end
  end
end
