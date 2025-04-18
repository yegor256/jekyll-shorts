# SPDX-FileCopyrightText: Copyright (c) 2024 Yegor Bugayenko
# SPDX-License-Identifier: MIT
Feature: Gem Package
  As a source code writer I want to be able to
  package the Gem into .gem file

  Scenario: Gem can be packaged
    When It is Unix
    Given I have a "execs.rb" file with content:
    """
    #!/usr/bin/env ruby
    require 'rubygems'
    spec = Gem::Specification::load('./spec.rb')
    """
    And I copy this gem into temp dir
    When I run bash with:
    """
    set -x
    set -e
    cd jekyll-shorts
    gem build jekyll-shorts.gemspec
    gem specification --ruby jekyll-shorts-*.gem > ../spec.rb
    cd ..
    ruby execs.rb
    """
    Then Exit code is zero
