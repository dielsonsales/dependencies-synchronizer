require 'spec_helper'
require_relative '../../lib/dependencies_synchronizer/dependency_store'
require_relative '../../lib/dependencies_synchronizer/updater/podfile_updater'

describe DependenciesSynchronizer::Updater::PodfileUpdater do
  let(:store) do
    double('DependencyStore', version_for: '9.9.9')
  end

  let(:original_podfile) do
    <<~PODFILE
      pod 'SAAnalytics', '1.0.0'
      pod 'SANetwork', '1.1.5'
    PODFILE
  end

  def with_temp_podfile(content)
    file = Tempfile.new('Podfile')
    file.write(content)
    file.rewind
    yield file.path
    file.rewind
    file.read
  ensure
    file.close
    file.unlink
  end

  it 'updates version of dependencies if found in store' do
    allow(store).to receive(:version_for).with('SAAnalytics').and_return('2.0.0')
    allow(store).to receive(:version_for).with('SANetwork').and_return('1.1.5')

    with_temp_podfile(original_podfile) do |path|
      described_class.new(store).update(path)
      updated = File.read(path)

      expect(updated).to include("pod 'SAAnalytics', '2.0.0'")
      expect(updated).to include("pod 'SANetwork', '1.1.5'")
    end
  end
end
