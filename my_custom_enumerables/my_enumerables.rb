module Enumerable
  def my_each_with_index
    i = 0
    self.each do |item|
      yield(item, i)
      i += 1 
    end
    self
  end

  def my_select
    selected_items = []
    self.my_each do |item|
      selected_items.push(item) if yield(item)
    end
    selected_items
  end

  def my_all?
    meet_all = true
    self.each do |item|
      meet_all = false unless yield(item)
    end
    meet_all
  end

  def my_none?
    meet_none = true
    self.each do |item|
      meet_none = false if yield(item)
    end
    meet_none
  end

  def my_count
    i = 0
    if block_given?
      self.each {|item| i += 1 if yield(item)}
      i
    else
      self.length
    end  
  end

  def my_map
    new_array = []
    self.each {|item| new_array.push(yield(item))}
    new_array
  end 
  
  def my_inject(initial_value)
    i = initial_value
    self.each { |item| i = yield(i, item) } if block_given?
    i
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each
    i = 0
    while i < self.length do
      yield(self[i]) 
      i += 1
    end
    self
  end
end
