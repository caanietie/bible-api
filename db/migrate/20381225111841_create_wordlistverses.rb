class CreateWordlistverses < ActiveRecord::Migration[7.0]
  def change
    create_table :wordlistverses do |t|
      t.references :verse, null: false, foreign_key: true
      t.references :wordlist, null: false, foreign_key: true

      t.timestamps
    end
  end
end
