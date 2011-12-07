module SpeakerHelper
  
  def expected_json(speakers)
    JsonHelper.new.as_json(speakers) 
  end

  def speaker_values(speaker)
    JsonHelper.new.values(speaker)
  end
  
  class JsonHelper 
    def values(speaker)
      extra_key = ->(k, v) { (exceptions << 'id').include?(k.to_s) }
      speaker.attributes.symbolize_keys.reject(&extra_key)
    end
    
    def as_json(speakers)
      target = speakers.respond_to?(:count) ? 
                  { speakers: json_attr(speakers.order(:id)) } :
                  { speaker: json_attr([] << speakers).first }
      target.to_json(except: exceptions)
    end
    
    def json_attr(speakers)
      speakers.map { |s| replace_name_with_first_and_last(s.attributes) }
    end

    def replace_name_with_first_and_last(attrib)
      names = attrib.delete('name').split(' ')
      first_name = names.shift
      attrib.merge(first_name: first_name, last_name: names.join(' '))
    end

    def exceptions
      ['conference_id', 'updated_at', 'created_at']
    end
  end

end

World(SpeakerHelper)