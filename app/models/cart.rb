class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def subtotal_with_discounts(item, quantity)
    discount = item.select_highest_discount(quantity)
    percentage = discount.percentage.to_f / 100
    (item.apply_discount(percentage)) * quantity
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def inc_qty(item_id) 
    contents[item_id] += 1
  end

  def dec_qty(item_id)
    contents[item_id] -= 1
  end

  def out_of_stock?(item_id) 
    Item.find(item_id).inventory <= contents[item_id]
  end

  def decrease_removal?(item_id)
    contents[item_id] == 0
  end
end

