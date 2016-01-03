def consolidate_cart(cart:[])
  hash = {}
  cart.each do |element|
     element.each do |key, value|
       value[:count] = cart.count(element)
       hash[key] = value
     end
  end
  hash
end


def apply_coupons(cart: {}, coupons:[])
  hashes_to_add = []
  cart.each do |key, value|
    hash = {}
    coupon_hash = {}
    coupons.each do |element|
      if key == element[:item] &&  value[:count] >= element[:num]
          hash[:price] = element[:cost]; hash[:clearance] = value[:clearance]; hash[:count] = 1
          coupon_hash["#{key} W/COUPON"] = hash
          if hashes_to_add.count(coupon_hash) != 0
            hashes_to_add.delete(coupon_hash)
            hash[:count] += 1
            coupon_hash["#{key} W/COUPON"] = hash
          end
            value[:count] = value[:count] - element[:num]
            hashes_to_add <<  coupon_hash
      end
    end
  end
  hashes_to_add.each {|hash| cart.merge!(hash)}
  cart
end

def apply_clearance(cart: {})
  hash = {}
  cart.each do |key, value|
      if value[:clearance] == true
        value[:price] = value[:price] *  0.8
      end
      value[:price] = (value[:price]).round(2)
      hash[key] = value
  end
  hash
end

def checkout(cart: [], coupons: [])
  cart_hash = consolidate_cart(cart: cart)
  coupon_hash = apply_coupons(cart: cart_hash, coupons: coupons)
  clearance_hash = apply_clearance(cart: coupon_hash)
  total = 0.00
  clearance_hash.each do |key, value|
    total = total + (value[:price] * value[:count]).round(2)
  end
  if total > 100.00
    total = (total * 0.9).round(2)
  end
  total
end
