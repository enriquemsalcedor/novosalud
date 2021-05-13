class AddFileToPaymentTransferences < ActiveRecord::Migration[5.0]
  def change
    add_attachment :payment_transferences, :file
  end
end
