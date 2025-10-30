# app/jobs/process_eml_job.rb
class ProcessEmlJob
  include Sidekiq::Job

  def perform(eml_file_id)
    eml_file = EmlFile.find(eml_file_id)
    return unless eml_file.present?

    begin
      eml_file.update!(status: :processing)
      EmlProcessor.new(eml_file).process
    rescue ActiveRecord::RecordNotFound
      Rails.logger.warn("EmlFile ##{eml_file_id} não encontrado.")
    rescue => e
      Rails.logger.error("Falha no ProcessEmlJob[#{eml_file_id}]: #{e.message}\n#{e.backtrace.join("\n")}")
    end
  end
end
