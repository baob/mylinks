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
        elsif child.name == 'table'
          child.css('tr > td').children.each do |internal_cell|
            if internal_cell.name == 'hr'
              extract_hr_tag_into(result, internal_cell)
            elsif internal_cell.name == 'a'
              extract_anchor_tag_into(result, internal_cell)
            end
          end
        end
      end
      accumulate_and_clear(all_results, result)

      all_results.each do |res|
        if res['filename']
          FileUtils.touch(res['filename'])
          File.open(res['filename'], 'w') {|f| f.write res.to_yaml }
        end
      end
    end

    private

    def extract_h2_tag_into(result, child)
      file_name = child.text.downcase.gsub(/[^a-z0-9]/, '_').gsub(/(_)+/, '_').gsub(/_$/, '')

      result['filename'] = File.join(output_dir, "#{file_name}.yml")
      result['title'] = child.text
    end

    def extract_hr_tag_into(result, child)
      result['elements'] ||= []
      result['elements'] << 'hr'
    end

    def extract_anchor_tag_into(result, child)
      anchor = { 'anchor' => { 'href' => child.attributes['href'].value.strip, 'text' => child.text.strip } }
      result['elements'] ||= []
      result['elements'] << anchor
    end

    def accumulate_and_clear(all_items, item)
      unless item.keys.size == 0
        all_items << item.dup
        item = {}
      end
    end

  end
end
