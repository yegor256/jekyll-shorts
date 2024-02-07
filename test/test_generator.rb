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
