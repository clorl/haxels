local overseer = require("overseer")

overseer.register_template({
	name = "Build",
	builder = function(params)
		return {
			name = "Build",
			cmd = { "haxe", "build.hxml" },
			components = {
				"default",
				"on_exit_set_status"
			}
		}
	end
})


overseer.register_template({
	name = "Run",
	builder = function(params)
		return {
			name = "Run",
			cmd = { "hl", "build.hl" },
			components = {
				"default",
				"on_exit_set_status"
			}
		}
	end
})


overseer.register_template({
	name = "Build and Run",
	builder = function(params)
		return {
			name = "Build and Run",
			strategy = {
				"orchestrator",
			tasks = {
				"haxe build.hxml",
				"hl build.hl"
			}
		},
			components = {
				"default",
				"on_exit_set_status"
			}
		}
	end
})
