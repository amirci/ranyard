# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'csv'

[Assignment, Session, Speaker].each { |klass| klass.delete_all }

speakers_csv = File.dirname(__FILE__) + '/rawdata/prdc_speakers.csv'
sessions_csv = File.dirname(__FILE__) + '/rawdata/prdc_sessions.csv'

speaker_rows = CSV.read(speakers_csv, {:headers=>:first_row})

def parse_text(input)
	input.gsub!(/(\<br \/>)+/i, '')
	input.gsub!(/(<\/?p>)/, '')
	input = input.force_encoding('UTF-8')
	"#{input}"
end

def parse_title(input)
	#input.gsub!(/<b>.*?<\/b>/,'')
	"#{input}"
end

def parse_tracks(input)
  input.gsub!(/\<b>Track:\<\/b>\s*/i, '')
  input.split(',')
end

speaker_rows.each do |row|
	sp = Speaker.find_or_create_by_id(row[0])
	sp.name = "#{row[1]} #{row[2]}"
	sp.bio = parse_text(row[3])
	sp.email = row[4] == "NULL" ? nil : row[4]
	sp.blog = row[5] == "NULL" ? nil : row[5]
	sp.website = row[6] == "NULL" ? nil : row[6]
	sp.twitter = row[7] == "NULL" ? nil : row[7]
	sp.picture = row[8] == "NULL" ? nil : row[8]
	sp.save!
end

session_rows = CSV.read(sessions_csv, {:headers=>:first_row})

session_rows.each do |row|
	ss = Session.find_or_create_by_id(row[0])
	ss.title = parse_title(row[1])
	ss.abstract = parse_text(row[2])
	speaker = Speaker.find_by_name(row[5])
	ss.speakers << speaker unless speaker.nil?

  session_style = row[3] 
  session_tracks = parse_tracks(row[4])
  # use the session tracks as individual tags
  # with the session_style as the first tag
  session_tags = session_tracks.unshift(session_style) 

  ss.tag_list = session_tags.delete_if { |t| t.downcase == 'lecture' }
	ss.save!
end
