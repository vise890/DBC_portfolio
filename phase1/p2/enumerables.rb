# Array#map { |e| # block body }
#   replaces every element e of the array with the return
#   value of the block (executed on that element, e)
#
# Array#inject(sum) { |sum, e| # block body }
#   replaces the value of sum with the return of the block
#   returns the final value of sum
#
# Array#select { |e| # block body }
#   selects only the elements of the array for which the block
#   passed evaluates to true
#   returns an array containing only the selected elements
#
# yield
#   within a method, yield gives control to the passed block
#   (it *yields* to the block)
#   whenever the block returns, control is passed to the
#   environment from which yield was started

class Array

  def my_map!
    self.length.times do |idx|
      self[idx] = yield(self[idx])
    end
    return self
  end

  def my_map
    self.clone.my_map!(&block)
  end

  def my_select
    selected = []
    self.each do |e|
      selected << e if yield(e)
    end
    return selected
  end

  def my_inject(sum = nil)
    if sum.nil? # what if i call it as #my_inject(nil)
      sum = self.first
      default_sum = true
    end
    self.each_with_index do |e, idx|
      next if idx == 0 && default_sum
      sum = yield(sum, e)
    end
    return sum
  end

end


# testing
require 'rspec'

double = Proc.new do |e|
  e * 2
end

describe 'Array#my_map' do

  it 'duplicate the functionality of Array#map' do
    ary = (1..200).to_a.shuffle
    ary.my_map(&double).should == ary.map(&double)
  end

  it 'should operate non-destructively' do
    original_ary = [1, 2, 3]
    ary = original_ary.dup
    ary.my_map(&double)
    ary.should == original_ary
  end

end

# describe 'Array#my_select!' do
# 
#   it 'should duplicate the functionality of Array#select!' do
#     ary = (1..10).to_a.shuffle
#     ary.clone.my_select!(&:odd?).should == ary.clone.select!(&:odd?)
#     ary = (1..20).to_a.shuffle
#     ary.clone.my_select!(&:odd?).should == ary.clone.select!(&:odd?)
#   end
# 
#   it 'should operate destructively' do
#     original_ary = (1..200).to_a.shuffle
#     ary = original_ary.dup
#     ary.my_select!(&:odd?)
#     ary.should_not == original_ary
#   end
# end

describe 'Array#my_select' do

  it 'should duplicate the functionality of Array#select!' do
    ary = (1..10).to_a.shuffle
    ary.clone.my_select(&:odd?).should == ary.clone.select!(&:odd?)
    ary = (1..20).to_a.shuffle
    ary.clone.my_select(&:odd?).should == ary.clone.select!(&:odd?)
  end

end


describe 'Array#inject' do

  it 'duplicate the basic functionality of Array#inject on ary of fixnums' do
    ary = (1..200).to_a.shuffle
    ary.my_inject{ |sum, e| sum + e }.should == ary.inject(:+)
    ary = (1..200).to_a.shuffle
    ary.my_inject{ |sum, e| sum * e}.should == ary.inject(:*)
  end

  it 'should douplicate the basic functionality of Array#inject on ary of strings' do
    ary = %w(foo bar baz goo)
    ary.my_inject { |sum, e| sum + e }.should == ary.inject(:+)
  end

end
