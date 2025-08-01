class SearchesController < ApplicationController
  def create
    term = params[:term].to_s.strip.downcase
    return head :bad_request if term.length < 3

    ip_address = request.remote_ip
    last_search = Search.where(ip_address: ip_address).order(created_at: :desc).first

    if last_search.nil? || last_search.term != term
      Search.create(term: term, ip_address: ip_address)
    end

    head :ok
  end

  def index
    @searches = Search.all
    render json: @searches
  end

  def analytics
    limit = params[:limit].to_i.positive? ? params[:limit].to_i : 20
    ip_filter = params[:ip]
    term_filter = params[:term]

    searches = Search.all
    searches = searches.where(ip_address: ip_filter) if ip_filter.present?
    searches = searches.where('term LIKE ?', "%#{term_filter}%") if term_filter.present?

    analytics = searches
      .group(:term, :ip_address)
      .order('count_all DESC')
      .limit(limit)
      .count

    results = analytics.map { |(term, ip), count| { term:, ip:, count: } }

    render json: results, status: :ok
  end
end
