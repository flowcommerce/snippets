#!/usr/bin/env ruby

#Examples:
#
# Test using flow client:
#  ./card-nonce-exchange.rb <org>
#
# Test using curl directly:
#  ./card-nonce-exchange.rb <org> curl
#

require 'benchmark'
require 'flowcommerce'

org = ARGV.shift.to_s.strip
if org.empty?
  puts "ERROR: org is required"
  exit(1)
end

type = ARGV.shift.to_s.strip
if type.empty?
  type = 'client'
elsif type != 'curl'
  puts "ERROR: Unknown type '$typ'. Must be 'client' or 'curl'"
  exit(1)
end

api_key = IO.read(File.expand_path("~/.flow/#{org}")).strip
client = FlowCommerce.instance(:token => api_key)

card_path = "/tmp/card.json"
File.open(card_path, "w") do |out|
  value = <<eof
{
  "name":"John Doe",
  "expiration_month":12,
  "expiration_year":2017,
  "cvv":"567",
  "cipher":"UtSeFQQbydWUhXwr3l3/pnm/R4nxO+/+gW8Xp9X1RY+YK+prL5z7NMN5m5Vp6yGtdq9Z34/90Y/T/8lA+KGvvg=="
}
eof
  out << value
end

result = `curl --silent -d@/tmp/card.json -H 'Content-type: application/json' https://api.flow.io/#{org}/cards`

token = if md = result.match(/(F17[0-9a-zA-Z]+)/)
  md[1]
else
  puts "Failed to find token: #{result.inspect}"
  exit(1)
end

bm = Benchmark.measure { 
  puts "     Exchanging token: %s" % token
  token = if type == "curl"
    cmd = "curl --silent -u #{api_key}: -d token=#{token} https://api.flow.io/#{org}/cards/nonces"
    result = `#{cmd}`.strip
    card = JSON.parse(result)
    card['token']
  else
    form = ::Io::Flow::V0::Models::CardNonceForm.new(:token => token)
    card = client.cards.post_nonces(org, form)
    card.token
  end
  puts "Done. Permanent token: %s" % token
}

puts ""
puts "Time"
puts bm
