ActiveAdmin.register Report do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  config.batch_actions = true

  index do
    selectable_column
    column :user
    column :reason
    column :reported
    column :created_at
    column :count, sortable: :count do |product|
      product.get_count
    end
    actions
  end

end
