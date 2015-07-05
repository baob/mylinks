require_relative '../../lib/scrape'

describe Scrape do
  describe 'instantiated without params' do
    specify { expect(subject).to respond_to(:run) }
  end
end
