class AddConferenceReferenceToSponsor < ActiveRecord::Migration
  def change
    add_column :sponsors, :conference_id, :integer
  end
end
