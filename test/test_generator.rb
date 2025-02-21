# frozen_string_literal: true

# (The MIT License)
#
# SPDX-FileCopyrightText: Copyright (c) 2024 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'tmpdir'
require_relative 'test__helper'
require_relative '../lib/jekyll-shorts/generator'

# Generator test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class JekyllShorts::GeneratorTest < Minitest::Test
  def test_simple_scenario
    Dir.mktmpdir do |home|
      post = File.join(home, '2023-01-01-hello.md')
      File.write(post, "---\ntitle: Hello\n---\n\nHello, world!")
      site = JekyllShorts::FakeSite.new(
        {
          'url' => 'https://www.yegor256.com/',
          'shorts' => {
            'permalink' => ':year:month.html'
          }
        },
        [post]
      )
      gen = JekyllShorts::Generator.new
      gen.generate(site)
    end
  end

  def test_two_similar_posts
    Dir.mktmpdir do |home|
      first = File.join(home, '2023-01-01-first.md')
      File.write(first, "---\ntitle: Hello\n---\n\nHello, world!")
      second = File.join(home, '2023-01-01-second.md')
      File.write(second, "---\ntitle: Hello\n---\n\nHello, world!")
      site = JekyllShorts::FakeSite.new(
        {
          'url' => 'https://www.yegor256.com/',
          'shorts' => {
            'permalink' => ':y:m:letter.html'
          }
        },
        [first, second]
      )
      gen = JekyllShorts::Generator.new
      gen.generate(site)
    end
  end
end
