#!/usr/bin/ruby
# Write the input in the input.txt file using the some format in the examples.
# To exec: ruby solution.rb 

# def
$nearest = 1/0.05

$db_tax_rate = {
	imported: 5,
	goods: 10,
	except: 0
}

$db_except_products = [
	"chocolate",
	"pills",
	"book"
]

def roundingUp(tax)
	(tax * $nearest).ceil / $nearest
end 

def getTax(price, tax_rate)
	(price * tax_rate)/100
end

def getValues(qty, price, tax_rate)
	tax = getTax(price, tax_rate)
	final_tax = roundingUp(tax)
	final_price = price + final_tax
	
	return final_tax, final_price
end

def isExcept(product)
	is_except = false

	$db_except_products.each do |except_product|
		is_except = product.include? except_product
		break if is_except
	end

	is_except
end

def getTaxRate(product)
	tax_rate = 0
	is_imported = product.include? "imported"
	is_except = isExcept(product)

	tax_rate += is_imported ? $db_tax_rate[:imported] : 0
	tax_rate += is_except ? $db_tax_rate[:except] : $db_tax_rate[:goods]

	tax_rate
end

# program
f = File.open("input.txt")

sales_taxes = 0
total = 0

while line = f.gets do
	detail = line.split(" at ")
	price = detail[1].to_f
	
	#puts detail[0]
	qty_product = detail[0].split(/ /, 2)
	#puts qty_product
	
	qty = qty_product[0].to_i
	product = qty_product[1]
	
	sub_total = price * qty

	tax_rate = getTaxRate(product)
	final_tax, final_price = getValues(qty, price, tax_rate)
	final_sub_total = (final_price * qty).round(2)

	sales_taxes += (final_sub_total - sub_total)
	total += final_sub_total
	puts "#{detail[0]}: #{final_sub_total}"
end

puts "Sales Taxes: #{sales_taxes.round(2)}"
puts "Total: #{total}"