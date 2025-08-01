class ArticlesController < ApplicationController
  def index
    if params[:term].present?
      @articles = Article.search(params[:term])
    else
      @articles = Article.all
    end
  end

  def show
    @article = Article.find(params[:id])
  end

  def search
    term = params[:term].to_s.strip.downcase

    if term.length < 3
      return render json: { error: "Minimum 3 characters" }, status: :bad_request
    end

    results = Article.where("LOWER(title) LIKE :term OR LOWER(content) LIKE :term", term: "%#{term}%")
                   .limit(10)
                   .map do |article|
      {
        id: article.id,
        title: article.title,
        content: article.content.truncate(100)
      }
    end

    render json: results
  end
end
