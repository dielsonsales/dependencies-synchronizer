require 'spec_helper'
require_relative '../../lib/dependencies_synchronizer/updater/podspec_updater'

describe DependenciesSynchronizer::Updater::PodspecUpdater do
  let(:store) do
    double('DependencyStore')
  end

  let(:original_podspec) do
    <<~PODSPEC
      s.dependency 'SAAnalytics', '~> 1.0'
      s.dependency 'SANetwork', '~> 1.1'
    PODSPEC
  end

  def with_temp_podspec(content)
    file = Tempfile.new('MyModule.podspec')
    file.write(content)
    file.rewind
    yield file.path
    file.rewind
    file.read
  ensure
    file.close
    file.unlink
  end

  it 'updates dependencies to pessimistic version constraints' do
    allow(store).to receive(:version_for).with('SAAnalytics').and_return('2.3.4')
    allow(store).to receive(:version_for).with('SANetwork').and_return('1.5.6')

    with_temp_podspec(original_podspec) do |path|
      described_class.new(store).update(path)
      updated = File.read(path)

      expect(updated).to include("s.dependency 'SAAnalytics', '~> 2.3'")
      expect(updated).to include("s.dependency 'SANetwork', '~> 1.5'")
    end
  end
end
