#===============================================================================
# Plugin: BattleWithFriend
# Version: v1.0
# Créateur: ChatGPT
# Description: Ce plugin permet de combattre un autre joueur via un code.
#===============================================================================

def pbBattleFriend
  # Création du menu avec trois options
  commands = ["Envoyer Code", "Combattre Amis", "Partir"]
  command = pbShowCommands(nil, commands, -1)
  
  case command
  when 0
    send_code_to_friend
  when 1
    start_battle_with_friend
  when 2
    pbMessage("Vous avez annulé.")
  end
end

def send_code_to_friend
  pbMessage("Envoi du code à votre ami...")

  trainer = $player   # Récupère le joueur actuel
  trainer_name = trainer.name   # Nom du dresseur
  trainer_sprite = GameData::TrainerType.get(trainer.trainer_type).id.to_s  # Nom interne du sprite du dresseur

  # Ouvre/crée le fichier .txt pour écrire les infos
  File.open("battle_info.txt", "w") do |file|
    # Informations du dresseur
    file.puts "[#{trainer_sprite},#{trainer_name}]"

    # Informations sur chaque Pokémon de l'équipe
    trainer.party.each_with_index do |pokemon, index|
      species_data = GameData::Species.get(pokemon.species)  # Récupère les données de l'espèce
      file.puts "Pokemon = #{species_data.id.to_s.upcase},#{pokemon.level}"
      
      # Surnom du Pokémon (optionnel)
      if pokemon.name && pokemon.name != species_data.name
        file.puts "\tName = #{pokemon.name}"
      end

      # N'écrit la ligne Item que si un item est présent
      if pokemon.item
        file.puts "\tItem = #{GameData::Item.get(pokemon.item).id.to_s.upcase}"
      end

      file.puts "\tShiny = #{pokemon.shiny? ? 'True' : 'False'}"
      file.puts "\tSuperShiny = #{pokemon.super_shiny? ? 'True' : 'False'}"
      file.puts "\tTeraType = #{pokemon.tera_type ? GameData::Type.get(pokemon.tera_type).id.to_s.upcase : 'NONE'}"
      file.puts "\tNature = #{GameData::Nature.get(pokemon.nature).id.to_s.upcase}"  # Nature en anglais
      file.puts "\tAbility = #{pokemon.ability ? GameData::Ability.get(pokemon.ability).id.to_s.upcase : 'NONE'}"
      
      # IVs et EVs en une seule ligne
      file.puts "\tIV = #{pokemon.iv[:HP]},#{pokemon.iv[:ATTACK]},#{pokemon.iv[:DEFENSE]},#{pokemon.iv[:SPECIAL_ATTACK]},#{pokemon.iv[:SPECIAL_DEFENSE]},#{pokemon.iv[:SPEED]}"
      file.puts "\tEV = #{pokemon.ev[:HP]},#{pokemon.ev[:ATTACK]},#{pokemon.ev[:DEFENSE]},#{pokemon.ev[:SPECIAL_ATTACK]},#{pokemon.ev[:SPECIAL_DEFENSE]},#{pokemon.ev[:SPEED]}"

      # Moveset en une ligne
      move_ids = pokemon.moves.map { |move| GameData::Move.get(move.id).id.to_s.upcase }
      file.puts "\tMoveset = #{move_ids.join(',')}"
    end
  end

  pbMessage("Les informations du combat ont été sauvegardées dans 'battle_info.txt'.")
end

#-------------------------------------------------------------------------------------------
#Check file
def check_battle_with_friend
  file_path = "battle_info.txt"
  
  # Vérifie si le fichier existe
  return File.exist?(file_path)
end


