Jekyll-Timeago
==============
Custom and simple implementation of `timeago` date filter. Futures supported.

In fact, `jekyll-timeago` is an extension of [Liquid](https://github.com/Shopify/liquid) filters, so you can use it in all your Liquid templates.


## Installation
Add this gem to your `Gemfile` and run `bundle`:

```
gem 'jekyll-timeago'
```

To use this filter, just add the following to the top of another plugin (found under `_plugins/`):

```ruby
require 'jekyll/timeago'
```

Alternatively, you can simply copy [this file](https://github.com/markets/jekyll-timeago/blob/master/lib/jekyll/timeago.rb) directly into your `_plugins/` directory! :)


## Usage
```html
<span>{{ page.date | timeago }}</span>
<h2>{{ page.title }}</h2>

<div class="post">
  {{ content }}
</div>
```

## Output Examples
```ruby
> timeago(Date.today)
=> "today"
> timeago(Date.today - 1.day)
=> "yesterday"
> timeago(Date.today - 10.days)
=> "1 week ago"
> timeago(Date.today - 100.days)
=> "3 months ago"
> timeago(Date.today - 400.days)
=> "1 year ago"
> timeago(Date.today + 1.days)
=> "tomorrow"
> timeago(Date.today + 10.days)
=> "in 1 week"
```

## License
Copyright (c) 2013 Marc Anguera. Unscoped Associations is released under the [MIT](http://opensource.org/licenses/MIT) License.
