require 'csv'

class Api::V1::CartReportController < ApplicationController
  before_action :authorized, except: [:index, :show]

  def create
    response = generate_direct_upload(blob_params)
    render json: response
  end

  def export
    # @cart = Cart.where(user_id: current_user.id).as_json(include: {cart_items: {include: :item}})
    @cart = Cart.find_by(user_id: current_user.id)
    
    cart_info = []
    items = []

    @cart.cart_items.each do |cart_item| 
        items.push(cart_item.item.name)
    end

    cart_info.push(current_user.name, current_user.surname, @cart.total_price, items.join(", "), @cart.updated_at)

    headers = ["Name", "Surname", "Total Price", "Items", "Last Updated"]
    CSV.open("shopping_cart.csv", "w") do |csv|
        csv << headers
        csv << cart_info
    end
  end

#   private
#   def blob_params
#     params.require(:file).permit(:filename, :byte_size, :checksum, :content_type, metadata: {})
#   end

#   def generate_direct_upload(blob_args)
#     blob = create_blob(blob_args)
#     response = signed_url(blob)
#     response[:blob_signed_id] = blob.signed_id
#     response
#   end

#   def create_blob(blob_args)
#     blob = ActiveStorage::Blob.create_before_direct_upload!(blob_args.to_h.deep_symbolize_keys)
#     report_id = SecureRandom.uuid # the name of the file will just be a UUID
#     blob.update_attribute(:key, "uploads/#{report_id}") # will put it in the uploads folder
#     blob
#   end

#   def signed_url(blob)
#     expiration_time = 10.minutes
#     response_signature(
#       blob.service_url_for_direct_upload(expires_in: expiration_time),
#       headers: blob.service_headers_for_direct_upload
#     )
#   end

#   def response_signature(url, **params)
#     {
#       direct_upload: {
#         url: url
#       }.merge(params)
#     }
#   end
end
