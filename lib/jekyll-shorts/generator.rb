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
    site.posts.docs.each_with_index do |doc, pos|
      long = doc.url
      short = Jekyll::URL.new(
        template: permalink,
        placeholders: {
          'year' => doc.date.year.to_s,
          'month' => doc.date.month.to_s.rjust(2, '0'),
          'day' => doc.date.day.to_s.rjust(2, '0'),
          'position' => pos.to_s
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
      html = "<html> redirect to #{@long}</html>"
      File.write(path, html)
      Jekyll.logger.info("HTML #{path.inspect} -> #{@long.inspect}")
      true
    end
  end
end
