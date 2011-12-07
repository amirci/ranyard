class AddSubdomainToConference < ActiveRecord::Migration
  def change
    change_table "conferences" do |t|
      t.string "subdomain"
      t.string "dates"
      t.string "venue"
      t.string "city"
    end
  end
end
