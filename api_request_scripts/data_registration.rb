require 'net/http'
require 'json'
require 'dotenv/load'
require './api_request_scripts/get_real_data'
require './api_request_scripts/login'

def create_data(params)
  uri = URI.parse('http://localhost:8080/api/v1/initial_register_db')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme == 'https'
  http.read_timeout = nil

  headers = {
    'Content-Type' => 'application/json',
    'access-token' => ENV['AUTH_API_ACCESS_KEY']
  }

  response = http.post(uri.path, params.to_json, headers)
  p JSON.parse(response.body)
end

def all_axs_create(auth_info)
  info = get_all_axs(auth_info)
  new_auth_info = info[:auth_info]
  all_axs = info[:body]
  data_array = [];

  all_axs.each do |data|
    params = {      
      'date(1i)' => data['date'].split('-')[0],
      'date(2i)' => data['date'].split('-')[1],
      'date(3i)' => data['date'].split('-')[2],
      'to_id' => data['to_id'],
      'source_id' => data['source_id'],
      'card_id' => data['card_id'],
      'value' => data['value'],
      'pon' => data['pon']
    }

    if data['pay_date']
      params['pay_date(1i)'] = data['pay_date'].split('-')[0]
      params['pay_date(2i)'] = data['pay_date'].split('-')[1]
      params['pay_date(3i)'] = data['pay_date'].split('-')[2]
    end
    data_array.push params
  end
  
  params = {
    'kind' => '1',
    'data_array' => data_array
  }
  create_data(params)
  return new_auth_info
end

def all_events_create(auth_info)
  info = get_all_events(auth_info)
  new_auth_info = info[:auth_info]
  all_events = info[:body]
  data_array = []

  all_events.each do |data|
    params = {
      'date(1i)' => data['date'].split('-')[0],
      'date(2i)' => data['date'].split('-')[1],
      'date(3i)' => data['date'].split('-')[2],
      'genre_id' => data['genre_id'],
      'account_id' => data['account_id'],
      'card_id' => data['card_id'],
      'memo' => data['memo'],
      'value' => data['value'],
      'iae' => data['iae'],
      'pon' => data['pon']
    }

    if data['pay_date']
      params['pay_date(1i)'] = data['pay_date'].split('-')[0]
      params['pay_date(2i)'] = data['pay_date'].split('-')[1]
      params['pay_date(3i)'] = data['pay_date'].split('-')[2]
    end
    data_array.push params
  end
  
  params = {
    'kind' => '0',
    'data_array' => data_array
  }
  create_data(params)
  return new_auth_info
end

def all_fuh_create(auth_info)
  info = get_all_fund_users(auth_info)

  new_auth_info = info[:auth_info]
  all_fund_users = info[:body]

  all_fund_users.each do |data|
    params = {
      'kind' => '2',
      'fund_id' => data['fund_id'],
      'average_buy_value' => data['average_buy_value']
    }

    fuh_array = []
    info = get_all_fuh(data['id'],new_auth_info)
    all_fuh = info[:body]
    new_auth_info = info[:auth_info]
    all_fuh.each do |fuh|
      fuh_params = {
        'buy_or_sell' => fuh['buy_or_sell'],
        'commission' => fuh['commission'],
        'date(1i)' => fuh['date'].split('-')[0],
        'date(2i)' => fuh['date'].split('-')[1],
        'date(3i)' => fuh['date'].split('-')[2],
        'pon' => fuh['pon'],
        'value' => fuh['value'],
        'account_id' => fuh['account_id'],
        'card_id' => fuh['card_id'],
        'buy_date(1i)' => fuh['buy_date'].split('-')[0],
        'buy_date(2i)' => fuh['buy_date'].split('-')[1],
        'buy_date(3i)' => fuh['buy_date'].split('-')[2],
      }

      if fuh['pay_date']
        fuh_params['pay_date(1i)'] = fuh['pay_date'].split('-')[0]
        fuh_params['pay_date(2i)'] = fuh['pay_date'].split('-')[1]
        fuh_params['pay_date(3i)'] = fuh['pay_date'].split('-')[2]
      end

      fuh_array.push fuh_params
    end

    params['fuh'] = fuh_array
    create_data(params)
  end

  return new_auth_info
end

def all_funds_create(auth_info)
  info = get_all_funds(auth_info)

  new_auth_info = info[:auth_info]
  all_funds = info[:body]
  data_array = []

  all_funds.each do |fund|
    params = {
      fund: {
        id: fund['id'],
        name: fund['name'],
        value: fund['value'],
        string_id: fund['string_id'],
      }
    }
    data_array.push params
  end
  
  register_funds(data_array)
  return new_auth_info
end

def register_funds(data_array)
  uri = URI.parse('http://localhost:8080/api/v1/register_funds')
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = uri.scheme === 'https'
  http.read_timeout = nil

  headers = {
    'access-token' => ENV['AUTH_API_ACCESS_KEY'],
    'Content-Type' => 'application/json'
  }

  params = { funds: data_array }

  response = http.post(uri.path, params.to_json, headers)

  p JSON.parse(response.body)
end

auth_info = login
# auth_info = all_events_create(auth_info)
# auth_info = all_axs_create(auth_info)
auth_info = all_funds_create(auth_info)
auth_info = all_fuh_create(auth_info)
