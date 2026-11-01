# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024-2026 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require_relative 'test__helper'
require_relative '../lib/jekyll-shorts/letters'

# Letters test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024-2026 Yegor Bugayenko
# License:: MIT
class JekyllShorts::LettersTest < Minitest::Test
  def test_simple_scenario
    letters = JekyllShorts::Letters.new
    mnemo = 'hey'

    assert_equal('', letters.next(mnemo))
    assert_equal('a', letters.next(mnemo))
    assert_equal('b', letters.next(mnemo))
  end

  def test_different_mnemo
    letters = JekyllShorts::Letters.new
    letters.next('hey')

    assert_equal('', letters.next('hey!'))
  end
end
