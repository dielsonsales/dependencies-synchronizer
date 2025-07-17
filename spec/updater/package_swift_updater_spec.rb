require 'spec_helper'
require_relative '../../lib/dependencies_synchronizer/updater/package_swift_updater'

describe DependenciesSynchronizer::Updater::PackageSwiftUpdater do
  let(:store) do
    double('DependencyStore')
  end

  let(:original_package_swift) do
    <<~SWIFT
      .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-saanalytics.git", exact: "1.0.0")
      .product(name: "SAAnalytics", package: "org-ml1-dep-ios-saanalytics"),
      .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-sanetwork.git", exact: "1.1.5")
      .product(name: "SANetwork", package: "org-ml1-dep-ios-sanetwork")
    SWIFT
  end

  def with_temp_package_swift(content)
    file = Tempfile.new('Package.swift')
    file.write(content)
    file.rewind
    yield file.path
    file.rewind
    file.read
  ensure
    file.close
    file.unlink
  end

  it 'updates exact version of dependencies in Package.swift' do
    allow(store).to receive(:version_for).with('SAAnalytics').and_return('2.0.0')
    allow(store).to receive(:version_for).with('SANetwork').and_return('1.1.5')

    with_temp_package_swift(original_package_swift) do |path|
      described_class.new(store).update(path)
      updated = File.read(path)

      expect(updated).to include("exact: \"2.0.0\"")
      expect(updated).to include("exact: \"1.1.5\"")
    end
  end

  it 'updates from version of dependencies in Package.swift while preserving from:' do
    content_with_from = <<~SWIFT
      .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-sanetwork.git", from: "1.1.5")
      .product(name: "SANetwork", package: "org-ml1-dep-ios-sanetwork")
    SWIFT

    allow(store).to receive(:version_for).with('SANetwork').and_return('2.5.0')

    with_temp_package_swift(content_with_from) do |path|
      described_class.new(store).update(path)
      updated = File.read(path)

      expect(updated).to include('from: "2.5.0"')
      expect(updated).to_not include('exact: "2.5.0"')  # Ensures from: was preserved
    end
  end

  it 'does not alter package entries with unknown constraint types' do
    content_with_branch = <<~SWIFT
      .package(url: "https://github.com/YourOrg/org-ml1-dep-ios-saanalytics.git", branch: "develop")
      .product(name: "SAAnalytics", package: "org-ml1-dep-ios-saanalytics")
    SWIFT

    allow(store).to receive(:version_for).with('SAAnalytics').and_return('2.0.0')

    with_temp_package_swift(content_with_branch) do |path|
      original_content = File.read(path)
      described_class.new(store).update(path)
      updated_content = File.read(path)

      expect(updated_content).to eq(original_content) # Unchanged
    end
  end
end

