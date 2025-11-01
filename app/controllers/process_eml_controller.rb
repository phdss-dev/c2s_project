class ProcessEmlController < ApplicationController
  def new
  end

  def create
    @eml_file = EmlFile.new
    @eml_file.file.attach(params[:eml_file])

    if @eml_file.save
      flash[:notice] = "Arquivo recebido. O processamento será iniciado em segundo plano."
      render :new, status: :ok
    else
      flash[:alert] = @eml_file.errors.full_messages.join(", ")
      render :new, status: :unprocessable_content
    end
  end
end
