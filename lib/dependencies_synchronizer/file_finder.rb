module DependenciesSynchronizer
  # Responsible for locating the module’s Podfile, Package.swift and .podspec files
  class FileFinder
    FILE_PATTERNS = [
      'Podfile',
      '*.podspec',
      'Package.swift'
    ].freeze

    # @param root [String] the root directory of your module (e.g. Dir.pwd)
    def initialize(root = Dir.pwd)
      @root = File.expand_path(root)
    end

    # @return [Array<String>] absolute file paths to all dependency-related files under modules/
    def all_dependency_files
      FILE_PATTERNS.flat_map do |pattern|
        Dir.glob(File.join(@root, pattern))
      end
    end

    # (optional helpers, if you still want them)
    def find_podfile
      all_dependency_files.select { |f| File.basename(f) == 'Podfile' }
    end

    def find_podspecs
      all_dependency_files.select { |f| f.end_with?('.podspec') }
    end

    def find_package_swift
      all_dependency_files.select { |f| File.basename(f) == 'Package.swift' }
    end
  end
end
