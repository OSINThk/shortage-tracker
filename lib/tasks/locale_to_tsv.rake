require 'yaml'

desc "Generate a unified locale comparison tsv."
task :locale_to_tsv do
  process()
end

def process
  output = {}

  locales = [
    './config/locales/devise-i18n.en.yml',
    './config/locales/devise.en.yml',
    './config/locales/devise-i18n.zh-CN.yml',
    './config/locales/devise.zh-CN.yml',
    './config/locales/devise-i18n.zh-HK.yml',
    './config/locales/devise.zh-HK.yml',
    './config/locales/devise-i18n.zh-TW.yml',
    './config/locales/devise.zh-TW.yml'
  ]

  locales.each_with_index do |filepath, index|
    walk('', YAML.load_file(filepath)) do |path, value|
      output_key = path[/(?:\.[^\.]+\.)(.*)/, 1]
      output[output_key] ||= []
      output[output_key][index] = value
    end
  end

  puts "KEY\t#{locales.join("\t")}"
  output.each do |key, values|
    puts "#{key}\t#{values.join("\t")}"
  end
end

def walk(path, object, &block)
  case object
    when Hash
      object.each {|key, value| walk("#{path}.#{key}", value, &block) }
    when Array
      object.each_with_index {|value, key| walk("#{path}.#{key}", value, &block) }
    else
      block.call(path, object)
  end
end
