module Fastlane
  module Actions
    class BumpAndroidVersionAction < Action
      def self.run(params)
        UI.message("Bumping version code and version name for Android Manifest at #{File.absolute_path(params[:manifest_path])}")

        IO.write(File.absolute_path(params[:manifest_path]), File.open(File.absolute_path(params[:manifest_path])) do |f|
          manifest = f.read
          version_code = /android:versionCode=\"(\d+)\"/.match(manifest)[1].to_i
          UI.message("Bumping version code from #{version_code} to #{version_code + 1}")
          manifest.gsub!(/android:versionCode=\"\d+\"/, "android:versionCode=\"#{version_code + 1}\"")
          manifest
        end)
        if params[:bump_version_code] then
          IO.write(File.absolute_path(params[:manifest_path]), File.open(File.absolute_path(params[:manifest_path])) do |f|
            manifest = f.read
            require 'sem_version'
            version_name = SemVersion.new(/android:versionName=\"(\bv?(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)(?:-[\da-z\-]+(?:\.[\da-z\-]+)*)?(?:\+[\da-z\-]+(?:\.[\da-z\-]+)*)?\b)\"/.match(manifest)[1])
            bumped_version = version_name.clone
            bumped_version.patch = (bumped_version.patch + 1)
            UI.message("Bumping version code from #{version_name} to #{bumped_version}")
            manifest.gsub!(/android:versionName=\"(\bv?(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)\.(?:0|[1-9]\d*)(?:-[\da-z\-]+(?:\.[\da-z\-]+)*)?(?:\+[\da-z\-]+(?:\.[\da-z\-]+)*)?\b)\"/, "android:versionName=\"#{bumped_version}\"")
            manifest
          end)
        end
      end

      def self.description
        "Bump Android Manifest Version"
      end

      def self.authors
        ["Seán Labastille"]
      end

      def self.return_value
        # If your method provides a return value, you can describe here what it does
      end

      def self.details
        # Optional:
        "Bumps the versionCode or versionName in AndroidManifest.xml"
      end

      def self.available_options
        [
          FastlaneCore::ConfigItem.new(key: :bump_version_code,
          env_name: "BUMP_ANDROID_VERSION_NAME",
       description: "If the version name should be bumped",
          optional: true),
          FastlaneCore::ConfigItem.new(key: :manifest_path,
                                  env_name: "BUMP_ANDROID_VERSION_MANIFEST_PATH",
                               description: "The path to the AndroidManifest.xml to be bumped",
                                  optional: false,
                                      type: String)
        ]
      end

      def self.is_supported?(platform)
        [:android].include?(platform)
      end
    end
  end
end
