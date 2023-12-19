# app/controllers/documents_controller.rb
class DocumentsController < ApplicationController
  before_action :set_active_storage_url_options, only: [:index]

  def index
    @documents = current_user.documents
  end

  def new
    @document = current_user.documents.build
  end

  def create
    @document = current_user.documents.build(document_params)

    if @document.save
      redirect_to root_path, notice: 'Document was successfully uploaded.'
    else
      render :new
    end
  end

  private

  def set_active_storage_url_options
    ActiveStorage::Current.url_options = { host: request.base_url }
  end

  def document_params
    params.require(:document).permit(:file)
  end
end
