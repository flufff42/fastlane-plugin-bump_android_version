module Fastlane
  module Helper
    class BumpAndroidVersionHelper
      # class methods that you define here become available in your action
      # as `Helper::BumpAndroidVersionHelper.your_method`
      #
      def self.show_message
        UI.message("Hello from the bump_android_version plugin helper!")
      end
    end
  end
end
