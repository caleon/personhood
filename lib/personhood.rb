require 'active_record'
require 'active_support/concern'
require 'active_support/core_ext/object/blank'
require 'active_support/core_ext/class/attribute'
require 'juscribe/display_optional'
require 'juscribe/name'
require 'juscribe/personhood'
require 'juscribe/tos_acceptable'

ActiveRecord::Base.send(:include, Juscribe::DisplayOptional)
