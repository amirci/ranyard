module ConferencesHelper

  def format_days(conf = @conference)
    return "" unless conf.start && conf.finish
    head = conf.days[0..-2].map { |d| d.day }.join(', ')
    month = conf.days.first.strftime("%B")
    year = conf.days.first.year
    "#{month} #{head} & #{conf.days.last.day}, #{year}"
  end
  
  def format_start(date) 
    date.strftime('%b %e, %Y') if date
  end

  def format_finish(date)
    format_start(date)
  end
  
  def format_active(active)
    active ? "active" : ""
  end
end
