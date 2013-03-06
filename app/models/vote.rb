class VoteValidator < ActiveModel::Validator
  MAX_VOTES = 5

  def validate(record)
    return unless record.voter_type == 'User'

    user = record.voter_id
    record.errors.add(:voter_id, "Out of votes") if Vote.where(voter_type: 'User', voter_id: user).count > MAX_VOTES
  end
end

class Vote < ActiveRecord::Base
  include ActiveModel::Validations
  validates_with VoteValidator

  scope :for_voter, lambda { |*args| where(["voter_id = ? AND voter_type = ?", args.first.id, args.first.class.base_class.name]) }
  scope :for_voteable, lambda { |*args| where(["voteable_id = ? AND voteable_type = ?", args.first.id, args.first.class.base_class.name]) }
  scope :recent, lambda { |*args| where(["created_at > ?", (args.first || 2.weeks.ago)]) }
  scope :descending, order("created_at DESC")

  belongs_to :voteable, :polymorphic => true
  belongs_to :voter, :polymorphic => true

  attr_accessible :vote, :voter, :voteable


  # Comment out the line below to allow multiple votes per user.
  validates_uniqueness_of :voteable_id, :scope => [:voteable_type, :voter_type, :voter_id]
end