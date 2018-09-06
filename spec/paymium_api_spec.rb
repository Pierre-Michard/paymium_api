require 'spec_helper'

require 'bunny'

describe Paymium::Api::Client do
  let(:token){YAML.load(File.open('spec/fixtures/token.yml').read)}
  let(:client){Paymium::Api::Client.new  host: 'https://paymium.com/api/v1',
                                         key: token['token'],
                                         secret: token['secret']}
  subject{client}

  it 'can request client info' do
    ticker = client.get('/data/EUR/ticker')
    expect(ticker).to be_a Hash
    pp ticker
    expect(ticker).to have_key 'price'
    expect(ticker).to have_key 'currency'
    expect(ticker['currency']).to eq 'EUR'
  end

  it 'can require user info' do
    user = client.get('/user')
    expect(user).to be_a Hash
    expect(user).to have_key 'name'
  end

  it 'get websocket info' do
    thr = Thread.new { system( "node ws.js" )}
    conn = Bunny.new
    conn.start
    ch = conn.create_channel
    q  = ch.queue('paymium-user')
    q.subscribe do |delivery_info, properties, body|
      puts " [x] Received #{body}"

      # cancel the consumer to exit
      delivery_info.consumer.cancel
    end
    sleep(10.0)
    conn.close
    Thread.kill(thr)
  end
end
