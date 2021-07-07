def consolidate_cart(cart)
consolidated_cart = {}
  cart.each { |grocery| grocery.each { |product,values| consolidated_cart[product] = {price: values[:price], clearance: values[:clearance], count: cart.count(grocery)} } }
  consolidated_cart
end


def apply_coupons(cart, coupons)
  oupons_applied = {}
  coupons.each do |coupon|
    if cart.key?(coupon[:item])
      coupon_count = 0
      until coupon[:num] > cart[coupon[:item]][:count]
        cart[coupon[:item]][:count] -= coupon[:num]
        cart["#{coupon[:item]} W/COUPON"] = {price: coupon[:cost], clearance: cart[coupon[:item]][:clearance], count: coupon_count += 1}
      end
    end
  end
  cart.merge(coupons_applied)
end	


def apply_clearance(cart)
  cart.each {|grocery,value| cart[grocery][:price] = (cart[grocery][:price] * 0.8).round(2) if cart[grocery][:clearance] }
end	


def checkout(cart, coupons)
  cart = consolidate_cart(cart: cart)
  cart = apply_coupons(cart: cart, coupons: coupons)
  cart = apply_clearance(cart: cart)
  total = 0
  cart.each {|grocery,value| total += (cart[grocery][:price] * cart[grocery][:count]) if cart[grocery][:count] > 0}
  total > 100 ? (total*0.9).round(2) : total
end