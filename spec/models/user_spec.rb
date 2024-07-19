require "rails_helper"

RSpec.describe User, type: :model do
  context "必要な情報が揃っている場合" do
    let(:user) { build(:user) }

    it "ユーザー登録できる" do
      expect(user).to be_valid
    end
  end

  context "名前が設定されていない場合" do
    user = User.new(email: "foo@example.com")

    it "ユーザー登録できない" do
      expect(user.save).to be_falsey
    end
  end
end
