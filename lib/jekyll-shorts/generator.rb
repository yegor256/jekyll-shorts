# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2024 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'jekyll'
require 'fileutils'
require 'json'
require 'securerandom'
require_relative 'version'
require_relative 'letters'

# Pages generator.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class JekyllShorts::Generator < Jekyll::Generator
  safe true
  priority :lowest

  # Main plugin action, called by Jekyll-core
  def generate(site)
    config ||= site.config['shorts'] || {}
    permalink ||= config['permalink'] || ':year:month:day:letter.html'
    start = Time.now
    total = 0
    letters = JekyllShorts::Letters.new
    site.posts.docs.each do |doc|
      long = doc.url
      re = SecureRandom.hex(64)
      short = Jekyll::URL.new(
        template: permalink,
        placeholders: {
          'year' => doc.date.year.to_s[2..],
          'month' => doc.date.month.to_s.rjust(2, '0'),
          'day' => doc.date.day.to_s.rjust(2, '0'),
          'letter' => re
        }
      ).to_s
      short.sub!(re, letters.next(short.sub(re, '')))
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

    def modified?
      true
    end

    def modified_time
      Time.now
    end

    def write(_dest)
      FileUtils.mkdir_p(File.dirname(path))
      re = "#{@site.config['url']}#{@long}"
      html = [
        '<!DOCTYPE html>',
        '<html lang="en-US">',
        '<meta charset="utf-8">',
        '<title>Redirecting&hellip;</title>',
        "<link rel='canonical' href='#{re}'>",
        "<script>location='#{re}'</script>",
        "<meta http-equiv='refresh' content='0; url=#{re}'>",
        '<meta name="robots" content="noindex">',
        '<h1>Redirecting&hellip;</h1>',
        "<a href='#{re}'>Click here if you are not redirected.</a>",
        '</html>'
      ].join
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
        Jekyll.logger.debug("Short URL created from #{path.inspect} to #{@long.inspect}")
      end
      true
    end
  end
end
