# A Liquid tag for Jekyll sites that allows embedding processing.js sketches.
# It fetches the script source and embeds it in the page, so you don't have to
# worry about cross-site scripting security issues.
#
# by: Zach Denton
# 
# Example usage: {% processingjs /plasma.pde %}

module Jekyll
	class ProcessingJsTag < Liquid::Tag
		def initialize(tag_name, text, token)
			super
			@url = text
		end

		def render(context)
      "<canvas data-processing-sources='#{@url}'></canvas>"
		end
  end
end

Liquid::Template.register_tag('processingjs', Jekyll::ProcessingJsTag)
