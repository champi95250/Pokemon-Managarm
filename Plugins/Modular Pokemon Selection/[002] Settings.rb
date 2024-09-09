#===============================================================================
# Modular Pokemon Selection
#===============================================================================
# List Settings page:
# list_name = [
#   setting: value,
#   setting: value,
#   ...
# ]
#===============================================================================
# Optional Settings:
# min_iv: setting the minimum of the iv random number range
# max_iv: setting the maximum of the iv random number range
# pokeball: setting the pokeball
#===============================================================================
module PokemonSelections
  DEFAULT = {}

  STARTER = {
    level: 5,
    min_iv: 20,
    pokeball: :POKEBALL
  }

  SHADOW = {
    level: 5,
    min_iv: 15,
    pokeball: :POKEBALL,
    shadow: true
  }
end