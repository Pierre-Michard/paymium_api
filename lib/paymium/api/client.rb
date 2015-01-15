require "active_support/hash_with_indifferent_access"
require "active_support/core_ext/object/blank"
require "net/http"
require 'json'

require 'openssl'
require 'base64'


module Paymium
  module Api
    class Client

      def initialize config = {}
        @config = HashWithIndifferentAccess.new config
        @host = URI.parse @config.delete(:host)
      end

      def get path, params = {}, &block
        uri       = uri_from_path(path)
        uri.query = URI.encode_www_form params unless params.empty?
        request Net::HTTP::Get.new(uri), &block
      end

      def post path, params = {}, &block
        req = Net::HTTP::Post.new(uri_from_path(path))
        req.body = params.to_json
        request req, &block
      end


      private

      def set_header_fields req
        key = @config[:key]
        nonce = (Time.now.to_f * 10**6).to_i
        data = [nonce, req.uri.to_s, req.body].compact.join
        sig = OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @config[:secret], data).strip
        req.add_field "Api-Key", key
        req.add_field "Api-Nonce", nonce
        req.add_field "Api-Signature", sig
        req
      end

      def uri_from_path path
        uri       = @host.dup
        uri.path  = "#{@host.path}/#{path}".gsub('//','/')
        uri
      end

      def request req, &block
        req.content_type = 'application/json'
        set_header_fields(req) if @config[:key].present? and @config[:secret].present?
        Net::HTTP.start(@host.host, @host.port, :use_ssl => @host.scheme == 'https') do |http|
          resp = http.request req
          handle_response resp, &block
        end
      end

      #todo use Oj to parse response to handle big decimal
      def handle_response resp, &block
        if resp.class < Net::HTTPSuccess
          resp = JSON.parse(resp.body)
          block.nil? ? resp : block.call(resp)
        else
          raise Error, resp.message
        end
      end

      class Error < RuntimeError; end

    end
  end
end

