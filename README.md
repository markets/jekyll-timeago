# Jekyll-Timeago

[![Gem Version](https://badge.fury.io/rb/jekyll-timeago.svg)](http://badge.fury.io/rb/jekyll-timeago)
[![Build Status](https://travis-ci.org/markets/jekyll-timeago.svg?branch=master)](https://travis-ci.org/markets/jekyll-timeago)
[![Maintainability](https://api.codeclimate.com/v1/badges/a8be458ba0532c2d057d/maintainability)](https://codeclimate.com/github/markets/jekyll-timeago/maintainability)

> A Ruby library to compute distance of dates in words, with localization support. Originally built for Jekyll.

Main features:

* Compute distance of dates, in words, ie: `1 week and 2 days ago`, `5 months ago`, `in 1 year`
* Future times
* Out of the box support for `Jekyll` (`v1`, `v2` and `v3`) projects, available as a Liquid Filter and as a Liquid Tag
* Localization (i18n)
* Level of detail
* Command line utility

In fact, `jekyll-timeago` started as an extension for [Liquid](https://github.com/Shopify/liquid) template engine, to be used in Jekyll and Octopress backed sites. But actually, you can use it easily on any Ruby project.

Read more about the Jekyll integration [in this section](#jekyll-integration).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-timeago'
```

And then execute:

    > bundle install

Or install it yourself as:

    > gem install jekyll-timeago

## Usage

The gem provides the `#timeago` method:

```ruby
Jekyll::Timeago.timeago(from, to = Date.today, options = {})
```

Examples:

```ruby
>> Jekyll::Timeago.timeago(Date.today)
=> "today"
>> Jekyll::Timeago.timeago(Date.today.prev_day)
=> "yesterday"
>> Jekyll::Timeago.timeago(Date.today.prev_day(10))
=> "1 week and 3 days ago"
>> Jekyll::Timeago.timeago(Date.today.prev_day(100))
=> "3 months and 1 week ago"
>> Jekyll::Timeago.timeago(Date.today.prev_day(500))
=> "1 year and 4 months ago"
>> Jekyll::Timeago.timeago('2010-1-1', '2012-1-1')
=> "2 years ago"
>> Jekyll::Timeago.timeago(Date.today.next_day)
=> "tomorrow"
>> Jekyll::Timeago.timeago(Date.today.next_day(7))
=> "in 1 week"
>> Jekyll::Timeago.timeago(Date.today.next_day(1000))
=> "in 2 years and 8 months"
```

**NOTE** If you have the gem installed in your system, and you're not using Bundler (probably because you're are writing a basic script), don't forget to require the library first:

```ruby
require 'jekyll-timeago'

puts Jekyll::Timeago.timeago('2030-1-1')
```

### Options

* `locale`

Use a different language:

```ruby
>> Jekyll::Timeago.timeago(Date.today.prev_day(200), locale: :es)
=> "hace 6 meses y 2 semanas"
>> Jekyll::Timeago.timeago(Date.today.prev_day(200), locale: :fr)
=> "il y a environ 6 mois et 2 semaines"
```

Read more about the localization options [here](i18n).

* `depth`

You are able to change the level of detail (from 1 up to 4, 2 by default) to get higher or lower granularity:

```ruby
>> Jekyll::Timeago.timeago(Date.today.prev_day(2000), depth: 3)
=> "5 years, 5 months and 3 weeks ago"
>> Jekyll::Timeago.timeago(Date.today.prev_day(2000), depth: 4)
=> "5 years, 5 months, 3 weeks and 4 days ago"
```

## I18n

By default, `jekyll-timego` already provides translations for some languages. You can check the list [here](lib/locales/). However, you are able to provide your own translations, or even override the originals, easily.

This project uses the [mini_i18n](https://github.com/markets/mini_i18n) gem under the hood to deal with translations. You can read further about all options in [its docs](https://github.com/markets/mini_i18n#usage). Example:

```ruby
MiniI18n.configure do |config|
  config.load_translations('/path_to_your_translations_files/*.yml')
  config.default_locale = :en
end
```

If you want to contribute and support more languages by default, please feel free to send a pull request.

## CLI

```
> jekyll-timeago 2016-1-1
2 years and 6 months ago
> jekyll-timeago 2016-1-1 --locale fr
il y a environ 2 années et 6 mois
```

### Console

Starts a custom IRB session with the `#timeago` method included:

```
> jekyll-timeago --console
>> timeago(Date.today)
=> "today"
```

## Jekyll integration

You have different options to install and use `jekyll-timeago` into your Jekyll project:

**Via Jekyll plugin system (recommended)**

Install the `gem` to your system:

```
> gem install jekyll-timeago
```

In your `_config.yml` file, add a new array with the key gems and the values of the gem names of the plugins you’d like to use. In this case:

```yaml
gems:
  - jekyll-timeago
```

**Via Bundler**

Add this gem to your `Gemfile` and run `bundle install`:

```ruby
group :jekyll_plugins do
  gem 'jekyll-timeago'
end
```

### Usage

**Liquid Filter**:

```html
<p>{{ page.date | timeago }}</p>
```

Passing a parameter:

```html
<p>{{ page.date | timeago: '2020-1-1' }}</p>
```

**Liquid Tag**:

```html
<p>{% timeago 2000-1-1 %}</p>
```

Passing a second parameter:

```html
<p>{% timeago 2000-1-1 2010-1-1 %}</p>
```

### Configuration

In your `_config.yml` file:

```
jekyll_timeago:
  depth: 2
  translations_path: '/path_to_your_translations/*.yaml'
  default_locale: 'en'
  fallbacks: true
  available_locales:
    - 'en'
    - 'es'
    - 'fr'
```

Also, you can set a different language per page using the [Front Matter](https://jekyllrb.com/docs/frontmatter/) functionality:

```yaml
---
locale: 'es'
---
```

## Development

Any kind of feedback, bug report, idea or enhancement are really appreciated.

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add specs for behaviour changes and run the test suite:

```
> bundle exec appraisal rake
```

We use the `Appraisal` gem to ensure compatibility with different Jekyll versions. Check out current supported versions [here](Appraisals).

## License

Copyright (c) Marc Anguera. Jekyll-Timeago is released under the [MIT](LICENSE) License.
