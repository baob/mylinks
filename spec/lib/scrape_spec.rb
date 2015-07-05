require_relative '../../lib/scrape'
require 'fileutils'

describe Scrape do
  describe 'instantiated without params' do
    specify { expect(subject).to respond_to(:run) }
  end

  describe 'instantiated with dir: tmp/data' do
    let(:test_file) { File.join(app_root, 'tmp', 'data', 'test.txt') }
    let(:test_dir) { File.join(app_root, 'tmp', 'data') }
    subject { described_class.new(dir: 'tmp/data') }

    describe '#clear' do
      before do
        FileUtils.mkdir_p(test_dir)
        FileUtils.touch(test_file)
      end

      specify 'clears the directory' do
        expect { subject.clear }.to change { File.exist?(test_file) }.to be_falsey
      end

      context 'and when the directory contains sub-directories' do
        before do
          FileUtils.rm_rf(test_dir)
          FileUtils.mkdir_p(test_file)
        end

        specify 'clears the sub-directory' do
          expect { subject.clear }.to change { Dir.exist?(test_file) }.to be_falsey
        end

      end
    end

    describe '#run' do
      before do
        subject.clear
      end

      %w( daily dailyplay ).each do |page|
        specify "creates directory #{page} in directory data" do
          expect { subject.run }.to change{ Dir.exist?( File.join(test_dir, page)) }.to be_truthy
        end
      end
    end
  end
end
