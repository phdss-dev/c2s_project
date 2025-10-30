class ProcessEmlController < ApplicationController
  def new
  end

  def create
    @eml_file = EmlFile.new
    @eml_file.file.attach(params[:eml_file])

    if @eml_file.save
      flash.now[:notice] = "Arquivo recebido. O processamento será iniciado em segundo plano."
    else
      flash.now[:alert] = @eml_file.errors.full_messages
    end

    render :new
  end
end
