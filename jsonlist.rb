require 'json'
require 'fileutils'
require 'tempfile'

packlist = {
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

def fileinfo(bot, packlist)
  packinfo = { :name => "name", :group => "group", :gets => "gets", :size => "bytes", :desc => "desc", :crc32 => "crc32", :md5 => "md5sum", :date => "xtime" }
  pack = 1
  packlist[:packs] = []
  while true
    break if bot.info_pack(pack,"file").nil?
    packhash = {}
    packinfo.each {|k,v| packhash[k] = bot.info_pack(pack,v)}
    packlist[:packs][pack-1] = packhash
    pack += 1
  end
  return packlist
end

def confinfo(bot, packlist)
  {:slots => "slotsmax", :mainqueue => "queuesize", :idlequeue => "idlequeuesize", :bandwidth => "bandmax"}.each {|k,v| packlist[k][:max] = bot.irconfig(v)}
  {:slots => "slotsused", :mainqueue => "mainqueueused", :idlequeue => "idlequeueused", :bandwidth => "banduse"}.each {|k,v| packlist[k][:use] = bot.irconfig(v)}
  {:day => "transfereddaily", :week => "transferedweekly", :month => "transferedmonthly", :total => "transferedtotalbytes"}.each {|k,v| packlist[:transfer][k] = bot.irconfig(v)}
  {:current => "uptime", :total => "totaluptime"}.each {|k,v| packlist[:uptime][k] = bot.irconfig(v)}
  packlist[:servers] = []
  packlist[:packsum] = bot.irconfig("packsum")
  packlist[:nick] = bot.mynick
  return packlist
end

puts JSON.generate(confinfo(bot,fileinfo(bot,packlist)))

# {
#   packs: [
#     {
#       name:,
#       number:,
#       size:,
#       gets:,
#       date:,
#       group:,
#       -groupdesc:,
#       md5:,
#       crc32:,
#       desc:
#     }
#   ],
#   updated:,
#   slots: {
#     use:,
#     max:
#   },
#   mainqueue: {
#     use:,
#     max:
#   },
#   idlequeue: {
#     use:,
#     max:
#   },
#   bandwidth: {
#     use:,
#     max:,
#     limit:
#   },
#   packs:,
#   transfer: {
#     day: {use:, max:},
#     week: {use:, max:},
#     month: {use:, max:},
#     total:
#   },
#   nick:,
#   -servers: [
#   -    {servername: [channels]}
#   -],
#   uptime: {
#     current:,
#     total:
#   },
# }
