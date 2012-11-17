class CreateEvents < ActiveRecord::Migration
  def self.up
         create_table :events, :primary_key => :id do |t|
                t.integer :id
				t.string :title
				t.string :presenter
				t.string :location
				t.string :date
				t.
				t.string :desc
         end
  end

  def self.down
        drop_table :events
  end

end
