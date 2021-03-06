module ApplicationHelper
  def plans_display_link(plan_id)
    link = link_to "Sign up", new_user_registration_path, class: "btn btn-success"
    if current_user.try(:customer?)
      if plan_id == 1 && current_user.try(:trial_user?)
        link = link_to "Start Free 30 Day Trial", subscriptions_path(plan_id: plan_id), method: :post, class: "btn btn-success", data: { "no-turbolink" => true, disable_with: "Subscribing..."}
      else
        link = link_to "Subscribe", subscriptions_path(plan_id: plan_id), method: :post, class: "btn btn-success", data: { "no-turbolink" => true, disable_with: "Subscribing..."}
      end
    elsif current_user
      link = link_to "Add Billing Info to Subscribe", new_customer_path, class: "btn btn-success", data: { "no-turbolink" => true }
    elsif plan_id == 1
      link = link_to "Start Free 30 Day Trial", new_user_registration_path, class: "btn btn-success"
    end
    link
  end
end