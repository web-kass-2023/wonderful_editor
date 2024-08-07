require "rails_helper"

RSpec.describe "Api::V1::Auth::Sessions", type: :request do
  describe "POST /api/v1/auth/sign_in" do
    subject { post(api_v1_user_session_path, params: params) }

    context "登録済のユーザー情報を送信したとき" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: user.password) }

      before { subject }

      it "レスポンスのヘッダーに access-token が含まれている" do
        expect(response.header["access-token"]).to be_present
      end

      it "レスポンスのヘッダーに client が含まれている" do
        expect(response.header["client"]).to be_present
      end

      it "レスポンスのヘッダーに uid が含まれている" do
        expect(response.header["uid"]).to be_present
      end

      it "HTTPステータスがOKである" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "emailが一致しないとき" do
      let(:user) { create(:user) }
      let(:res) { JSON.parse(response.body) }
      let(:header) { response.header }
      let(:params) { attributes_for(:user, email: "hoge", password: user.password) }
      before { subject }

      it "エラーメッセージが含まれている" do
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
      end

      it "レスポンスのヘッダーに access-token が含まれていない" do
        expect(header["access-token"]).to be_blank
      end

      it "レスポンスのヘッダーに client が含まれていない" do
        expect(header["client"]).to be_blank
      end

      it "レスポンスのヘッダーに uid が含まれていない" do
        expect(header["uid"]).to be_blank
      end

      it "HTTPステータスがUnauthorizedである" do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "passwordが一致しない場合" do
      let(:user) { create(:user) }
      let(:params) { attributes_for(:user, email: user.email, password: "hoge") }

      it "ログインが認められない" do
        subject
        res = JSON.parse(response.body)
        header = response.header
        expect(res["errors"]).to include "Invalid login credentials. Please try again."
        expect(header["access-token"]).to be_blank
        expect(header["client"]).to be_blank
        expect(headers["uid"]).to be_blank
        expect(response).to have_http_status(:unauthorized)
      end
    end

    describe "DELETE /api/v1/auth/sign_out" do
      subject { delete(destroy_api_v1_user_session_path, headers: headers) }

      context "ログアウトに必要な情報を送信したとき" do
        let(:user) { create(:user) }
        let!(:headers) { user.create_new_auth_token }

        it "ログアウトできる" do
          expect { subject }.to change { user.reload.tokens }.from(be_present).to(be_blank)
          expect(response).to have_http_status(:ok)
        end
      end

      context "誤った情報を送信したとき" do
        let(:user) { create(:user) }
        let!(:headers) { { "access-token" => "", "token-type" => "", "client" => "", "expiry" => "", "uid" => "" } }

        it "ログアウトできない" do
          subject
          expect(response).to have_http_status(:not_found)
          res = JSON.parse(response.body)
          expect(res["errors"]).to include "User was not found or was not logged in."
        end
      end
    end
  end
end
