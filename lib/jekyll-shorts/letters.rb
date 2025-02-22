# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require_relative 'version'

# Letters
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2024 Yegor Bugayenko
# License:: MIT
class JekyllShorts::Letters
  def initialize
    @mnemos = {}
  end

  # Next one for this mnemo.
  def next(mnemo)
    @mnemos[mnemo] = 0 if @mnemos[mnemo].nil?
    raise 'Too many letters' if @mnemos[mnemo] >= 26
    letter = @mnemos[mnemo].zero? ? '' : (@mnemos[mnemo] + 'a'.ord - 1).chr
    @mnemos[mnemo] += 1
    letter
  end
end
