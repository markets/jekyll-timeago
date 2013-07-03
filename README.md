Jekyll-Timeago
==============
Custom and simple implementation of `timeago` date filter. Futures supported.

In fact, `jekyll-timeago` is an extension of [Liquid](https://github.com/Shopify/liquid) filters, so you can use it in all your Liquid templates.

## Installation
Add this gem to your Gemfile and run bundle:
```
gem 'jekyll-timeago'
```
To enable the extension add the following statement to a file in your plugin directory (_plugins/ext.rb):
```
require 'jekyll/timeago'
```
You can copy this [file](https://github.com/markets/jekyll-timeago/blob/master/lib/jekyll/timeago.rb) directly in your plugin directory (_plugins/) as well :)

## Usage
```
<span>{{ page.date | timeago }}</span>
<h2>{{ page.title }}</h2>

<div class="post">
  {{ content }}
</div>
```

## Output samples
```
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