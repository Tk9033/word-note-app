class StudyResult < ApplicationRecord
  belongs_to :study_session
  belongs_to :card
end
