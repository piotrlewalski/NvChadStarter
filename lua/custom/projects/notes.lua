local utils = require("custom.utils")
--local term = require("nvterm.terminal")

local function PrepareUnitTestTab()
	local log_path = "./data/unit.log"
	local tab_id
	local pass_regexp = vim.regex(".* PASS .* Waiting for file changes.*")
	local test_started_regexp = vim.regex(".*test-unit-watch.*")
	local test_rerun_regexp = vim.regex(".* RERUN .*")
	local test_error_regexp = vim.regex(".* FAIL .*")

	local function callback(content_lines)
		for i = #content_lines, 1, -1 do --iterate in reverse order to get the last status
			local line = content_lines[i]
			if pass_regexp:match_str(line) then
        --Print("Unit tests: pass")
				vim.api.nvim_tabpage_set_var(tab_id, "status_color", "HLSuccess")
				return
			elseif test_error_regexp:match_str(line) then
				--Print("Unit tests: error")
				vim.api.nvim_tabpage_set_var(tab_id, "status_color", "HLError")
				return
			elseif test_started_regexp:match_str(line) or test_rerun_regexp:match_str(line) then
				vim.api.nvim_tabpage_set_var(tab_id, "status_color", "HLWarning")
				return
			end
		end
	end

	vim.cmd("tabnew")
	tab_id = vim.api.nvim_get_current_tabpage()
	utils.WatchFile(log_path, callback)
	--term.new("horizontal")
	--vim.api.nvim_win_set_height(0, 10)
	--vim.cmd("normal G")
	--term.send("FORCE_COLOR=true npm run test-unit-watch | tee " .. log_path)
	vim.cmd("Terminal FORCE_COLOR=true npm run test-unit-watch | tee " .. log_path)

	utils.SwitchToFileWindow()
	vim.cmd("q")
end

local function PrepareBrowserTestTab()
	local log_path = "./data/browser.log"
	local tab_id
	local pass_regexp = vim.regex("Done, waiting for file changes.*")
	local test_started_regexp = vim.regex(".*npm run test-browser.*")
	local test_rerun_regexp = vim.regex(".* RERUN .*")
	local test_error_regexp = vim.regex(".*failed.*")

	local function callback(content_lines)
		for i = #content_lines, 1, -1 do --iterate in reverse order to get the last status
			local line = content_lines[i]
			if test_started_regexp:match_str(line) or test_rerun_regexp:match_str(line) then
        --Print("Browser tests: warning")
				vim.api.nvim_tabpage_set_var(tab_id, "status_color", "HLWarning")
				return
			elseif pass_regexp:match_str(line) then
        --Print("Browser tests: success")
				vim.api.nvim_tabpage_set_var(tab_id, "status_color", "HLSuccess")
				return
			elseif test_error_regexp:match_str(line) then
        --Print("Browser tests: error")
				vim.api.nvim_tabpage_set_var(tab_id, "status_color", "HLError")
				return
			end
		end
	end

	vim.cmd("tabnew")
	tab_id = vim.api.nvim_get_current_tabpage()
	utils.WatchFile(log_path, callback)
	--term.new("horizontal")
	--vim.api.nvim_win_set_height(0, 10)
	--vim.cmd("normal G")
	--term.send("npm run test-browser-watch | tee " .. log_path)
  vim.cmd("Terminal npm run test-browser-watch | tee " .. log_path)

	utils.SwitchToFileWindow()
	vim.cmd("q")
end

PrepareUnitTestTab()
PrepareBrowserTestTab()
utils.PrepareServerTab("npm run server")
--utils.PrepareServerTab("npm run hocuspocus")
utils.PrepareServerTab("npm run websocket")
utils.PrepareTerminalTab()