#-------------------------------------------------------------------------------------------
# Fonction pour "Combattre Amis" - Ajoute ici ta logique
def start_battle_with_friend
  #---pbMessage("Connexion avec votre ami pour démarrer le combat...")

  # Lire les données du fichier 'battle_info.txt'
  file_path = "battle_info.txt"
  return pbMessage("Fichier de combat introuvable.") unless File.exist?(file_path)
  
  trainer_name = ""
  trainer_sprite = ""
  pokemon_team = []
  current_pokemon = nil  # Définir `current_pokemon` en dehors de la boucle

  File.open(file_path, "r") do |file|
    file.each_line do |line|
      line.strip!
      if line.start_with?("[")
        # Récupère le sprite et le nom du dresseur
        trainer_sprite, trainer_name = line.scan(/\[(.*?),(.*?)\]/).flatten
        puts "Trainer: #{trainer_name}, Sprite: #{trainer_sprite}"  # Debug
      elsif line.start_with?("Pokemon")
        # Si un nouveau Pokémon est rencontré, on initialise un nouveau dictionnaire
        species, level = line.match(/Pokemon = (\w+),(\d+)/).captures
        current_pokemon = { species: species.to_sym, level: level.to_i }
        pokemon_team << current_pokemon
        puts "Pokemon: #{species}, Level: #{level}"  # Debug
      elsif current_pokemon  # S'assure que `current_pokemon` est bien défini
        if line.start_with?("Name")
          current_pokemon[:name] = line.match(/Name = (.*)/).captures[0]
          puts "Name: #{current_pokemon[:name]}"  # Debug
        elsif line.start_with?("Item")
          current_pokemon[:item] = line.match(/Item = (\w+)/).captures[0].to_sym
          puts "Item: #{current_pokemon[:item]}"  # Debug
        elsif line.start_with?("Shiny")
          current_pokemon[:shiny] = (line.match(/Shiny = (True|False)/).captures[0] == "True")
          puts "Shiny: #{current_pokemon[:shiny]}"  # Debug
        elsif line.start_with?("SuperShiny")
          current_pokemon[:super_shiny] = (line.match(/SuperShiny = (True|False)/).captures[0] == "True")
          puts "SuperShiny: #{current_pokemon[:super_shiny]}"  # Debug
        elsif line.start_with?("TeraType")
          current_pokemon[:tera_type] = line.match(/TeraType = (\w+)/).captures[0].to_sym
          puts "TeraType: #{current_pokemon[:tera_type]}"  # Debug
        elsif line.start_with?("Nature")
          current_pokemon[:nature] = line.match(/Nature = (\w+)/).captures[0].to_sym
          puts "Nature: #{current_pokemon[:nature]}"  # Debug
        elsif line.start_with?("Ability")
          current_pokemon[:ability] = line.match(/Ability = (\w+)/).captures[0].to_sym
          puts "Ability: #{current_pokemon[:ability]}"  # Debug
        elsif line.start_with?("IV")
          current_pokemon[:iv] = line.match(/IV = ([\d,]+)/).captures[0].split(",").map(&:to_i)
          puts "IV: #{current_pokemon[:iv].join(',')}"  # Debug
        elsif line.start_with?("EV")
          current_pokemon[:ev] = line.match(/EV = ([\d,]+)/).captures[0].split(",").map(&:to_i)
          puts "EV: #{current_pokemon[:ev].join(',')}"  # Debug
        elsif line.start_with?("Moveset")
          current_pokemon[:moveset] = line.match(/Moveset = ([\w,]+)/).captures[0].split(",").map(&:to_sym)
          puts "Moveset: #{current_pokemon[:moveset].join(',')}"  # Debug
        end
      end
    end
  end

  # Afficher un message si le fichier a été bien lu
  pbMessage("Votre prochain combat est prêt")

  # Créer l'équipe de Pokémon pour le dresseur avec les détails ajoutés
  party = pokemon_team.map do |pkmn_data|
    pokemon = Pokemon.new(pkmn_data[:species], pkmn_data[:level])

    # Appliquer les informations spécifiques au Pokémon
    puts "Création du Pokémon #{pkmn_data[:species]} de niveau #{pkmn_data[:level]}"  # Debug
    pokemon.item = pkmn_data[:item] ? GameData::Item.get(pkmn_data[:item]).id : nil
    pokemon.shiny = pkmn_data[:shiny] unless pkmn_data[:shiny].nil?
    pokemon.super_shiny = pkmn_data[:super_shiny] unless pkmn_data[:super_shiny].nil?
    pokemon.tera_type = pkmn_data[:tera_type] ? GameData::Type.get(pkmn_data[:tera_type]).id : nil
    pokemon.nature = GameData::Nature.get(pkmn_data[:nature]).id if pkmn_data[:nature]
    pokemon.ability = GameData::Ability.get(pkmn_data[:ability]).id if pkmn_data[:ability]
    pokemon.iv = pkmn_data[:iv] if pkmn_data[:iv]
    pokemon.ev = pkmn_data[:ev] if pkmn_data[:ev]

    # Appliquer le surnom si présent
    pokemon.name = pkmn_data[:name] if pkmn_data[:name]

    # Appliquer les moves
    if pkmn_data[:moveset]
      pkmn_data[:moveset].each_with_index do |move, index|
        pokemon.moves[index] = Pokemon::Move.new(GameData::Move.get(move).id)
        puts "Move #{index + 1}: #{move}"  # Debug
      end
    end

    pokemon
  end

  # Créer le dresseur avec le sprite et nom récupérés
  trainer = NPCTrainer.new(trainer_name, GameData::TrainerType.get(trainer_sprite.to_sym).id)
  trainer.party = party

  # Lancer le combat contre ce dresseur
  TrainerBattle.start(trainer)
end

