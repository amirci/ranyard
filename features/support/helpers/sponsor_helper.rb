module SponsorHelper

  def conference_sponsors_json
    exceptions = ['conference_id']
    { sponsors: active_conference.sponsors.map { |s| s.attributes } }.to_json(except: exceptions)
  end
  
end

World(SponsorHelper)