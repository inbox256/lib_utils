# Make it easy for the lazy to log while providing context
#
def log(msg=nil, level='debug')
  c = caller_locations(1,1)[0]
  File.basename(c.path)
  Rails.logger.__send__ level, "#{File.basename(c.path)}->#{c.label}: #{msg}"
end

# Check if it is a number
#
def integer?(n)
  n.to_i.to_s.eql?(n)
end

#
# Copy nested hashes of any depth to a single delimited notation hash
# Works for both regular and mongo hashes.
#
def notate_nested_hash(orighash, newhash, parent=nil)
  orighash.each_key do |k|
    dottedkey = (parent.nil?) ? k : "#{parent}=>#{k}"
    if orighash[k].kind_of?(Hash) # instance_of? wouldn't work for mongo
      notate_nested_hash(orighash[k], newhash, dottedkey) # recurse
    else
      newhash[dottedkey] = orighash[k]
    end
  end
end


# In an email, this format will allow both android and iphone to "add to calendar"
#
def calendarable_time_string(time)
  d = time.strftime("%A %B %d, %Y") rescue ''
  t = time.strftime("%l:%M %p") rescue ''
  "#{d} at #{t}"
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