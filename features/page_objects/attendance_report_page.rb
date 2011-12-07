class AttendanceReportPage < BasePage
  
  def list
    all(:css, '.session').map do |tr|
      {
        title: tr.find(:css, '.title').text,
        speakers: tr.find(:css, '.speakers').text,
        attending: tr.find(:css, '.attending').text.to_i
      }
    end
  end
  
end