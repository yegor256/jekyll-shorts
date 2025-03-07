# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2024 Yegor Bugayenko
# SPDX-License-Identifier: MIT

require 'English'

Gem::Specification.new do |s|
  s.required_rubygems_version = Gem::Requirement.new('>= 0') if s.respond_to? :required_rubygems_version=
  s.required_ruby_version = '>= 2.6'
  s.name = 'jekyll-shorts'
  s.version = '0.0.0'
  s.license = 'MIT'
  s.summary = 'Automatically generates short links for Jekyll website'
  s.description = [
    'Add this plugin to your Jekyll site and all posts will automatically',
    'get short links (similar to what URL shorteners may provide)'
  ].join(' ')
  s.authors = ['Yegor Bugayenko']
  s.email = 'yegor256@gmail.com'
  s.homepage = 'https://github.com/yegor256/jekyll-shorts'
  s.files = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  s.executables = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.rdoc_options = ['--charset=UTF-8']
  s.extra_rdoc_files = %w[README.md LICENSE.txt]
  s.add_runtime_dependency 'jekyll', '>= 3'
  s.metadata['rubygems_mfa_required'] = 'true'
end
