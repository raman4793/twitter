class Tag < ApplicationRecord
	  has_and_belongs_to_many :microposts

	def self.get_all_top()
    max_tag = MicropostsTag.group(:tag_id).count(:tag_id)
    max_tag = max_tag.sort_by {|k, v| v}.reverse
    id = []
    max_tag.each do |tag|
      id<<(tag[0])
    end
    Tag.find(id)
  end
end
