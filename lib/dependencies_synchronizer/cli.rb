# frozen_string_literal: true

require 'optparse'
require 'yaml'
require_relative 'dependency_store'
require_relative 'file_finder'
require_relative 'find_card'
require_relative 'logger'

module DependenciesSynchronizer
  class CLI
    USAGE = <<~USAGE
      Usage: dependencies-synchronizer [options]

      Options:
          -d, --dir DIR                  Path to your main application root (overrides config)
          -h, --help                     Show this help message
    USAGE

    def self.start(argv = [])
      options = {}
      parser  = OptionParser.new do |opts|
        opts.banner = USAGE

        opts.on('-dDIR', '--dir=DIR', 'Path to your main application root') do |dir|
          options[:dir] = dir
        end

        opts.on('-h', '--help', 'Show this help message') do
          puts opts
          exit
        end

        opts.on('--verbose', 'Enable debug logging') do
          DependenciesSynchronizer::Logger.level = :debug
        end

        opts.on('--info', 'Enable info-level logging') do
          DependenciesSynchronizer::Logger.level = :info
        end
      end

      begin
        parser.parse!(argv)
      rescue OptionParser::InvalidOption => e
        warn e.message
        puts parser
        exit 1
      end

      # Load or initialize configuration
      config_path = File.expand_path('~/.dependencies_sync.yml')
      unless File.exist?(config_path)
        puts 'Configuration file not found. Let’s create one.'
        print 'Enter the full path to your main application directory: '
        main_dir = STDIN.gets.chomp
        File.write(config_path, { 'main_app_dir' => main_dir }.to_yaml)
        puts "Saved configuration to #{config_path}"
      end

      config = YAML.load_file(config_path)
      main_app_dir = options[:dir] || config['main_app_dir']
      unless main_app_dir && Dir.exist?(main_app_dir)
        abort "❌ Could not find main app directory at #{main_app_dir.inspect}"
      end

      # 1) Display discovered dependencies
      puts "\n✅ Reading dependencies from main app at #{main_app_dir}\n"
      DependenciesSynchronizer::FindCard.display_dependencies(main_app_dir)

      # 2) Locate Core.rb
      core_rb = Dir.glob(File.join(main_app_dir, '**', 'Core.rb')).first
      unless core_rb
        abort "❌ No Core.rb found under #{main_app_dir}"
      end

      # 3) Build the dependency store
      store = DependenciesSynchronizer::DependencyStore.new(core_rb)

      # 4) Require all updater classes
      Dir[File.join(__dir__, 'updater', '*.rb')].sort.each { |f| require f }

      # 5) Find and update module dependency files
      finder = DependenciesSynchronizer::FileFinder.new(Dir.pwd)
      files = finder.all_dependency_files
      if files.empty?
        puts 'No Podfile, .podspec, or Package.swift files found in module.'
        return
      end

      puts "\n🔄 Updating dependency files in module..."
      files.each do |path|
        case File.basename(path)
        when 'Podfile'
          DependenciesSynchronizer::Updater::PodfileUpdater.new(store).update(path)
        when /\.podspec$/
          DependenciesSynchronizer::Updater::PodspecUpdater.new(store).update(path)
        when 'Package.swift'
          DependenciesSynchronizer::Updater::PackageSwiftUpdater.new(store).update(path)
        else
          next
        end
        puts "✔ Updated #{path}"
      end

      puts "\n🎉 All done! Your module’s dependencies are now in sync."
    end
  end
end

# Allow running without subcommand:
if __FILE__ == $PROGRAM_NAME
  DependenciesSynchronizer::CLI.start(ARGV)
end
