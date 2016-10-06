#!/usr/bin/env ruby

# <bitbar.title>Russian Ruble Currency Pair</bitbar.title>
# <bitbar.version>v1.0</bitbar.version>
# <bitbar.author>Roman Krasavtsev</bitbar.author>
# <bitbar.author.github>RomanKrasavtsev</bitbar.author.github>
# <bitbar.desc>Currency pair from ruble to another currency</bitbar.desc>
# <bitbar.image>https://raw.github.com/romankrasavtsev/ruble-currency-pair-bitbar-plugin/master/ruble_currency_pair_emoji.png</bitbar.image>
# <bitbar.dependencies>ruby</bitbar.dependencies>
# <bitbar.abouturl>https://github.com/RomanKrasavtsev/ruble-currency-pair-bitbar-plugin</bitbar.abouturl>

require "nokogiri"
require "open-uri"

def get_exchange_rate emoji, *currencies
  result_string = ""

  currencies.each do |currency|
    sign = get_sign emoji, currency
    user_agent = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.2 (KHTML, like Gecko) Chrome/15.0.854.0 Safari/535.2"

    rate = Nokogiri::HTML(open("http://www.investing.com/currencies/#{currency}-rub", 'User-Agent' => user_agent), nil, "UTF-8")
      .css("#quotes_summary_current_data")
      .css(".left")
      .css(".inlineblock")
      .css(".top")
      .css("span")
      .first
      .to_s
      .gsub(/<[^>]*>/, "")

    result_string += "#{sign} #{rate}  "
  end

  result_string
end

def get_sign emoji, currency
  case currency
  when "USD"
    sign  = emoji ? "🇺🇸" : "$"
  when "EUR"
    sign = emoji ? "🇪🇺" : "€"
  when "GBP"
    sign = emoji ? "🇬🇧" : "£"
  when "CHF"
    sign = emoji ? "🇨🇭" : "Fr"
  when "JPY"
    sign = emoji ? "🇯🇵" : "J¥"
  when "CNY"
    sign = emoji ? "🇨🇳" : "C¥"
  when "CAD"
    sign = emoji ? "🇨🇦" : "C$"
  when "TRY"
    sign = emoji ? "🇹🇷" : "₺"
  else
    sign = currency
  end

  sign
end

# Sample currencies:
# USD - United States dollar
# EUR - Euro
# GBP - British pound
# CHF - Swiss franc
# JPY - Japanese yen
# CNY - Chinese yuan
# CAD - Canadian dollar
# TRY - Turkish lira

# You could try to use another currency,
# but you should add sign to the method get_sign

emoji = true
puts get_exchange_rate emoji, "USD", "EUR", "GBP", "CAD"
