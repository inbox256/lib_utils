# Make it easy for the lazy to log while providing context
#
def log(msg=nil, level='debug')
  c = caller_locations(1,1)[0]
  File.basename(c.path)
  Rails.logger.__send__ level, "#{File.basename(c.path)}->#{c.label}: #{msg}"
end

# Get the TZInfo::Timezone based on the zone identifier
#
def get_timezone(zone_identifier)
  TZInfo::Timezone.get(zone_identifier)
end

def utc_to_local(utctime, zone_identifier)
  tz = get_timezone(zone_identifier)
  tz.utc_to_local(utctime)
end

# Turn a date, which is in utc, to the time in specified zone
#
def utc_to_local_zone(utc_time, zone_identifier)
  lt = utc_to_local(utc_time, zone_identifier)
  ActiveSupport::TimeZone[zone_identifier].parse(lt.asctime)
end