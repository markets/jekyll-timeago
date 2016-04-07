# Jekyll-Timeago

[![Gem Version](https://badge.fury.io/rb/jekyll-timeago.svg)](http://badge.fury.io/rb/jekyll-timeago) [![Build Status](https://travis-ci.org/markets/jekyll-timeago.svg?branch=master)](https://travis-ci.org/markets/jekyll-timeago)

> A Ruby library to compute distance of dates in words. Originally built for Jekyll, as a Liquid extension.

Main features:

* Compute distance of dates in words, ie: `1 week and 2 days ago`, `5 months ago`, `in 1 year`
* Future times.
* Out of the box support for `Jekyll` (v1, v2 and v3) projects, available as a Liquid Filter and as a Liquid Tag.
* Localization (i18n).
* Level of detail.
* Available via the command line.

In fact, `jekyll-timeago` started just as an extension for [Liquid](https://github.com/Shopify/liquid) template engine, to be used in Jekyll and Octopress backed sites. But actually, you can use it easily in any Ruby project. Read more about usage outside Jekyll [in this section](#usage-outside-jekyll).

## Installation

You have different options to install and plugging it into Jekyll projects:

**Via Jekyll plugin system (recommended)**

Install the `gem` to your system:

```
gem install jekyll-timeago
```

In your `_config.yml` file, add a new array with the key gems and the values of the gem names of the plugins you’d like to use. In this case:

```
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

**Manually (less recommended)**

Alternatively, you can simply copy the files under [lib/jekyll-timeago](lib/jekyll-timeago/) directly into your `_plugins/` directory. All those files will be loaded by Jekyll.

## Usage

By default, the `timeago` helper computes distance of dates from passed date to current date (using `Date.today`). But you are able to modify this range by passing a second argument. Examples:

**Filter example**:

```html
<p>{{ page.date | timeago }}</p>
```

Passing a parameter:

```html
<p>{{ page.date | timeago: '2020-1-1' }}</p>
```

**Tag example**:

```html
<p>{% timeago 2000-1-1 %}</p>
```

Passing a second parameter:

```html
<p>{% timeago 2000-1-1 2010-1-1 %}</p>
```

## Localization

This plugin allows you to localize the strings needed to build the sentences. To do this, you just need to add some extra keys in your `_config.yml`. You can simply copy them from one of the [provided examples](lib/jekyll-timeago/config/). Or even, translate it to your site's language just overriding it.

English example (default):

```
jekyll_timeago:
  depth: 2 # Level of detail
  today: 'today'
  yesterday: 'yesterday'
  tomorrow: 'tomorrow'
  and: 'and'
  suffix: 'ago'
  prefix: ''
  suffix_future: ''
  prefix_future: 'in'
  years: 'years'
  year: 'year'
  months: 'months'
  month: 'month'
  weeks: 'weeks'
  week: 'week'
  days: 'days'
  day: 'day'
```

**NOTE** You also can play with suffixes and prefixes to modify the sentences. For example, set `suffix: nil` and you'll get only the distance of dates: `1 year, 4 months and 1 week`.

## Level of detail (Depth)

You are able to change the level of detail (from 1 up to 4, 2 by default) to get higher or lower granularity. This option is setted via the `config` file (see sample in previous section). Examples:

* Depht => 1 `1 year ago`
* Depht => 2 `1 year and 4 months ago` (default)
* Depht => 3 `1 year, 4 months and 1 week ago`
* Depht => 4 `1 year, 4 months, 1 week and 4 days ago`

## Usage outside Jekyll

You just need to install the gem to your application (add `gem 'jekyll-timeago'` to your Gemfile). From now on, you can use the provided method by calling:

```ruby
Jekyll::Timeago::Core.timeago(from, to, options)
```

Note, that you can use the `options` parameter to override the detault localization or the level of detail.

## CLI

```
$ jekyll-timeago 2016-1-1
2 months and 6 days ago
```

### Console

Run `$ jekyll-timeago --console` to start a custom IRB session and play with the `timeago` method:

```ruby
>> timeago(Date.today)
=> "today"
>> timeago(Date.today - 1.day)
=> "yesterday"
>> timeago(Date.today - 10.days)
=> "1 week and 3 days ago"
>> timeago(Date.today - 100.days)
=> "3 months and 1 week ago"
>> timeago(Date.today - 500.days)
=> "1 year and 4 months ago"
>> timeago('2010-1-1', '2012-1-1')
=> "2 years ago"
>> timeago(Date.today + 1.days)
=> "tomorrow"
>> timeago(Date.today + 7.days)
=> "in 1 week"
>> timeago(Date.today + 1000.days)
=> "in 2 years and 8 months"
```

Play with `options`:

```ruby
>> configure "yesterday" => "ayer"
=> "ayer"
>> timeago(Date.today - 1.day)
=> "ayer"
```

## Development

Any kind of feedback, bug report, idea or enhancement are really appreciated.

To contribute, just fork the repo, hack on it and send a pull request. Don't forget to add specs for behaviour changes and run the test suite:

```
bundle exec appraisal rake
```

`Appraisal` library is used to ensure compatibility with different Jekyll versions. Check out current supported versions [here](Appraisals).

## License

Copyright (c) 2013-2016 Marc Anguera. Jekyll-Timeago is released under the [MIT](LICENSE) License.
