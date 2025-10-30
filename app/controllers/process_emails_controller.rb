class ProcessEmailsController < ApplicationController
  def new
  end

  def index
  end

  def create
    @eml_file = EmlFile.new
    @eml_file.file.attach(params[:eml_file])

    if @eml_file.save
      redirect_to process_emails_path(@eml_file), notice: "Arquivo recebido. O processamento será iniciado em segundo plano."
    else
      render :new, status: :unprocessable_entity
    end
  end
end
