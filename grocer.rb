def consolidate_cart(cart)
  result = {}
  cart.each do |item|
    food_name = item.keys[0]
    food_attributes = item.values[0]
    if result[food_name]
      result[food_name][:count] += 1
    else
      result[food_name] = {
        price: food_attributes[:price],
        clearance: food_attributes[:clearance],
        count: 1,
      }
    end
  end
  result
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    item_name = coupon[:item]
    coupon_item = "#{item_name} W/COUPON"
    if cart[item_name]
      if cart[item_name][:count] >= coupon[:num]
        if !cart[coupon_item]
          cart[coupon_item] = {
            price: coupon[:cost] / coupon[:num],
            clearance: cart[item_name][:clearance],
            count: coupon[:num],
          }
        else
          cart[coupon_item][:count] += coupon[:num]
        end
      cart[item_name][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  cart.each do |name, attributes|
    attributes[:price] -= attributes[:price] * 0.2 unless !attributes[:clearance]
  end
  cart
end

def checkout(cart, coupons)
  hash_cart = consolidate_cart(cart)
  applied_coupons = apply_coupons(hash_cart, coupons)
  applied_discount = apply_clearance(applied_coupons)
  total = applied_discount.reduce(0) { |sum, (key, value)| sum += value[:price] * value[:count]}
  total > 100 ? total * 0.9 : total
end