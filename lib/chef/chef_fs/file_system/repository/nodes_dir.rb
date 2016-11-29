#
# Author:: John Keiser (<jkeiser@chef.io>)
# Author:: Ho-Sheng Hsiao (<hosh@chef.io>)
# Copyright:: Copyright 2012-2016, Chef Software Inc.
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

require "chef/chef_fs/file_system/repository/node"
require "chef/chef_fs/file_system/repository/directory"
require "chef/chef_fs/file_system/exceptions"
require "chef"

class Chef
  module ChefFS
    module FileSystem
      module Repository
        class NodesDir < Repository::Directory

          def make_child_entry(child_name)
            Node.new(child_name, self)
          end

          def create_child(child_name, file_contents = nil)
            child = super
            events = Chef::EventDispatch::Dispatcher.new
            node = Chef::Node.new
            run_context = Chef::RunContext.new(node, {}, events)
            file = Chef::Resource::File.new(child.file_path, run_context)
            file.mode(0600) unless Chef::Platform.windows?
            file.rights([:read, :write], ENV["USERNAME"]) if Chef::Platform.windows?
            file.inherits(false) if Chef::Platform.windows?
            file.run_action(:create)
            child
          end
        end
      end
    end
  end
end
