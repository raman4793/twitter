class ContentValidator < ActiveModel::Validator
  def validate(record)
    puts("Validating ")
    doc = Nokogiri(record.content)
    content = doc.content
    unless content.length<141
      record.errors[:content] << 'Length of the content should be less than 140 characters'
    end
  end
end