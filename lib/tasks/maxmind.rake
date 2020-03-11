require 'download'
require 'untar'

desc "Download maxmind geoip databases"
task :maxmind do
  download_database('ASN')
  download_database('City')
end

def download_database(type)
  working_dir = Rails.root.join("tmp")
  output_file_path = File.join(working_dir, "tmp.tar.gz")

  download(
    "https://download.maxmind.com/app/geoip_download?edition_id=GeoLite2-#{type}&license_key=#{ENV.fetch('MAXMIND_LICENSE_KEY', '')}&suffix=tar.gz",
    output_file_path
  )

  paths = untar(
    output_file_path,
    working_dir
  )

  database_path_index = paths.index { |path| path.end_with?(".mmdb") }
  database_path = paths[database_path_index]
  database_filename = File.basename(database_path)

  File.rename(database_path, Rails.root.join(database_filename))

  paths.delete_at(database_path_index)
  paths.push(output_file_path)
  paths.reverse_each { |path| File.directory?(path) ? Dir.rmdir(path) : File.delete(path) }
end
