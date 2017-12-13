describe Fastlane::Actions::BumpAndroidVersionAction do
  describe '#run' do
    it 'prints a message' do
      expect(Fastlane::UI).to receive(:message).with("The bump_android_version plugin is working!")

      Fastlane::Actions::BumpAndroidVersionAction.run(nil)
    end
  end
end
