require 'curb'
require 'nokogiri'
require 'csv'

def product_reading product_link

  http = Curl.get(product_link)

  doc = Nokogiri::HTML(http.body_str)

  product_main_name = doc.at_xpath('//h1[@class = "product_main_name"]').text.strip
  
  meassure_m = []
  price_m = []
  product_data = []
  product = []
  
  doc.xpath("//span[@class = 'radio_label']").each do |measure|
    meassure_m << measure.text.strip
  end
  
  doc.xpath("//span[@class = 'price_comb']").each do |price|
    price_m << price.text.strip
  end

  product_data = meassure_m.zip price_m
  product_data << ["None", "None"] if product_data.empty?
  image = doc.css("img[id='bigpic']")[0]['src']

  product_data.each do |data|
    product << [product_main_name + ' - '+ data[0], data[1][/\d*.\d*/], image]

  end

  return product

end

def save_to_path path, output
  CSV.open(path, 'w', headers: ['Name', 'Price', 'Image'], write_headers: true) do |csv|
    puts 'saving...'
    output.each do |product|
      
      product.each do |item|

        csv << item

      end
    end
    puts 'done!'
  end
end


puts 'Enter link of the category page (default: https://www.petsonic.com/antiparasitarios-para-perros/):'
http = gets.strip
http = "https://www.petsonic.com/antiparasitarios-para-perros/" if http == ''

puts 'Enter output filename (default: answer.csv):'
path = gets.strip
path = 'answer.csv' if path == ''

output = []
i = 1
http_cat = Curl.get(http)

begin

  doc_cat = Nokogiri::HTML(http_cat.body_str)

  product_links = doc_cat.css("a[class='product_img_link pro_img_hover_scale product-list-category-img']")

  product_links.each do |product_link|
    puts "reading: #{product_link['href']}"
    a = product_reading product_link['href']
    output << a
  end

  i += 1

  http_cat = Curl.get("#{http}?p=#{i}")

end while !http_cat.body_str.empty?

save_to_path path, output


 # def product_reading product_link
  # names = []
  # h = {}
# puts doc.xpath("//span[@class = 'radio_label']")[i].text
# puts doc.xpath("//span[@class = 'price_comb']")[i].text

  # measure_price = doc.css("span").select{|link| (link['class'] == 'radio_label') || (link['class'] == 'price_comb') }

  # measure_price.each_with_index do |link, i|
    
  #   h[:measure] = link.text if i.even?
  #   if i.odd?

  #     h[:price] = link.text[/\d*.\d*/]
      
  #     names << h
  #     h = {}
  #   end
  # end

  # names.each do |block|
  #   puts product_main_name + ' - ' + block[:measure] + ', ' + block[:price]
  # end
# end




  #   # puts product_link.css("a[class='product_img_link pro_img_hover_scale product-list-category-img']")
  #   # puts "reading: #{product_link}"
  #   # product_reading product_link.href


  # product_links = doc_cat.at_xpath("//a[@class =’product_img_link pro_img_hover_scale product-list-category-img’]")
  # product_links = doc_cat.xpath('//div[@class = "pro_first_box"]/*')
  # product_links = doc_cat.xpath('//*[contains(@class, "pro_first_box")]/*')
  # puts product_links








# "//*[contains(@class,’product_img_link pro_img_hover_scale product-list-category-img’)]"

# puts doc_cat.css("div[class='af dynamic-loading next hidden']")

# doc.xpath('//*[@class = "attribute_list"]/*') do 
# measure = doc.at_xpath('//span[@class = "radio_label"]')
# puts measure
# doc.at_xpath('//span[@class = "radio_label"]').each do |measure|
# puts doc.css("span[class = 'radio_label']" || "span[class = 'price_comb']")

# price = link.at_xpath("//span[@class = 'price_comb']")
# end
# names.push(
#  measure: measure.children.text,
#  price: price.children.text
# )

# # end
# puts product_main_name

# measure = doc.at_xpath("(//span[@class = 'radio_label'])[3]")
# puts measure.class


# http = Curl.get("https://www.petsonic.com/dermovital-bote-omega-3-6-9-para-perro.html")



# doc = Nokogiri::HTML(http.body_str)

# product_main_name = doc.at_xpath('//h1[@class = "product_main_name"]').text

# names = []
# h = {}


# measure_price = doc.css("span").select{|link| (link['class'] == 'radio_label') || (link['class'] == 'price_comb') }

# measure_price.each_with_index do |link, i|
  
#   h[:measure] = link.text if i.even?
#   if i.odd?

#     h[:price] = link.text[/\d*.\d*/]
    
#     names << h
#     h = {}
#   end
# end

# names.each do |block|
#   puts product_main_name + ' - ' + block[:measure] + ', ' + block[:price]
# end




#doc.xpath('//*[@class = "attribute_list"]/*') do 
# measure = doc.at_xpath('//span[@class = "radio_label"]')
# puts measure
# doc.at_xpath('//span[@class = "radio_label"]').each do |measure|
#puts doc.css("span[class = 'radio_label']" || "span[class = 'price_comb']")

# price = link.at_xpath("//span[@class = 'price_comb']")
# end
# names.push(
#  measure: measure.children.text,
#  price: price.children.text
# )

# # end
# puts product_main_name

# measure = doc.at_xpath("(//span[@class = 'radio_label'])[3]")
# puts measure.class
