ActiveAdmin.register User do
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

  show title: :name do
    panel "Microposts" do
      paginated_collection(user.microposts.page(params[:page]).per(15)) do
        table_for(collection) do
          column("Micropost", :sortable => :content) {|micropost| link_to "#{micropost.content}", admin_micropost_path(micropost) }
          # column("State")                   {|order| status_tag(order.state) }
          # column("Date", :sortable => :checked_out_at){|order| pretty_format(order.checked_out_at) }
          # column("Total")                   {|order| number_to_currency order.total_price }
        end
      end
    end
  end

  sidebar "User Details", :only => :show do
    attributes_table_for user, :name, :uname, :sex, :dob, :country, :state, :city, :email, :created_at
  end

end
