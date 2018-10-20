class Vote::Negative < Vote

  def self.votable_classes
    []
  end

  def self.can_be_cast_by?(user, votable)
    # Anything that is votable can have a negative vote
    true
  end

  def name_as_string
    name || "Negative"
  end
end
