require 'benchmark'
require 'flowcommerce'

org = ARGV.shift.to_s.strip
if org.empty?
  puts "ERROR: org is required"
  exit(1)
end

client = FlowCommerce.instance(:token => IO.read(File.expand_path("~/.flow/#{org}")).strip)

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

result = `curl --silent -d@/tmp/card.json -H 'Content-type: application/json' https://api.flow.io/food52-sandbox/cards`

token = if md = result.match(/(F17[0-9a-zA-Z]+)/)
  md[1]
else
  puts "Failed to find token: #{result.inspect}"
  exit(1)
end

bm = Benchmark.measure { 
  puts "     Exchanging token: %s" % token
  form = ::Io::Flow::V0::Models::CardNonceForm.new(:token => token)
  card = client.cards.post_nonces(org, form)
  puts "Done. Permanent token: %s" % card.token
}

puts ""
puts "Time"
puts bm
