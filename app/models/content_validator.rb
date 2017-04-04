class ContentValidator < ActiveModel::Validator
  def validate(record)
    doc = Nokogiri(record.content)
    content = doc.text.squeeze
    unless content.length<141
      record.errors[:content] << 'Length of the content should be less than 140 characters'
    end
  end
end