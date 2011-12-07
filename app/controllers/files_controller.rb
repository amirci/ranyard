require "mime/types"

class FilesController < ApplicationController

  def download

    file_name = params[:file_name] 
    file_format = params[:file_format]

    file_name ="#{file_name}.#{file_format}"
    file_path = File.join( Rails.root.to_s,'app','assets','documents',file_name)
    mime_type = MIME::Types.type_for(file_name)[0] rescue bad_request

    #render :text => file_path, :status => 404

    File.exists? file_path or not_found
    send_file(file_path, {:filename => file_name, :type => mime_type})

  end

end
