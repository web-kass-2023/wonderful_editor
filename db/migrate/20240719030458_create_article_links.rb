class CreateArticleLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :article_links do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: false, foreign_key: true

      t.timestamps
    end
  end
end
