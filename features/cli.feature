Feature: Simple site building
  I want to be able to build a site

  Scenario: Simple site
    Given I have a "_config.yml" file with content:
    """
    markdown: kramdown
    plugins:
      - jekyll-shorts
    shorts:
      permalink: :y:m:d.html
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
