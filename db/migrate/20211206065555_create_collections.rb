class CreateCollections < ActiveRecord::Migration[6.1]
  def change
    create_table :collections do |t|
      t.string :image_url
      t.string :discord_url
      t.string :twitter_username
      t.float :one_day_average_price
      t.float :seven_day_average_price

      t.timestamps
    end
  end
end
