module DateFilter
  def timeago(input)
    time_ago_to_now(input)
  end

  def time_ago_to_now(date)
    days_passed = (Date.today - Date.parse(date.to_s)).to_i

    case days_passed
    when 0
      'today'
    when 1
      'yesterday'
    when 2 .. 7
      "#{days_passed} days ago"
    when 8 .. 31
      "#{days_passed/7} weeks ago"
    when 32 .. 365
      "#{days_passed/31} months ago"
    else
      "#{days_passed/365} years ago"
    end
  end
end

Liquid::Template.register_filter(DateFilter)