class UpdateCollation < ActiveRecord::Migration[7.0]
  def up
    change_column :decks, :name, :text, collation: "NOCASE"
    change_column :notetypes, :name, :text, collation: "NOCASE"
  end
end
