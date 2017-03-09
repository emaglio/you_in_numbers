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
      t.text :cpet_params
      t.text :cpet_results
      t.text :rmr_params
      t.text :rmr_results
      t.text :header
      t.text :subject
      t.text :content

      t.timestamps
    end
  end
end
