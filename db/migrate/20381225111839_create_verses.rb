class CreateVerses < ActiveRecord::Migration[7.0]
  def change
    create_table :verses do |t|
      t.references :book, null: false, foreign_key: true
      t.references :chapter, null: false, foreign_key: true
      t.integer :verse, null: false
      t.text :info_html, null: false
      t.text :info_text, null: false

      t.timestamps
    end
    add_index :verses, :verse
  end
end
