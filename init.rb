# Include hook code here
require 'request_sentry'

ActionController::Base.send(:include, RequestSentry)