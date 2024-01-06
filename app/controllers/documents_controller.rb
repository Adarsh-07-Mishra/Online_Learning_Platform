# frozen_string_literal: true

class DocumentsController < ApplicationController
  before_action :set_active_storage_url_options, only: [:index]
  before_action :authenticate_user!, only: %i[index new create destroy]

  def index
    redirect_to action: :all_documents
  end

  def all_documents
    @documents = Document.all
    set_active_storage_url_options
  end

  def show
    @document = Document.find(params[:id])
    head :no_content
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

  def destroy
    @document = Document.find(params[:id])

    if current_user == @document.user
      @document.destroy
      redirect_to documents_path, notice: 'Document was successfully destroyed.'
    else
      redirect_to documents_path, alert: 'You are not authorized to destroy this document.'
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
