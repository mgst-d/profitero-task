require 'curb'
require 'nokogiri'

http = Curl.get("https://www.petsonic.com/dermovital-bote-omega-3-6-9-para-perro.html")



doc = Nokogiri::HTML(http.body_str)

product_main_name = doc.at_xpath('//h1[@class = "product_main_name"]').text

names = []
h = {}


measure_price = doc.css("span").select{|link| (link['class'] == 'radio_label') || (link['class'] == 'price_comb') }

measure_price.each_with_index do |link, i|
  
  h[:measure] = link.text if i.even?
  if i.odd?

    h[:price] = link.text[/\d*.\d*/]
    
    names << h
    h = {}
  end
end

names.each do |block|
  puts product_main_name + ' - ' + block[:measure] + ' ' + block[:price]
end




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
