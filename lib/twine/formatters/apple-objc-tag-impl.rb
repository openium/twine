require 'pathname'

module Twine
  module Formatters
    class AppleObjCTagImpl < Abstract
      include Twine::Placeholders

      attr_accessor :stringFileName

      def format_name
        'apple-objc-tag-impl'
      end
      
      def extension
        '.m'
      end

      def self.can_handle_directory?(path)
        true
      end

      def default_file_name
        return 'R2Tag+TxtFileName.m'
      end

      def determine_language_given_path(path)
        raise 'not going to implement'
      end

      def format_file(lang)
        filePath = Pathname.new(@options[:output_path])
        self.stringFileName = filePath.basename.to_s[0..-4]
        impl = "R2Tag+" + self.stringFileName + ".m"
        @options[:output_path] = filePath.dirname + impl
        result = super + "\n\n@end\n"
      end

      def format_header(lang)
        %(/**
 * Impl File
 * Generated by Twine #{Twine::VERSION}
 */

#import "R2Tag+#{stringFileName}.h"

@implementation R2Tag \(#{stringFileName}\))
      end

      def format_section_header(section)
        "#pragma mark - #{section.name}"
      end

      def key_value_pattern
        %(\n- (NSString *)%{key}
{
    return @"%{value}";
})
      end

      def format_comment(definition, lang)
        ""
      end

    end
  end
end

Twine::Formatters.formatters << Twine::Formatters::AppleObjCTagImpl.new
