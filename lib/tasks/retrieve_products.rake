namespace :mpx do
  desc 'Retrieve products from MPX'
  task retrieve_products: :environment do
    RetrieveProducts.build.call
  end
end
