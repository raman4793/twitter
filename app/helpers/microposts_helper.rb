module MicropostsHelper
	def render_with_tags(content)
		doc = Nokogiri::HTML(content)
		doc.css('p').each { |p| p.inner_html = p.inner_html.gsub(/#\w+/){|word| link_to word, "/microposts/tags/#{word.delete('#')}"} }
		doc.css('.atwho-inserted').each do |m|
			m.inner_html = link_to m.content, user_path(User.find_by(uname: m.content))
		end
		doc.to_s
	end
end


# def render_with_tags(content)
# 	content = content.gsub(/#\w+/){|word| link_to word, "/microposts/tags/#{word.delete('#')}"}
# 	doc = Nokogiri::HTML(content)
# 	doc.css('.atwho-inserted').each do |m|
# 		puts(m.content)
# 		m.content = link_to m.content, "/users/#{User.find_by(uname: m.content)}"
# 	end
# 	doc.to_s
# end