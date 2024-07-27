# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'
Bundler.require

require_relative './app'
run App.freeze.app
