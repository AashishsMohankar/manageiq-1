FactoryBot.define do
  factory :load_balancer_pool_member do
    sequence(:ems_ref) { |n| "ems_ref_#{seq_padded_for_sorting(n)}" }
  end

  factory :load_balancer_pool_member_alibaba,
          :class  => "ManageIQ::Providers::Alibaba::NetworkManager::LoadBalancerPoolMember",
          :parent => :load_balancer_pool_member
end
