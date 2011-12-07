class BasePage

  def initialize(session = nil)
    @session = session || Capybara.current_session
  end
  
  def method_missing(sym, *args, &block)
    @session.send sym, *args, &block
  end

  private
    def fill_in_date(field, date)
      @session.select(date.year.to_s, :from => "#{field}_1i")
      @session.select(date.strftime('%B'), :from => "#{field}_2i")
      @session.select(date.day.to_s, :from => "#{field}_3i")
    end

    def set_check(check, value)
      value ? check('Active') : uncheck('Active')
    end
    
    def find_date(field)
      selected = ->(n) { "//*[@id='#{field}_#{n}i']/option[@selected='selected']" }
      year = find(:xpath, selected.call(1)).text
      month = find(:xpath, selected.call(2)).text
      date = find(:xpath, selected.call(3)).text
      Date.parse("#{month} #{date}, #{year}")
    end
end