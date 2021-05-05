# Copyright, 2021, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require_relative 'backend/select'

module Event
	module Backend
		def self.default(env = ENV)
			if backend = env['EVENT_BACKEND']&.to_sym
				if Event::Backend.const_defined?(backend)
					return Event::Backend.const_get(backend)
				else
					warn "Could not find EVENT_BACKEND=#{backend}!"
				end
			end
			
			if self.const_defined?(:URing)
				return Event::Backend::URing
			elsif self.const_defined?(:KQueue)
				return Event::Backend::KQueue
			elsif self.const_defined?(:EPoll)
				return Event::Backend::EPoll
			else
				return Event::Backend::Select
			end
		end
		
		def self.new(...)
			default.new(...)
		end
	end
end
