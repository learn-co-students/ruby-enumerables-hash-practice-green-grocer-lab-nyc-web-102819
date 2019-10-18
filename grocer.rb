def consolidate_cart(cart)
  list = {}
  cart.each do
    |item|
    item.each do
      |name, info|
      if list.key?(name)
        list[name][:count] += 1
      else
        list[name] = info
        list[name][:count] = 1
      end
    end
  end
  list
end

def apply_coupons(cart, coupons)
  # coupon_cart = cart.reduce({}) do
  #   |memo, (item, details)|
  #   memo[item] = details
  #   coupons.each do
  #     |coupon|
  #     if coupon[:item] == memo[item]
  #       new_item = item + " W/COUPON"
  #       while (memo[item][:count] >= coupon[:num])  do
  #         if memo.key?(new_item)
  #           memo[new_item][:count] += coupon[:num]
  #           memo[item][:count] -= coupon[:num]
  #         else
  #           memo[new_item] = {}
  #           memo[new_item][:count] = coupon[:num]
  #           memo[new_item][:clearance] = memo[item][:clearance]
  #           memo[new_item][:price] = coupon[:cost]/coupon[:num]
  #           memo[item][:count] -= coupon[:num]
  #         end
  #       end
  #     end
  #   end
  #   memo
  # end
  # coupon_cart
  
  coupons.each do |coupon|
    if cart[coupon[:item]] && cart[coupon[:item]][:count] >= coupon[:num]
      new_item = coupon[:item] + " W/COUPON"
      if cart[new_item]
        cart[new_item][:count] += coupon[:num]
        cart[coupon[:item]][:count] -= coupon[:num]
      else 
        cart[new_item] = {}
        cart[new_item][:count] = coupon[:num]
        cart[new_item][:clearance] = cart[coupon[:item]][:clearance]
        cart[new_item][:price] = coupon[:cost]/coupon[:num]
        cart[coupon[:item]][:count] -= coupon[:num]
      end
    end
  end
  cart
end

def apply_clearance(cart)
  clearance_price = 0.80
  
  cleared_cart = cart.reduce({})  do
    |memo, (item, details)|
    memo[item] = details
    if details[:clearance]
      memo[item][:price] *= clearance_price
    end
    memo[item][:price] = memo[item][:price].round(2)
    memo
  end
  cleared_cart
end

def checkout(cart, coupons)
  discount_minimum = 100.00
  discount_price = 0.90

  consolidated = consolidate_cart(cart)
  couponed = apply_coupons(consolidated, coupons)
  cleared = apply_clearance(couponed)

  cart_total = cleared.reduce(0)  do
    |memo, (item, details)|
    memo += (details[:price] * details[:count])
    memo.round(2)
    memo
  end
  if cart_total > discount_minimum
    cart_total *= discount_price
  end
  cart_total = cart_total.round(2)
  cart_total
end
