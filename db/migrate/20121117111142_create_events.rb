class CreateEvents < ActiveRecord::Migration
  def self.up
         create_table :events, :primary_key => :id do |t|
                t.integer :id
				t.string :title
				t.string :presenter
				t.string :where
				t.string :when
				t.string :image_file
				t.string :admin_email
				t.date :archive_date
				t.text :intro
				t.text :desc
         end
  end

  def self.down
        drop_table :events
  end

end
