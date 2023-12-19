# app/controllers/documents_controller.rb
class DocumentsController < ApplicationController
  before_action :set_active_storage_url_options, only: [:index]
  before_action :authenticate_user!, only: [:index, :new, :create]


  def index
    redirect_to action: :all_documents
  end


  def all_documents
    @documents = Document.all
    set_active_storage_url_options
  end

  def new
    @document = current_user.documents.build
  end

  def create
    @document = current_user.documents.build(document_params)

    if @document.save
      redirect_to documents_path, notice: 'Document was successfully uploaded.'
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
