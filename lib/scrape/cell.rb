class Scrape
  class Scrape::Cell

    attr_reader :cell, :output_dir

    def initialize(opts = {})
      @cell = opts.fetch(:cell)
      @output_dir = opts.fetch(:output_dir)
    end

    def parse
      all_results = []
      result = {}

      cell.children.each do |child|
        if child.name == 'h2'
          accumulate_and_clear(all_results, result)
          extract_h2_tag_into(result, child)
        end
      end
      accumulate_and_clear(all_results, result)

      all_results.each do |res|
        if res[:filename]
          FileUtils.touch(res[:filename])
        end
      end
    end

    private

    def extract_h2_tag_into(result, child)
      file_name = child.text.downcase.gsub(/[^a-z0-9]/, '_').gsub(/(_)+/, '_').gsub(/_$/, '')

      result[:filename] = File.join(output_dir, "#{file_name}.yml")
      result[:title] = child.text
    end

    def accumulate_and_clear(all_items, item)
      unless item.keys.size == 0
        all_items << item.dup
        item = {}
      end
    end

  end
end
