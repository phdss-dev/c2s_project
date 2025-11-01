require "rails_helper"

RSpec.describe ProcessEmlController, type: :request do
  describe "POST /process_eml" do
    let(:valid_eml) { file_fixture("emails/partner_b/valid.eml") }
    let(:empty_eml) { file_fixture("emails/empty_file.eml") }
    let(:invalid_txt) { file_fixture("txt/invalid.txt") }

    def upload(file_path, content_type = "message/rfc822")
      file = Rack::Test::UploadedFile.new(file_path, content_type)
      post "/process_eml", params: {eml_file: file}
    end

    context "com arquivo .eml válido" do
      it "exibe mensagem de sucesso" do
        upload(valid_eml)

        expect(response).to have_http_status(:ok)
        expect(flash[:notice]).to eq("Arquivo recebido. O processamento será iniciado em segundo plano.")
      end
    end

    context "with empty file" do
      it "shows validation error" do
        upload(empty_eml)

        expect(response).to have_http_status(:unprocessable_content)
        expect(flash[:alert]).to include("cannot be empty")
      end
    end

    context "with invalid file type" do
      it "shows validation error" do
        upload(invalid_txt, "text/plain")

        expect(response).to have_http_status(:unprocessable_content)
        expect(flash[:alert]).to include("must be a .eml file")
      end
    end

    context "with no file sent" do
      it "exibe erro de presença" do
        post "/process_eml", params: {}

        expect(response).to have_http_status(:unprocessable_content)
        expect(flash[:alert]).to include("File can't be blank")
      end
    end
  end
end
