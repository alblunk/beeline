class FixDescription2 < ActiveRecord::Migration
	def change
	change_column :products, :description, :text, :limit => nil
	end
end
