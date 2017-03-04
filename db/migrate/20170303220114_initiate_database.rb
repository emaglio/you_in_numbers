class InitiateDatabase < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :age
      t.string :phone
      t.string :gender
      t.text :auth_meta_data
      t.boolean :block
      t.text :content

      t.timestamps
    end

    create_table :reports do |t|
      t.string :title
      t.text :content

      t.timestamps
    end
  end
end
