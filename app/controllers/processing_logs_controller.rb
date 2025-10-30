class ProcessingLogsController < ApplicationController
  def index
    @processing_logs = ProcessingLog.order(processed_at: :desc)
  end
end
