Jekyll-Timeago
==============

Custom and simple implementation of `timeago` date filter. Main features:

* Localization
* Future time
* Level of detail

In fact, `jekyll-timeago` is an extension of [Liquid](https://github.com/Shopify/liquid) filters, so you can use it in all your Liquid templates (Octopress as well).


## Installation

You have 3 options for installing the plugin:

**Via Jekyll plugin system**

In your `_config.yml` file, add a new array with the key gems and the values of the gem names of the plugins you’d like to use. In this case:

```
gems: [jekyll/timeago]
```

**Via Bundler**

Add this gem to your `Gemfile` and run `bundle`:

```
gem 'jekyll-timeago'
```

To use this filter, just add the following to the top of another plugin (found under `_plugins/`):

```ruby
require 'jekyll/timeago'
```

**Manually**

Alternatively, you can simply copy [this file](https://github.com/markets/jekyll-timeago/blob/master/lib/jekyll/timeago.rb) directly into your `_plugins/` directory! :)


## Usage

```html
<span>{{ page.date | timeago }}</span>
<h2>{{ page.title }}</h2>

<div class="post">
  {{ content }}
</div>
```

### Customization

You can personalize the level of detail (from 1 up to 4, 2 by default) passing a parameter:

```html
<span>{{ page.date | timeago: 4 }}</span>
```

## Localization

This plugin allows you to localize the strings needed to build the time ago sentences. For do this, you must add some extra keys to your `_config.yml`. You can simply copy them from [this example file](https://github.com/markets/jekyll-timeago/blob/master/_config.yml.example) and translate it to your site's language. Sample:

```
jekyll_timeago:
  today: 'today'
  yesterday: 'yesterday'
  tomorrow: 'tomorrow'
  and: 'and'
  suffix: 'ago'
  prefix: ''
  suffix_future: 'in'
  prefix_future: ''
  years: 'years'
  year: 'year'
  months: 'months'
  month: 'month'
  weeks: 'weeks'
  week: 'week'
  days: 'days'
  day: 'day'
```

## Output Examples

Default behavior:

```ruby
> timeago(Date.today)
=> "today"
> timeago(Date.today - 1.day)
=> "yesterday"
> timeago(Date.today - 10.days)
=> "1 week and 3 days ago"
> timeago(Date.today - 100.days)
=> "3 months and 1 week ago"
> timeago(Date.today - 500.days)
=> "1 year and 4 months ago"
> timeago(Date.today + 1.days)
=> "tomorrow"
> timeago(Date.today + 7.days)
=> "in 1 week"
> timeago(Date.today + 1000.days)
=> "in 2 years and 8 months"
```

Change level of detail to get higher or lower granularity:

```ruby
> timeago(Date.today - 500.days) # default
=> "1 year and 4 months ago"
> timeago(Date.today - 500.days, 3)
=> "1 year, 4 months and 1 week ago"
> timeago(Date.today - 500.days, 4)
=> "1 year, 4 months, 1 week and 4 days ago"
> timeago(Date.today - 500.days, 1)
=> "1 year ago"
```

## License

Copyright (c) 2013 Marc Anguera. Jekyll-Timeago is released under the [MIT](http://opensource.org/licenses/MIT) License.
