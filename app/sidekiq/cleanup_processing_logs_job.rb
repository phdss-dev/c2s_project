class CleanupProcessingLogsJob
  include Sidekiq::Job

  def perform
    ProcessingLog.where("created_at < ?", 5.minutes.ago).delete_all
  end
end
