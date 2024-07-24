class Api::V1::BaseApiController < ApplicationController
  def index
    articles = Article.all
    render json: articles
  end

  def current_user
    @current_user ||= User.first
  end
end
