require 'pry'

def consolidate_cart(cart)
  final_hash = {}
  cart.map do |element_hash|
    element_name = element_hash.keys[0]
    
    if final_hash.has_key?(element_name)
      final_hash[element_name][:count] += 1 
    else
      final_hash[element_name] = {
        price: element_hash[element_name][:price],
        clearance: element_hash[element_name][:clearance],
        count: 1 
      }
    end
  end
  final_hash
end

def apply_coupons(cart, coupons)
  coupons.map do |coupon|
    item = coupon[:item]
    coupon_item = "#{item} W/COUPON"
    if cart[item]
      if cart[item][:count] >= coupon[:num]
        if !cart[coupon_item]
          cart[coupon_item] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
        else
          cart[coupon_item][:count] += coupon[:num]
        end
        cart[item][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.map do |product_name, product_stats|
    if product_stats[:clearance] == true 
      product_stats[:price] = (product_stats[:price] * 0.8).round(2)
    end
  end
  cart
end

def checkout(cart, coupons)
  hash_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_clearance = apply_clearance(applied_coupons)
  total = applied_clearance.reduce(0) { |acc, (key, value)| acc += value[:price] * value[:count] }
  if total > 100
    total * 0.9
  else
    total
  end
end
