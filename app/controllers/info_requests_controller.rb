class InfoRequestsController < ApplicationController

  # POST /west
  def create
    @info_request = InfoRequest.new(params[:info_request])
    respond_to do |format|
      if @info_request.save!
        format.html { redirect_to '/west', notice: 'We have received your email address and will be in touch.' }
        format.json { render json: @info_request, status: :created }
      else
        format.html { render '/west' }
        format.json { render json: @info_request.errors, status: :unprocessable_entity }
      end
    end
  end

end
