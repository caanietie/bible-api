class API::ApplicationController < ActionController::API
  before_action :set_headers

  private

  def set_headers
    headers["Access-Control-Allow-Origin"] = ?*
    headers["Access-Control-Allow-Methods"] = "Get"
    headers["Access-Control-Max-Age"] = 86400
  end
end
