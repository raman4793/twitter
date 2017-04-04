ActiveAdmin.register_page "Dashboard" do

  menu priority: 1, label: proc{ I18n.t("active_admin.dashboard") }

  content title: proc{ I18n.t("active_admin.dashboard") } do
    # div class: "blank_slate_container", id: "dashboard_default_message" do
    #   span class: "blank_slate" do
    #     span I18n.t("active_admin.dashboard_welcome.welcome")
    #     small I18n.t("active_admin.dashboard_welcome.call_to_action")
    #   end
    # end

    columns do

      column do
        panel "Recent Posts" do
          table_for Micropost.limit(10) do
            column("Post")   {|post| post.content.html_safe                                    }
            column("User"){|post| link_to(post.user.name, admin_user_path(post.user)) }
            column("Likes")   {|post| post.get_likes                       }
          end
        end
      end

      column do
        panel "Recent Users" do
          table_for User.order('created_at desc').limit(10).each do |customer|
            column(:email)    {|customer| link_to(customer.email, admin_user_path(customer)) }
          end
        end
      end

    end # columns

    columns do

      column do
        panel "Place Holder" do
          div do
            render partial: 'admin/partials/report'
          end
        end
      end

      column do
        panel "User Activity" do
          div do
            render partial: 'admin/partials/user_activity'
          end
        end
      end

    end # columns

    # section "Graphs" do
    #
    # end
    #
    # content do
    #   para "Hello World"
    # end

    # Here is an example of a simple dashboard with columns and panels.
    #
    # columns do
    #   column do
    #     panel "Recent Posts" do
    #       render partial: 'admin/report'
    #     end
    #   end
    #
    #   column do
    #     panel "Info" do
    #       para "Welcome to ActiveAdmin."
    #     end
    #   end
    # end
  end # content
end
