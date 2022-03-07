class CreateSentences < ActiveRecord::Migration[7.0]
  def change
    create_table :sentences do |t|
      t.string :japanese_word
      t.text :japanese_sentence, null: false
      t.text :english_sentence, null: false
      t.bigint :pcloud_file_id, null: false
      t.string :pcloud_download_url
      t.timestamps
    end

    add_index :sentences, :japanese_sentence, unique: true
    add_index :sentences, :pcloud_file_id, unique: true
  end
end
