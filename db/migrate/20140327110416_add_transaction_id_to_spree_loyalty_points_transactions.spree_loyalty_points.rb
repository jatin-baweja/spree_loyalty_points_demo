# This migration comes from spree_loyalty_points (originally 20140205111553)
class AddTransactionIdToSpreeLoyaltyPointsTransactions < ActiveRecord::Migration
  def change
    add_column :spree_loyalty_points_transactions, :transaction_id, :string
  end
end
