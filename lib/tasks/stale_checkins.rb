require_relative '../volunteer_portal/stale_checkin_processor'

def stale_checkin_limit
  3600 * (ENV['STALE_CHECKIN_LIMIT'] || 3)
end

task :stale_checkins do
  puts 'Processing stale checkins'
  p = VolunteerPortal::StaleCheckinProcessor.new(stale_checkin_limit)
  p.process_stale_checkins
end
