class AssociateConferenceToSpeakers < ActiveRecord::Migration
  def change
    add_column(:speakers, :conference_id, :integer)
  end
end
