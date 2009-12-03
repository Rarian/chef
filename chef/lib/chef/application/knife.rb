#
# Author:: Adam Jacob (<adam@opscode.com)
# Copyright:: Copyright (c) 2009 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require 'chef/knife'
require 'chef/application'
require 'chef/client'
require 'chef/config'
require 'chef/log'
require 'chef/node'
require 'chef/role'
require 'chef/data_bag'
require 'chef/data_bag_item'
require 'chef/rest'
require 'chef/search/query'
require 'tmpdir'
require 'uri'

class Chef::Application::Knife < Chef::Application

  banner "Usage: #{$0} sub-command (options)"

  option :config_file, 
    :short => "-c CONFIG",
    :long  => "--config CONFIG",
    :default => "/etc/chef/client.rb",
    :description => "The configuration file to use"

  option :log_level, 
    :short        => "-l LEVEL",
    :long         => "--log_level LEVEL",
    :description  => "Set the log level (debug, info, warn, error, fatal)",
    :default      => :info,
    :proc         => lambda { |l| l.to_sym }

  option :log_location,
    :short        => "-L LOGLOCATION",
    :long         => "--logfile LOGLOCATION",
    :description  => "Set the log file location, defaults to STDOUT",
    :proc         => nil

  option :editor,
    :short        => "-e EDITOR",
    :long         => "--editor EDITOR",
    :description  => "Set the editor to use for interactive commands",
    :default      => ENV['EDITOR']

  option :help,
    :short        => "-h",
    :long         => "--help",
    :description  => "Show this message",
    :on           => :tail,
    :boolean      => true,
    :show_options => true,
    :exit         => 0
    
  option :node_name,
    :short => "-u USER",
    :long => "--user USER",
    :description => "API Client Username, defaults to OPSCODE_USER",
    :default => ENV['OPSCODE_USER']

  option :client_key,
    :short => "-k KEY",
    :long => "--key KEY",
    :description => "API Client Key, defaults to OPSCODE_KEY",
    :default => ENV['OPSCODE_KEY']

  option :yes,
    :short => "-y",
    :long => "--yes",
    :description => "Say yes to all prompts for confirmation"

  option :print_after,
    :short => "-p",
    :long => "--print-after",
    :description => "Show the data after a destructive operation"
  
  option :version,
    :short        => "-v",
    :long         => "--version",
    :description  => "Show chef version",
    :boolean      => true,
    :proc         => lambda {|v| puts "Chef: #{::Chef::VERSION}"},
    :exit         => 0

  # Run knife 
  def run
    if ARGV[0] =~ /^-/
      self.parse_options
      Chef::Log.fatal("Sorry, you need to pass a sub-command first!") 
      puts self.opt_parser
      puts
      Chef::Knife.list_commands
      exit 2
    elsif ARGV.length == 0
      self.parse_options
      puts self.opt_parser
      puts
      Chef::Knife.list_commands
      exit 1 
    end

    knife = Chef::Knife.find_command(ARGV, self.class.options)
    knife.run
  end
end
