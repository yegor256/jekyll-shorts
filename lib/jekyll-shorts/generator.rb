# frozen_string_literal: true

# (The MIT License)
#
# Copyright (c) 2024 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'jekyll'
require 'fileutils'
require 'json'
require_relative 'version'

# The module we are in.
module JekyllShorts; end

# Pages generator.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class JekyllShorts::Generator < Jekyll::Generator
  safe true
  priority :lowest

  # Main plugin action, called by Jekyll-core
  def generate(site)
    Jekyll.logger.info("jekyll-shorts #{JekyllShorts::VERSION} starting...")
    config ||= site.config['shorts'] || {}
    permalink ||= config['permalink'] || ':year:month:day'
    start = Time.now
    total = 0
    site.posts.docs.sort_by(&:url).each_with_index do |doc, pos|
      long = doc.url
      short = Jekyll::URL.new(
        template: permalink,
        placeholders: {
          'Y' => doc.date.year.to_s,
          'y' => doc.date.year.to_s[2..],
          'm' => doc.date.month.to_s.rjust(2, '0'),
          'd' => doc.date.day.to_s.rjust(2, '0'),
          'pos' => pos.to_s
        }
      ).to_s
      site.static_files << ShortFile.new(site, short, long)
      doc.data['short-url'] = short
      total += 1
    end
    Jekyll.logger.info("jekyll-shorts #{JekyllShorts::VERSION}: \
#{total} link(s) generated in #{(Time.now - start).round(2)}s")
  end

  # The HTML file with a redirect.
  class ShortFile < Jekyll::StaticFile
    def initialize(site, short, long)
      super(site, site.dest, '', short)
      @long = long
    end

    def write(_dest)
      FileUtils.mkdir_p(File.dirname(path))
      html = "<html><head><meta charset='utf-8'/>\
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'/>\
<meta http-equiv='refresh' content='#{@long}'/></head></html>"
      if File.exist?(path)
        before = File.read(path)
        if before != html
          raise "It's impossible to generate a short link at #{path.inspect}, \
because the file already exists and the content \
of the it differs from what we are going to write into it now (#{@long}). This most \
probably means that previously generated short link will point to a different location \
than before. Try to run 'jekyll clean', it will help, if you know what you are doing."
        end
      else
        File.write(path, html)
        Jekyll.logger.debug("HTML #{path.inspect} -> #{@long.inspect}")
      end
      true
    end
  end
end
