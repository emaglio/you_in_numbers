PDFKit.configure do |config|
  config.default_options[:quiet] = false
  config.default_options = {
    :encoding => "UTF-8",
    :page_size => "Ledger",
    :zoom => '1.3',
    :disable_smart_shrinking => false
  }
  # Use only if your external hostname is unavailable on the server.
  config.root_url = "http://localhost"
  config.verbose = false
end
