def consolidate_cart(cart)
  new_hash = {}
  cart.each do |item|
    item.each do |key, value|
      if new_hash[key].nil?
        new_hash[key] = value
        new_hash[key][:count] = 1
      else
        new_hash[key][:count] = new_hash[key][:count] + 1
      end
    end
  end
  new_hash
end

# def apply_coupons(cart, coupons = nil)
#   new_hash = {}
#   if coupons
#     coupons.each do |item|
#         item.each do |key, discount|
#           cart.each do |subkey, value|
#             new_hash[subkey] = value
#             if discount == subkey
#               if new_hash[subkey + " W/COUPON"].nil?
#                 new_hash[subkey][:count] -= item[:num]
#                 price = item[:cost] / item[:num]
#                 new_hash[subkey + " W/COUPON"] = {:price => price,
#                 :clearance => new_hash[subkey][:clearance],
#                 :count => item[:num]}
#                 if new_hash[subkey][:count] == 0
#                   new_hash.delete(subkey)
#                 end
#               else
#                 new_hash[subkey][:count] -= item[:num]
#                 price = item[:cost] / item[:num]
#                 new_hash[subkey + " W/COUPON"][:count] += item[:num]
#                 if new_hash[subkey][:count] == 0
#                   new_hash.delete(subkey)
#                 end
#               end
#             end
#           end
#         end
#     end
#   else
#     return cart
#   end
#   new_hash
# end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item = coupon[:item]
    if cart.has_key?(item)
      if cart[item][:count] >= coupon[:num] && !cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"] = {price: coupon[:cost] / coupon[:num], clearance: cart[item][:clearance], count: coupon[:num]}
        cart[item][:count] -= coupon[:num]
      elsif cart[item][:count] >= coupon[:num] && cart.has_key?("#{item} W/COUPON")
        cart["#{item} W/COUPON"][:count] += coupon[:num]
        cart[item][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  new_cart = {}
  cart.each do |item, value|
    if value[:clearance] == true
      new_cart[item] = value
      new_cart[item][:price] *= 0.80
      new_cart[item][:price] = new_cart[item][:price].round(2)
    else
      new_cart[item] = value
    end
  end
  new_cart
end

def checkout(cart, coupons)
  consolidated_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consolidated_cart, coupons)
  final_cart = apply_clearance(coupon_cart)
  
  total = 0
  
  final_cart.each do |item,value|
    total += value[:price] * value[:count]
  end
  if total > 100
    total *= 0.90
  end
  total
end
