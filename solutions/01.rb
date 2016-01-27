CURRENCIES = {usd: 1.7408, eur: 1.9557, gbp: 2.6415, bgn: 1.0}

def convert_to_bgn(price, currency)
  result = price * CURRENCIES[currency]
  result.round(2)
end

def compare_prices(left_value, left_currency, right_value, right_currency)
  left_result = left_value * CURRENCIES[left_currency]
  right_result = right_value * CURRENCIES[right_currency]
  left_result <=> right_result
end

puts compare_prices(1, :usd, 1.7409, :bgn)
