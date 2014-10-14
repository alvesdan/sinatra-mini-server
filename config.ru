require 'rubygems'
require 'bundler'
require 'sinatra'
require 'json'
require 'faker'
require './app'

Bundler.require(:default)
run MiniServerApp
