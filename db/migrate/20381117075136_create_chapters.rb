class CreateChapters < ActiveRecord::Migration[7.0]
  def change
    create_table :chapters do |t|
      t.references :book, null: false, foreign_key: true
      t.integer :chapter, null: false
      t.text :info_html, null: false, unique: true

      t.timestamps
    end
    add_index :chapters, :chapter
  end
end
