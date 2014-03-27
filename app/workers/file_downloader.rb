# encoding: utf-8

require 'httparty'

class FileDownloader
  include Sidekiq::Worker

  sidekiq_options :retry => 3

  def perform(url, local_path, game_id = nil)
    `wget "#{url}" -O #{local_path}` unless File.exists?(local_path)
    return
    uri = URI(url)

    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri.request_uri

      http.request request do |response|
        open local_path, 'wb' do |io|
          response.read_body do |chunk|
            io.write chunk
          end
        end
      end
    end
  end
end
