# Jekyll-Timeago

[![Gem Version](https://badge.fury.io/rb/jekyll-timeago.svg)](http://badge.fury.io/rb/jekyll-timeago)
[![Build Status](https://travis-ci.org/markets/jekyll-timeago.svg?branch=master)](https://travis-ci.org/markets/jekyll-timeago)
[![Maintainability](https://api.codeclimate.com/v1/badges/a8be458ba0532c2d057d/maintainability)](https://codeclimate.com/github/markets/jekyll-timeago/maintainability)

> A Ruby library to compute distance of dates in words, with localization support. Originally built for Jekyll.

Main features:

- Compute distance of dates, in words, ie: `1 week and 2 days ago`, `5 months ago`, `in 1 year`
- Future times
- Out of the box support for `Jekyll` projects, available as a Liquid Filter and as a Liquid Tag
- Localization
- Level of detail customization
- Command line utility
- Approximate distance, with customizable threshold, ie: `366 days` becomes `1 year ago` instead of `1 year and 1 day ago`

In fact, `jekyll-timeago` started as an extension for the [Liquid](https://github.com/Shopify/liquid) template engine, to be used in Jekyll and Octopress backed sites. But actually, you can use it easily on any Ruby project and even as a tool from the [terminal](#cli)!

Read more about the `Jekyll` integration [in this section](#jekyll-integration).

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

The gem provides the `timeago` method:

```ruby
Jekyll::Timeago.timeago(from, to = Date.today, options = {})
```

You can include the method in the current context by including the module (so you can call directly the `timeago` method without using the whole scope):

```ruby
include Jekyll::Timeago
```

Examples:

```ruby
>> timeago(Date.today)
=> "today"
>> timeago(Date.today.prev_day)
=> "yesterday"
>> timeago(Date.today.prev_day(10))
=> "1 week and 3 days ago"
>> timeago(Date.today.prev_day(100))
=> "3 months and 1 week ago"
>> timeago(Date.today.prev_day(500))
=> "1 year and 4 months ago"
>> timeago('2010-1-1', '2012-1-1')
=> "2 years ago"
>> timeago(Date.today.next_day)
=> "tomorrow"
>> timeago(Date.today.next_day(7))
=> "in 1 week"
>> timeago(Date.today.next_day(1000))
=> "in 2 years and 8 months"
```

**NOTE** If you have the gem installed in your system globally, and you're not using Bundler (probably because you're are writing a basic script), don't forget to require the library first:

```ruby
require 'jekyll-timeago'
include Jekyll::Timeago

puts timeago('2030-1-1')
```

### Options

* `locale`

To use a different language:

```ruby
>> timeago(Date.today.prev_day(200), locale: :es)
=> "hace 6 meses y 2 semanas"
>> timeago(Date.today.prev_day(200), locale: :fr)
=> "il y a environ 6 mois et 2 semaines"
```

Read more about the localization options [here](#localization).

* `depth`

You are able to change the level of detail (from 1 up to 4, 2 by default) to get higher or lower granularity:

```ruby
>> timeago(Date.today.prev_day(2000), depth: 3)
=> "5 years, 5 months and 3 weeks ago"
>> timeago(Date.today.prev_day(2000), depth: 4)
=> "5 years, 5 months, 3 weeks and 4 days ago"
```

- `threshold`

The next component in the time must at least match this threshold to be picked. Set to 0 by default, so you don't get any approximations. Can be used to drop "straggling" values which are too low to be of any use (`in 7 months and 2 days` is as good as saying `in 7 months`).

```ruby
>> timeago(Date.today.prev_day(366), depth: 2, threshold: 0.05)
=> "1 year ago"
```

## Localization

By default, `jekyll-timego` already provides translations for some languages. You can check the list [here](lib/locales/). However, you are able to provide your own translations, or even override the originals, easily.

This project uses the [mini_i18n](https://github.com/markets/mini_i18n) gem under the hood to deal with translations. You can read further about all options in [its docs](https://github.com/markets/mini_i18n#usage). Example:

```ruby
MiniI18n.configure do |config|
  config.load_translations('/path_to_your_translations_files/*.yml')
  config.default_locale = :es
end
```

If you want to contribute and support more default languages, please feel free to send a pull request.

## CLI

You can also use `jekyll-timeago` from the command line:

```
> jekyll-timeago --help
> jekyll-timeago 2016-1-1
2 years and 6 months ago
> jekyll-timeago 2016-1-1 --locale fr
il y a environ 2 années et 6 mois
```

### Console

Starts a custom IRB session with the `timeago` method included:

```
> jekyll-timeago --console
>> timeago(Date.today)
=> "today"
```

## Jekyll integration

You have different options to install and use `jekyll-timeago` into your Jekyll project:

- **Via Jekyll plugin system**

Install the `gem` to your system:

```
> gem install jekyll-timeago
```

In your `_config.yml` file, add a new array with the key gems and the values of the gem names of the plugins you’d like to use. In this case:

```yaml
plugins:
  - jekyll-timeago
```

- **Via Bundler**

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
<p>{{ page.date | timeago: '2020-1-1' }}</p>
```

**Liquid Tag**:

```html
<p>{% timeago 2000-1-1 %}</p>
<p>{% timeago 2000-1-1 2010-1-1 %}</p>
```

### Configuration

In your `_config.yml` file, you can customize the following options:

```yaml
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
> bundle exec rake
```

## License

Copyright (c) Marc Anguera. Jekyll-Timeago is released under the [MIT](LICENSE) License.
