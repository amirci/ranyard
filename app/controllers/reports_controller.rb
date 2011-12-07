class ReportsController < ApplicationController
  before_filter :authenticate_user!

  def info
    @requests = InfoRequest.all

    render :text => @requests.map {|r| r.email}.join(', ')
  end
end
