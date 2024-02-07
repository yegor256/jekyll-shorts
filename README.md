[![rake](https://github.com/yegor256/jekyll-shorts/actions/workflows/rake.yml/badge.svg)](https://github.com/yegor256/jekyll-shorts/actions/workflows/rake.yml)
[![Gem Version](https://badge.fury.io/rb/jekyll-shorts.svg)](http://badge.fury.io/rb/jekyll-shorts)

If you have a [Jekyll](https://jekyllrb.com/) static site, this plugin may help you automatically
generate short links for every page. I'm using this plugin for 
[my blog](https://github.com/yegor256/blog).

Install it first (you need [Ruby 3+](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/) 
and [Jekyll 3+](https://jekyllrb.com/)):

```
$ gem install jekyll-shorts
```

Then, add this to `_config.yml`:

```yaml
plugins:
  - ... your other plugins here ...
  - jekyll-shorts
shorts:
  permalink: :year:month:day.html
```

Here, every page in the site will get a sibling with the name 
`:year:month:day.html`, which will redirect to the page itself. You can use:

  * `:year` - the short form of the year of the post, like `23` or `76`
  * `:month` - the month of the post, like `01` or `12`
  * `:day` - the day of the post, like `07` or `29`
  * `:position` - the unique position of the post in the entire list of them, like `42` or `256`
  * `:letter` - one English letter inside a month (empty instead of `a`)

Be careful with the `:position`, since it may change when you add a new post
somewhere in the middle of existing flow of posts.

## How to Contribute

Make a fork and then test it locally like this:

```bash
$ bundle update
$ bundle exec rake
```

If it works, make changes, test again, and then submit a pull request.
