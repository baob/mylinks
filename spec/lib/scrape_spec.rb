require_relative '../../lib/scrape'
require 'fileutils'

describe Scrape do
  describe 'instantiated without params' do
    specify { expect(subject).to respond_to(:run) }
  end

  describe 'instantiated with dir: tmp/data' do
    subject { described_class.new(dir: 'tmp/data') }

    describe '#clear' do
      let(:test_file) { File.join(app_root, 'tmp', 'data', 'test.txt') }
      let(:test_dir) { File.join(app_root, 'tmp', 'data') }
      before do
        FileUtils.mkdir_p(test_dir)
        FileUtils.touch(test_file)
      end

      specify 'clears the directory' do
        expect { subject.clear }.to change { File.exist?(test_file) }.to be_falsey
      end
    end

    describe '#run' do
      %w( daily dailyplay ).each do |page|
        specify "creates directory #{page} in directory data" do
          skip
        end
      end
    end
  end
end
