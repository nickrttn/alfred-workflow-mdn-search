#! /usr/bin/env ruby

require 'json'
require 'logger'
require 'net/http'
require 'uri'

logger = Logger.new(STDOUT)

query = ARGV[0]

uri = URI("https://developer.mozilla.org/api/v1/search")
params = { q: query, locale: 'en-US' }
uri.query = URI.encode_www_form(params)

res = Net::HTTP.get_response(uri)
results = JSON.parse(res.body)

mdn_base_url = "https://developer.mozilla.org/"
items = []

results['documents'].each do |document|
  items << {
    uid: document['slug'],
    title: document['title'],
    subtitle: document['summary'],
    quicklookurl: mdn_base_url + document['mdn_url'],
    description: document['summary'],
    autocomplete: document['title'],
    arg: mdn_base_url + document['mdn_url'],
    action: {
      url: mdn_base_url + document['mdn_url'],
    },
  }
end

puts JSON.generate({:items => items})
