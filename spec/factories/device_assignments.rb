FactoryBot.define do
  factory :device_assignment do
    device
    user
    assigned_at { Time.current }
    returned_at { nil }
  end
end