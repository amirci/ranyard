class AddConferenceReferenceToEvents < ActiveRecord::Migration
  def change
    add_column(:events, :conference_id, :integer)
  end
end
