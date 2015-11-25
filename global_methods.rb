# Make it easy for the lazy to log while providing context
#
def log(msg=nil, level='debug')
  c = caller_locations(1,1)[0]
  File.basename(c.path)
  Rails.logger.__send__ level, "#{File.basename(c.path)}->#{c.label}: #{msg}"
end