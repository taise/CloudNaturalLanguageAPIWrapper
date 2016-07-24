# frozen_string_literal: true
require 'json'
require 'uri'
require 'net/http'

class CloudNaturalLanguageAPI
  HOST = 'language.googleapis.com'
  PORT = 443
  ANALYZE_ENTITIES_PATH = '/v1beta1/documents:analyzeEntities'

  attr_accessor :api_key
  def initialize(api_key)
    self.api_key = api_key
  end

  def post(uri, body)
    req = Net::HTTP::Post.new(uri.request_uri)
    req['Content-Type'] = 'application/json'
    req.body = body

    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true
    https.request(req)
  end

  def analyze_entities(content, lang = 'EN')
    uri = build_uri(ANALYZE_ENTITIES_PATH)
    post(uri, body(content, lang)).body
  end

  private

  def build_uri(path)
    URI::HTTPS.build(
      host: HOST,
      path: path,
      port: PORT,
      query: query
    )
  end

  def query
    "key=#{api_key}"
  end

  def body(content, lang)
    {
      document: {
        type: 'PLAIN_TEXT',
        language: lang,
        content: content
      },
      encodingType: 'UTF8'
    }.to_json
  end
end
