class TrackingEvent < ApplicationRecord
  belongs_to :package

  validates :status, presence: true
end
