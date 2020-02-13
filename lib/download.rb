require 'net/http'

def download(uri, output_path)
  if (!uri.is_a?(URI))
    uri = URI(uri)
  end

  in_memory_representation = Net::HTTP.get(uri)

  File.open(output_path, 'wb') do |file|
    file.write(in_memory_representation)
  end

  return nil
end
