require 'pry'

def consolidate_cart(cart)
  final_hash = {}
  cart.each do |element_hash|
    element_name = element_hash.keys[0]

      if final_hash.has_key?(element_name)
        final_hash[element_name][:count] += 1
      else
        final_hash[element_name] = {
          count: 1,
          price: element_hash[element_name][:price],
          clearance: element_hash[element_name][:clearance]
        }
      end
  end
  final_hash
end

def apply_coupons(cart, coupons)

  coupons.each do |coupon|
    item = coupon[:item]
    if cart.has_key?(item)
      if !cart["#{item} W/COUPON"] && cart[item][:count] >= coupon[:num]
        cart["#{item} W/COUPON"] = {count: coupon[:num], price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance]}
        cart[item][:count] -= coupon[:num]
      elsif cart["#{item} W/COUPON"] && cart[item][:count] >= coupon[:num]
        cart["#{item} W/COUPON"][:count] += coupon[:num]
        cart[item][:count] -= coupon[:num]
      end
    end
  end
cart
end






def apply_clearance(cart)
  cart.each do |item, attribute_hash|
    if attribute_hash[:clearance] == true
      attribute_hash[:price] = (attribute_hash[:price] *
      0.8).round(2)
    end
  end
cart
end

def checkout(cart, coupons)
  total = 0
  new_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(new_cart, coupons)
  clearance_cart = apply_clearance(coupon_cart)
  clearance_cart.each do |item, attribute_hash|
    total += (attribute_hash[:price] * attribute_hash[:count])
  end
 if total > 100
   total = (total * 0.9)
 else
   total
end
total
end
