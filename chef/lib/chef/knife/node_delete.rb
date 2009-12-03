#
# Author:: Adam Jacob (<adam@opscode.com>)
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
#

require 'chef/knife'
require 'chef/node'
require 'json'

class Chef
  class Knife
    class NodeDelete < Knife

      banner "Sub-Command: node delete NODE (options)"

      def run 
        confirm("Do you really want to delete #{@name_args[0]}")
       
        node = Chef::Node.load(@name_args[0])
        node.destroy
        
        json_pretty_print(format_for_display(node)) if config[:print_after]

        Chef::Log.warn("Deleted node #{@name_args[0]}!")
      end

    end
  end
end



