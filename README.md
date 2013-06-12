Jekyll-Timeago
==============
Custom and simple implementation of `timeago` date filter.

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

## License
Copyright (c) 2013 Marc Anguera. Unscoped Associations is released under the [MIT](http://opensource.org/licenses/MIT) License.