require 'json'
require 'fileutils'
require 'tempfile'

class IrofferEvent
  def on_packlist
    regenlist()
  end
end

packlist_skeleton = {
  :packs => [],
  :slots => {},
  :mainqueue => {},
  :idlequeue => {},
  :bandwidth => {},
  :transfer => {
      :day => {},
      :week => {},
      :month => {}
    },
  :servers => [],
  :uptime => {}
}

bot = IrofferEvent.new

def regenlist()
  itt = Thread.new {
    while true {
      packlist = {}
      statefile = File.open(bot.irconfig('statefile'),'rb') { |file| file.read }
      regenlist(packlist,statefile)
      sleep(60*60)
    }
  }
end

def writelist(packlist)
  str = JSON.generate(packlist)
  jsonfile = File.expand_path(cachefile)
  temp = Tempfile.new(jsonfile)
  temp.puts(str)
  FileUtils.mv(tf.path, jsonfile)
  temp.close
  temp.unlink
end

def fileinfo(packlist)
  packinfo = { :name => "file", :group => "group", :gets => "gets", :size => "bytes", :desc => "desc", :crc32 => "crc32", :md5 => "md5sum", :date => "xtime" }
  pack = 1
  packlist[:packs] = []
  while true
    break if bot.info_pack(pack,"file").nil?
    packhash = {}
    packinfo.each {|k,v| packhash[k] = bot.info_pack(pack,v)}
    packlist[:packs][pack-1] = packhash
    pack += 1
  end
end

def confinfo(packlist)
  confhash = {:slots => "slotsmax", :mainqueue => "queuesize", :idlequeue => "idlequeuesize", :bandwidth => "overallmaxspeed"}
  confhash.each {|k,v|
    packlist[k] = {} if packlist[k].nil?
    packlist[k][:max] = bot.irconfig(v)
  }
  packlist[:version] = bot.irconfig('version')
  packlist[:servers] = []
  packlist[:nick] = bot.mynick
end


def parse_long(str) # 4 byte long
  theint = 0
  (0..2).each {|i| theint += str[i].ord; theint *= 256 }
  return theint + str[3].ord
end

def parse_double(str) # 8 byte long
  theint = parse_long(str[0,4])*4294967296.0 # 256**4
  return theint + parse_long(str[4,4])
end

def parse_state(statefile,packlist)
  i = 8
  while i < (statefile.length-16) do
    head = parse_long(statefile[i,4]); i+=4
    len = parse_long (statefile[i,4])-8; i+=4
    break if len <= 0
    case head
      when 257 # timestamp on statefile
        packlist[:updated] = parse_long(statefile[i,len])
      when 514 # total sent data (bytes)
        val = parse_double(statefile[i,len])
      when 515 # total uptime (s)
        val = parse_long(statefile[i,len])
      when 3328 # total transferred today
        packlist[:transfer][:day][:use] = parse_double(statefile[i,len])
      when 3330 # total transferred this week
        packlist[:transfer][:week][:use] = parse_double(statefile[i,len])
      when 3332 # total transferred this month
        packlist[:transfer][:month][:use] = parse_double(statefile[i,len])
    end
    i += len + len%4
  end
end

# {
#   packs: [
#     {
#       name:,
#       number:,
#       size:,
#       gets:,
#       date:,
#       group:,
#       groupdesc:,
#       md5:,
#       crc32:,
#       desc:
#     }
#   ],
#   updated:,
#   slots: {
#     per:,
#     free:,
#     use:,
#     max:
#   },
#   mainqueue: {
#     free:,
#     use:,
#     max:
#   },
#   idlequeue: {
#     free:,
#     use:,
#     max:
#   },
#   bandwidth: {
#     use:,
#     max:
#   },
#   packs:,
#   transfer: {
#     day: {use:, max:},
#     week: {use:, max:},
#     month: {use:, max:},
#     total:
#   },
#   nick:,
#   servers: [
#       {servername: [channels]}
#   ],
#   uptime: {
#     current:,
#     total:
#   },
# }
