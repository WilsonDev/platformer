local STATE_NAMES = require "state.constants.StateNames"

local STATES = {
  [STATE_NAMES.MENU] = MenuState,
  [STATE_NAMES.SCORES] = HighScoreState,
  [STATE_NAMES.CONTROLS] = ControlsMenuState,
  [STATE_NAMES.SETTINGS] = SettingsState,
  [STATE_NAMES.SUBMIT_SCORE] = SubmitScoreState,
  [STATE_NAMES.GAME] = GameState
}

return STATES
