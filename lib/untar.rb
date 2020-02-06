require 'rubygems/package'
require 'zlib'

TAR_LONGLINK = '././@LongLink'

def untar(file, destination)
  paths = [];

  Gem::Package::TarReader.new( Zlib::GzipReader.open file ) do |tar|
    dest = nil
    tar.each do |entry|
      if entry.full_name == TAR_LONGLINK
        dest = File.join destination, entry.read.strip
        next
      end
      dest ||= File.join destination, entry.full_name
      if entry.directory?
        paths << dest
        File.delete dest if File.file? dest
        FileUtils.mkdir_p dest, :mode => entry.header.mode, :verbose => false
      elsif entry.file?
        paths << dest
        FileUtils.rm_rf dest if File.directory? dest
        File.open dest, "wb" do |f|
          f.print entry.read
        end
        FileUtils.chmod entry.header.mode, dest, :verbose => false
      elsif entry.header.typeflag == '2' #Symlink!
        paths << dest
        File.symlink entry.header.linkname, dest
      end
      dest = nil
    end
  end

  return paths
end
