class DailyDigestWorker
  include Sidekiq::Worker
  inclide Sidetiq::Schedulable

  recurrense { daily(1) }

  def perform
    User.send_daily_digest
  end
end
