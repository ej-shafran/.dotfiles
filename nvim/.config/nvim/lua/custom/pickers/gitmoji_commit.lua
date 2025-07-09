local M = {}

local finders = require "telescope.finders"
local pickers = require "telescope.pickers"
local actions = require "telescope.actions"
local action_state = require "telescope.actions.state"
local entry_display = require "telescope.pickers.entry_display"
local conf = require("telescope.config").values

local gitmojis = {
  { key = ":art:", emoji = "🎨", description = "Improve structure / format of the code." },
  { key = ":zap:", emoji = "⚡️", description = "Improve performance." },
  { key = ":fire:", emoji = "🔥", description = "Remove code or files." },
  { key = ":bug:", emoji = "🐛", description = "Fix a bug." },
  { key = ":ambulance:", emoji = "🚑️", description = "Critical hotfix." },
  { key = ":sparkles:", emoji = "✨", description = "Introduce new features." },
  { key = ":memo:", emoji = "📝", description = "Add or update documentation." },
  { key = ":rocket:", emoji = "🚀", description = "Deploy stuff." },
  { key = ":lipstick:", emoji = "💄", description = "Add or update the UI and style files." },
  { key = ":tada:", emoji = "🎉", description = "Begin a project." },
  { key = ":white_check_mark:", emoji = "✅", description = "Add, update, or pass tests." },
  { key = ":lock:", emoji = "🔒️", description = "Fix security or privacy issues." },
  { key = ":closed_lock_with_key:", emoji = "🔐", description = "Add or update secrets." },
  { key = ":bookmark:", emoji = "🔖", description = "Release / Version tags." },
  { key = ":rotating_light:", emoji = "🚨", description = "Fix compiler / linter warnings." },
  { key = ":construction:", emoji = "🚧", description = "Work in progress." },
  { key = ":green_heart:", emoji = "💚", description = "Fix CI Build." },
  { key = ":arrow_down:", emoji = "⬇️", description = "Downgrade dependencies." },
  { key = ":arrow_up:", emoji = "⬆️", description = "Upgrade dependencies." },
  { key = ":pushpin:", emoji = "📌", description = "Pin dependencies to specific versions." },
  { key = ":construction_worker:", emoji = "👷", description = "Add or update CI build system." },
  { key = ":chart_with_upwards_trend:", emoji = "📈", description = "Add or update analytics or track code." },
  { key = ":recycle:", emoji = "♻️", description = "Refactor code." },
  { key = ":heavy_plus_sign:", emoji = "➕", description = "Add a dependency." },
  { key = ":heavy_minus_sign:", emoji = "➖", description = "Remove a dependency." },
  { key = ":wrench:", emoji = "🔧", description = "Add or update configuration files." },
  { key = ":hammer:", emoji = "🔨", description = "Add or update development scripts." },
  { key = ":globe_with_meridians:", emoji = "🌐", description = "Internationalization and localization." },
  { key = ":pencil2:", emoji = "✏️", description = "Fix typos." },
  { key = ":poop:", emoji = "💩", description = "Write bad code that needs to be improved." },
  { key = ":rewind:", emoji = "⏪️", description = "Revert changes." },
  { key = ":twisted_rightwards_arrows:", emoji = "🔀", description = "Merge branches." },
  { key = ":package:", emoji = "📦️", description = "Add or update compiled files or packages." },
  { key = ":alien:", emoji = "👽️", description = "Update code due to external API changes." },
  { key = ":truck:", emoji = "🚚", description = "Move or rename resources (e.g.: files, paths, routes)." },
  { key = ":page_facing_up:", emoji = "📄", description = "Add or update license." },
  { key = ":boom:", emoji = "💥", description = "Introduce breaking changes." },
  { key = ":bento:", emoji = "🍱", description = "Add or update assets." },
  { key = ":wheelchair:", emoji = "♿️", description = "Improve accessibility." },
  { key = ":bulb:", emoji = "💡", description = "Add or update comments in source code." },
  { key = ":beers:", emoji = "🍻", description = "Write code drunkenly." },
  { key = ":speech_balloon:", emoji = "💬", description = "Add or update text and literals." },
  { key = ":card_file_box:", emoji = "🗃️", description = "Perform database related changes." },
  { key = ":loud_sound:", emoji = "🔊", description = "Add or update logs." },
  { key = ":mute:", emoji = "🔇", description = "Remove logs." },
  { key = ":busts_in_silhouette:", emoji = "👥", description = "Add or update contributor(s)." },
  { key = ":children_crossing:", emoji = "🚸", description = "Improve user experience / usability." },
  { key = ":building_construction:", emoji = "🏗️", description = "Make architectural changes." },
  { key = ":iphone:", emoji = "📱", description = "Work on responsive design." },
  { key = ":clown_face:", emoji = "🤡", description = "Mock things." },
  { key = ":egg:", emoji = "🥚", description = "Add or update an easter egg." },
  { key = ":see_no_evil:", emoji = "🙈", description = "Add or update a .gitignore file." },
  { key = ":camera_flash:", emoji = "📸", description = "Add or update snapshots." },
  { key = ":alembic:", emoji = "⚗️", description = "Perform experiments." },
  { key = ":mag:", emoji = "🔍️", description = "Improve SEO." },
  { key = ":label:", emoji = "🏷️", description = "Add or update types." },
  { key = ":seedling:", emoji = "🌱", description = "Add or update seed files." },
  { key = ":triangular_flag_on_post:", emoji = "🚩", description = "Add, update, or remove feature flags." },
  { key = ":goal_net:", emoji = "🥅", description = "Catch errors." },
  { key = ":dizzy:", emoji = "💫", description = "Add or update animations and transitions." },
  { key = ":wastebasket:", emoji = "🗑️", description = "Deprecate code that needs to be cleaned up." },
  {
    key = ":passport_control:",
    emoji = "🛂",
    description = "Work on code related to authorization, roles and permissions.",
  },
  { key = ":adhesive_bandage:", emoji = "🩹", description = "Simple fix for a non-critical issue." },
  { key = ":monocle_face:", emoji = "🧐", description = "Data exploration/inspection." },
  { key = ":coffin:", emoji = "⚰️", description = "Remove dead code." },
  { key = ":test_tube:", emoji = "🧪", description = "Add a failing test." },
  { key = ":necktie:", emoji = "👔", description = "Add or update business logic." },
  { key = ":stethoscope:", emoji = "🩺", description = "Add or update healthcheck." },
  { key = ":bricks:", emoji = "🧱", description = "Infrastructure related changes." },
  { key = ":technologist:", emoji = "🧑", description = "Improve developer experience." },
  { key = ":money_with_wings:", emoji = "💸", description = "Add sponsorships or money related infrastructure." },
  { key = ":thread:", emoji = "🧵", description = "Add or update code related to multithreading or concurrency." },
  { key = ":safety_vest:", emoji = "🦺", description = "Add or update code related to validation." },
}

