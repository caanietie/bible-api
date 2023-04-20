class CreateWordlists < ActiveRecord::Migration[7.0]
  def change
    create_table :wordlists do |t|
      t.string :word

      t.timestamps
    end
    add_index :wordlists, :word
  end
end
