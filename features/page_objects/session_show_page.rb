class SessionShowPage < BasePage
  
  def back_to_speakers
    click_link('Back to speakers')
  end
  
  def info
    { title: find(:css, '.box h3').text,
      abstract: find(:css, '.box .abstract').text }
  end
  
end