require 'csv'
require 'aws-sdk-s3'

class Api::V1::CartReportController < ApplicationController
  before_action :authorized

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

    storage_url = "storage/cart-#{current_user.id}.csv"

    csv_report = CSV.generate do |csv|
      csv << headers
      csv << cart_info
    end

    bucket_name = Rails.application.credentials.dig(:aws, :bucket)
    region = "eu-central-1"
 
    s3_client = Aws::S3::Client.new(
    region: region,
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),)
  
    if report_uploaded?(s3_client, csv_report, bucket_name, "cart-#{current_user.id}-#{current_user.name}-#{current_user.surname}.csv")
      puts "Report uploaded."
    else
      puts "Report not uploaded."
    end
  end

  def download
    bucket_name = Rails.application.credentials.dig(:aws, :bucket)
    region = "eu-central-1"

    s3_client = Aws::S3::Client.new(
    region: region,
    access_key_id: Rails.application.credentials.dig(:aws, :access_key_id),
    secret_access_key: Rails.application.credentials.dig(:aws, :secret_access_key),)
    
    if report_retrieved?(s3_client, bucket_name, "cart-#{current_user.id}-#{current_user.name}-#{current_user.surname}.csv")
      puts "Report retrieved."
    else
      puts "Report not retrieved."
    end
  end

  private

  def report_uploaded?(s3_client, document, bucket_name, object_key)
    response = s3_client.put_object(
      bucket: bucket_name,
      body: document,
      key: object_key
    )
    
    if response.etag
      return true
    else
      return false
    end
    rescue StandardError => e
      puts "Error uploading object: #{e.message}"
      return false
  end

  def report_retrieved?(s3_client, bucket_name, object_key)
    
    # table = CSV.parse(File.read(
    #   s3_client.get_object(
    #     bucket: bucket_name,
    #     key: object_key
    #   )
    # )) 

    data = s3_client.get_object(
      bucket: bucket_name,
      key: object_key
    ).body.string

    report_csv = CSV.parse(data, headers: true).map(&:to_h)

    render json: report_csv.to_json
    
    return true
    # if response.etag
    #   return true
    # else
    #   return false
    # end
  rescue StandardError => e
    puts "Error retrieving object: #{e.message}"
    return false
  end
end