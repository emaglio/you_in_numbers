class InitiateDatabase < ActiveRecord::Migration[4.2]
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
      t.boolean :admin

      t.timestamps
    end

    create_table :subjects do |t|
      t.integer :user_id
      t.string :email
      t.string :firstname
      t.string :lastname
      t.datetime :dob
      t.string :phone
      t.string :gender
      t.integer :height
      t.integer :weight
      t.text :content

      t.timestamps
    end

    create_table :reports do |t|
      t.integer :user_id
      t.integer :subject_id
      t.string :title
      t.text :cpet_params
      t.text :cpet_results
      t.text :rmr_params
      t.text :rmr_results
      t.text :header
      t.text :subject
      t.text :content

      t.timestamps
    end

    create_table :companies do |t|
      t.integer :user_id
      t.string :name
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :postcode
      t.string :country
      t.string :phone
      t.string :email
      t.string :website
      t.text :content

      t.text :logo_meta_data

      t.timestamps
    end

    add_index :companies, :user_id
    add_index :reports, :user_id
    add_index :subjects, :user_id
  end
end
