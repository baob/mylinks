require_relative '../../lib/scrape'
require 'fileutils'
require 'yaml'
require 'pry'

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

      %w( daily links ).each do |page|
        specify "creates directory #{page} in directory data" do
          pending
          expect { subject.run }.to change{ Dir.exist?( File.join(test_dir, page)) }.to be_truthy
        end
      end

      describe 'in daily directory' do

        %w( really_daily really_weekly frequent ).each do |cell|
          specify "creates cell #{cell}.yml" do
            pending
            expect { subject.run }.to change{ File.exist?( File.join(test_dir, 'daily', "#{cell}.yml")) }.to be_truthy
          end
        end

        describe 'in really_daily.yml cell' do
          before { subject.run }
          let(:cell_file) { File.join(test_dir, 'daily', 'really_daily.yml') }
          let(:cell) { YAML.load( File.open(cell_file)) }

          specify { pending ; expect(cell).not_to be_falsey }
          specify { pending ; expect(cell).to match(a_hash_including('title' => 'Really Daily')) }
          specify { pending ; expect(cell).to match(a_hash_including('filename' => cell_file)) }
        end

      end
    end
  end
end
