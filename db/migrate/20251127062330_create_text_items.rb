class CreateTextItems < ActiveRecord::Migration[7.1]
  def change
    create_table :text_items do |t|

      t.timestamps
    end
  end
end
