class TextItem < ApplicationRecord
  has_one_attached :text_file
  has_one_attached :audio_file

  validates :text_file, presence: true
end
