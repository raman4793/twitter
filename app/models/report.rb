class Report < ApplicationRecord
  belongs_to :user
  belongs_to :reported, class_name: "User", foreign_key: :reported_id

  default_scope -> { distinct :reported }

  def get_count
    Report.all.count(reported_id)
  end

end
