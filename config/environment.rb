# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Fbli::Application.initialize!

#
## Fix incompatible character encodings: UTF-8 and ASCII-8BIT
#Encoding.default_external = Encoding::UTF_8
#Encoding.default_internal = Encoding::UTF_8

EMAIL = "whowish@gmail.com"