local gitmoji_displayer = entry_display.create {
  separator = " ",
  items = {
    { remaining = true },
    { remaining = true },
    { remaining = true },
  },
}

local function gitmoji_entry_maker(gitmoji)
  return {
    value = gitmoji,
    ordinal = gitmoji.key .. " " .. gitmoji.description,
    display = function()
      return gitmoji_displayer {
        gitmoji.emoji,
        { gitmoji.key, "Comment" },
        gitmoji.description,
      }
    end,
  }
end

function M.run(opts)
  opts = opts or {}

  pickers
    .new(opts, {
      finder = finders.new_table {
        results = gitmojis,
        entry_maker = function(gitmoji)
          return gitmoji_entry_maker(gitmoji)
        end,
      },
      results_title = "Gitmoji",
      prompt_title = false,
      attach_mappings = function(buffer)
        actions.select_default:replace(function()
          actions.close(buffer)
          local selection = action_state.get_selected_entry()
          local message = vim.fn.input { prompt = "Commit message: ", cancelreturn = "" }
          if message == "" then
            return
          end
          local first = string.sub(message, 1, 1)
          assert(first ~= string.lower(first), "Use capital letters")
          local result = vim.system({ "git", "commit", "-m", selection.value.emoji .. " " .. message }):wait()
          assert(result.code == 0, result.stderr)
          print(result.stdout)
        end)
        return true
      end,
      sorter = conf.generic_sorter(opts),
    })
    :find()
end

return M
