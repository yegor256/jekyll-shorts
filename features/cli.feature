# SPDX-FileCopyrightText: Copyright (c) 2024 Yegor Bugayenko
# SPDX-License-Identifier: MIT
Feature: Simple site building
  I want to be able to build a site

  Scenario: Simple site
    Given I have a "_config.yml" file with content:
    """
    markdown: kramdown
    plugins:
      - jekyll-shorts
    shorts:
      permalink: :year:month:day.html
    """
    And I have a "_layouts/default.html" file with content:
    """
    {{ content }}
    """
    And I have a "_posts/2023-07-29-hello.md" file with content:
    """
    ---
    title: Hello, world!
    layout: default
    ---
    Hello, world!
    """
    Then I build Jekyll site
    And Exit code is zero
    And File "_site/230729.html" exists
    And I build Jekyll site
    And Exit code is zero

  Scenario: Simple site
    Given I have a "_config.yml" file with content:
    """
    markdown: kramdown
    plugins:
      - jekyll-shorts
    shorts:
      permalink: :year.html
    """
    And I have a "_layouts/default.html" file with content:
    """
    {{ content }}
    """
    And I have a "_posts/2023-01-01-hello.md" file with content:
    """
    ---
    title: Hello, world!
    layout: default
    ---
    Hello, world!
    """
    Then I build Jekyll site
    And Exit code is zero
    And File "_site/23.html" exists
    And I have a "_posts/2023-02-02-hello.md" file with content:
    """
    ---
    title: Hello, world!
    layout: default
    ---
    Hello, world!
    """
    And I build Jekyll site
    And Exit code is not zero

  Scenario: Simple site
    Given I have a "_config.yml" file with content:
    """
    markdown: kramdown
    plugins:
      - jekyll-shorts
    shorts:
      permalink: :year:month:letter.html
    """
    And I have a "_layouts/default.html" file with content:
    """
    {{ content }}
    """
    And I have a "_posts/2023-01-01-apple.md" file with content:
    """
    ---
    title: Hello, world!
    layout: default
    ---
    Hello, world!
    """
    Then I build Jekyll site
    And Exit code is zero
    And I have a "_posts/2023-01-02-apple.md" file with content:
    """
    ---
    title: Hello, world!
    layout: default
    ---
    Hello, world!
    """
    And I build Jekyll site
    And Exit code is zero
    And File "_site/2301.html" exists
    And File "_site/2301a.html" exists
