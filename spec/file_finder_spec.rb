require 'spec_helper'
require_relative '../lib/dependencies_synchronizer/file_finder'

describe DependenciesSynchronizer::FileFinder do
  it 'finds dependency files in given directory' do
    Dir.mktmpdir do |dir|
      File.write(File.join(dir, 'Podfile'), '')
      File.write(File.join(dir, 'MyModule.podspec'), '')
      File.write(File.join(dir, 'Package.swift'), '')

      finder = described_class.new(dir)
      files = finder.all_dependency_files

      expect(files.size).to eq(3)
    end
  end
end
