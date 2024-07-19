# == Schema Information
#
# Table name: articles
#
#  id         :bigint           not null, primary key
#  body       :text
#  title      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_articles_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require "rails_helper"

RSpec.describe Article, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  context "タイトルが設定されていないとき" do
    article = Article.new(body: "こんにちは")

    it "記事を作成できない" do
      expect(article.save).to be_falsey
    end
  end
  context "タイトルが100文字を超えるとき" do
    article = Article.new(title: "タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。タイトルが入ります。
" body: "こんにちは")

    it "記事を作成できない" do
      expect(article.save).to be_falsey
    end
  end
end
