class TextItem < ApplicationRecord
  has_one_attached :text_file
  has_one_attached :auto_file
end
