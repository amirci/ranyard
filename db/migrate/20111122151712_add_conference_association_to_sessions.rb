class AddConferenceAssociationToSessions < ActiveRecord::Migration
  def change
    add_column(:sessions, :conference_id, :integer)
  end
end
