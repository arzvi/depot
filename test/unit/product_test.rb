require 'test_helper'

class ProductTest < ActiveSupport::TestCase
    
	fixtures :products

def new_product(image_url)
	Product.new(title: "My book is big",
	description: "Desc",
	price: 1,
	image_url: image_url)
end

test "product attributes should not be empty" do 
	product = Product.new
	assert product.invalid?
	assert product.errors[:title].any?
	assert product.errors[:description].any?
	assert product.errors[:image_url].any?
	assert product.errors[:price].any?
end 

test "product price must be positive" do 
	product = Product.new( title:	"My book title",
				description: "Desc1",
				image_url: "zz.jpg")
	product.price = -1
	assert product.invalid?
 	assert_equal "must be greater than or equal to 0.01",
	 product.errors[:price].join('; ')

	product.price = 0
	assert product.invalid?
 	assert_equal "must be greater than or equal to 0.01", 
	product.errors[:price].join('; ')
	product.price = 1
	assert product.valid?
end
test "image_url" do 
	ok = %w{ fred1.gif fred.jpg fred.png FRED.Jpg FRED.JPG http://a.b.c/x/y/z/fred.gif dummy.gif }
	bad = %w{ fred.doc fred.gif/more fred.gif.more }
	
	ok.each do |name|
		assert new_product(name).valid?, "#{name} shouldn't be invalid"
	end
	
	bad.each do |name|
		assert new_product(bad).invalid?, "#{name} should'nt be valid"
	end
 
end

test "product is not valid without a unique title" do 
	product = Product.new(title: products(:ruby).title,
			description: "yyy",
			price: 1,
			image_url:  "fred.gif")
	assert !product.save
	assert_equal "has already been taken", product.errors[:title].join('; ')
end 

test "product is not valid without a unique title - i18n" do 
	product = Product.new( title: products(:ruby).title, description: "yyy", price: 1, image_url: "fred.gif")
	assert !product.save 
	assert_equal I18n.translate('activerecord.errors.messages.taken'), product.errors[:title].join('; ')
end 

test "product title should have atleast 10 characters" do 
	product = Product.new( title: "new",
	description: "small title", 
	price: 1,
	image_url: "small_desc.jpg")
	assert product.invalid?
	assert_equal "is too short (minimum is 10 characters)", product.errors[:title].join('; ')
end

end

