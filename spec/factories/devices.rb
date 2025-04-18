# frozen_string_literal: true

FactoryBot.define do
  factory :device do
    sequence(:serial_number) { |n| "SN-#{format('%06d', n)}" }
    user { nil }
  end
end