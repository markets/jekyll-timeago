# Jekyll-Timeago
[![Gitter](https://badges.gitter.im/Join Chat.svg)](https://gitter.im/markets/jekyll-timeago?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

[![Gem Version](https://badge.fury.io/rb/jekyll-timeago.svg)](http://badge.fury.io/rb/jekyll-timeago) [![Build Status](https://travis-ci.org/markets/jekyll-timeago.svg?branch=master)](https://travis-ci.org/markets/jekyll-timeago)

Custom and simple implementation of `timeago` date filter. Main features:

* Distance of dates in words
* Future time
* Usage via Filter or Tag
* Localization
* Level of detail

In fact, `jekyll-timeago` is an extension of [Liquid](https://github.com/Shopify/liquid) Filters and Tags, so you can use it in other Liquid templates (like Octopress).

## Installation

You have 3 options to install the plugin:

**Via Jekyll plugin system**

Install the `gem` to your system:

```
gem install jekyll-timeago
```

In your `_config.yml` file, add a new array with the key gems and the values of the gem names of the plugins you’d like to use. In this case:

```
gems: [jekyll-timeago]
```

**Via Bundler**

Add this gem to your `Gemfile` and run `bundle`:

```
gem 'jekyll-timeago'
```

Then load the plugin adding the following into some file under `_plugins/` folder:

```ruby
# _plugins/ext.rb
require 'rubygems'
require 'bundler/setup'
Bundler.require(:default)
```

**Manually**

Alternatively, you can simply copy [this file](lib/jekyll-timeago/filter.rb) and [this file](lib/jekyll-timeago/tag.rb) directly into your `_plugins/` directory!

## Usage

By default `timeago` computes distance of dates from passed date to current date (using `Date.today`). But you are able to modify this range passing a second argument in order to compute the distance of these dates in words.

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

The plugin allows you to localize the strings needed to build the time ago sentences. For do this, you must add some extra keys to your `_config.yml`. You can simply copy them from [this example file](_config.yml.example) and translate it to your site's language. Sample:

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

**NOTE** You also can use suffixes and prefixes to modify the sentences. For example, set `suffix: nil` and you'll get only the distance of dates: `1 year, 4 months and 1 week`.

## Level of detail (Depth)

You are able to change the level of detail (from 1 up to 4, 2 by default) to get higher or lower granularity. This option is setted via the `config` file (see sample in previous section). Examples:

* Depht => 1 `1 year ago`
* Depht => 2 `1 year and 4 months ago` (default)
* Depht => 3 `1 year, 4 months and 1 week ago`
* Depht => 4 `1 year, 4 months, 1 week and 4 days ago`

## Output Examples

Run `script/console` to start a custom IRB session and play with `timeago` method:

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
>> options[:yesterday] = "ayer"
=> "ayer"
>> timeago(Date.today - 1.day)
=> "ayer"
```

## License

Copyright (c) 2013-2014 Marc Anguera. Jekyll-Timeago is released under the [MIT](LICENSE) License.
