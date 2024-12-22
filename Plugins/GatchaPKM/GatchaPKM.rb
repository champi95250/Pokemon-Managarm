#===============================================================================
# Plugin Gatcha Pokémon - GatchaPKM v0.1
# Créé par : Champi
# Version : 0.1
# Compatible avec : Pokémon Essentials v21.1
#===============================================================================

module GatchaPKM
  # Configuration des Pokémon et des taux pour chaque ticket
  GATCHA_LIST = {
    :TICKETBASE => {
      :pokemons => [
        { name: :CATERPIE, rate: 80 },
        { name: :WEEDLE, rate: 80 },
        { name: :PIKACHU, rate: 15 },
        { name: :SPEAROW, rate: 15 },
        { name: :VULPIX, rate: 5 }
      ],
      :reward_type => :pokemon # :pokemon ou :egg
    },
    :TICKETARGENT => {
      :pokemons => [
        { name: :PIKACHU, rate: 50 },
        { name: :RIOLU, rate: 30 },
        { name: :DRACAUFEU, rate: 20 }
      ],
      :reward_type => :egg
    }
  }

  # Fonction principale pour lancer le Gatcha
  def self.start
    ticket = select_ticket
    return unless ticket

    selected_pokemon = draw_pokemon(ticket)
    if selected_pokemon
      reward_player(selected_pokemon, ticket)
    else
      pbMessage(_INTL("Aucun Pokémon obtenu. Réessayez !"))
    end
  end

  # Affiche les tickets disponibles dans le sac
  def self.select_ticket
    pbFadeOutIn {
      scene = PokemonBag_Scene.new
      screen = PokemonBagScreen.new(scene, $bag)
      # Affiche l'écran du sac et filtre les objets de type ticket (optionnel, peut être ajusté)
      ticket = screen.pbChooseItemScreen(Proc.new { |item| GATCHA_LIST.keys.include?(item) }) 
      if ticket.nil?
        pbMessage(_INTL("Vous n'avez sélectionné aucun objet."))
        return nil
      end
      if !GATCHA_LIST.keys.include?(ticket)
        pbMessage(_INTL("Cet objet ne peut pas être utilisé dans le Gatcha."))
        return nil
      end


      # 4. Retire 1 ticket du sac (ou objet dans ce cas)
      $bag.remove(ticket, 1) 
      return ticket
    }
  end


  # Effectue le tirage au sort parmi les Pokémon possibles pour le ticket
  def self.draw_pokemon(ticket)
    unless GATCHA_LIST[ticket]
      pbMessage(_INTL("Erreur : Le ticket sélectionné ne fait pas partie du Gatcha."))
      return nil
    end

    pool = GATCHA_LIST[ticket][:pokemons]
    total_rate = pool.sum { |p| p[:rate] }
    roll = rand(total_rate)

    current_rate = 0
    pool.each do |entry|
      current_rate += entry[:rate]
      return entry[:name] if roll < current_rate
    end

    nil # Si aucun Pokémon n'est obtenu, ce qui ne devrait jamais arriver
  end

  # Donne le Pokémon ou l'œuf au joueur
  def self.reward_player(pokemon, ticket)
    play_gatcha_animation(pokemon, ticket)
    reward_type = GATCHA_LIST[ticket][:reward_type]
    
    if reward_type == :pokemon
      
      pbAddPokemon(pokemon, 5) # Donne le Pokémon de niveau 5
      pbMessage(_INTL("Félicitations ! Vous avez obtenu un {1} !", GameData::Species.get(pokemon).name))
    
    elsif reward_type == :egg
      # 1. Crée l'œuf en utilisant la méthode `create_egg`
      egg = create_egg(pokemon)
      
      # 2. Vérifie si l'équipe du joueur est pleine
      if $player.party_full?
        pbMessage(_INTL("Votre équipe est pleine. L'œuf a été envoyé au PC !", GameData::Species.get(pokemon).name))
        pbStorePokemon(egg) # Envoie l'œuf au PC
      else
        # Équipe non pleine, ajoute l'œuf à l'équipe
        $player.party.push(egg)
        pbMessage(_INTL("Félicitations ! Vous avez obtenu un œuf !", GameData::Species.get(pokemon).name))
      end
    end
  end

def self.play_gatcha_animation(pokemon, ticket)
  # 1. Crée une nouvelle scène graphique
  viewport = Viewport.new(0, 0, Graphics.width, Graphics.height)
  viewport.z = 99999 # Assurez-vous qu'il est au-dessus de tout
  sprites = {}

  # 2. Affiche le fond (hatch_bg.png) depuis Graphics/UI
  sprites["background"] = Sprite.new(viewport)
  sprites["background"].bitmap = RPG::Cache.load_bitmap("Graphics/UI/", "hatch_bg")
  sprites["background"].opacity = 0 # Commence transparent

  # 3. Crée un Pokémon complet et l'affiche au centre de l'écran
  full_pokemon = Pokemon.new(pokemon, 1) # Crée le Pokémon complet au niveau 1
  sprites["pokemon"] = PokemonSprite.new(viewport)
  if GATCHA_LIST[ticket][:reward_type] == :egg
    # Affiche manuellement le sprite d'œuf générique
    sprites["pokemon"].bitmap = RPG::Cache.load_bitmap("Graphics/Pokemon/Eggs/", "000")
  else
    # Crée le Pokémon complet et active son animation
    full_pokemon = Pokemon.new(pokemon, 1) # Crée le Pokémon complet au niveau 1
    sprites["pokemon"] = PokemonSprite.new(viewport)
    sprites["pokemon"].setPokemonBitmap(full_pokemon)
  end
  sprites["pokemon"].x = (Graphics.width / 2)
  sprites["pokemon"].y = (Graphics.height / 2)+40
  sprites["pokemon"].ox = sprites["pokemon"].bitmap.width / 2
  sprites["pokemon"].oy = sprites["pokemon"].bitmap.height / 2
  sprites["pokemon"].opacity = 0 # Pokémon invisible au début
  sprites["pokemon"].zoom_x = 0.1 # Échelle initiale (petit)
  sprites["pokemon"].zoom_y = 0.1

  # 4. Joue le son de ticket (ou un son par défaut)
  ticket_me = "ticket_base" # Son par défaut
  pbMEPlay(ticket_me)

  # 6. Effet de flash rapide
  flash = Sprite.new(viewport)
  flash.bitmap = Bitmap.new(Graphics.width, Graphics.height)
  flash.bitmap.fill_rect(0, 0, Graphics.width, Graphics.height, Color.new(255, 255, 255))
  flash.opacity = 0
  pbSEPlay("Flash") # Joue le son de flash

  # Animation du flash rapide
  40.times do
    flash.opacity += 25 # Rend le flash visible
    Graphics.update
    Input.update
  end

  # 5. Animation d'affichage (fond et Pokémon avec flash)
  150.times do
    flash.opacity -= 10 # Disparition rapide
    sprites["background"].opacity += 50 if sprites["background"].opacity < 255
    sprites["pokemon"].opacity += 10 if sprites["pokemon"].opacity < 255
    sprites["pokemon"].zoom_x += 0.01 if sprites["pokemon"].zoom_x < 1
    sprites["pokemon"].zoom_y += 0.01 if sprites["pokemon"].zoom_y < 1
    sprites["pokemon"].update
    Graphics.update
    Input.update
  end

  # 7. Pause (montre le Pokémon pendant un moment)
  500.times do
    sprites["pokemon"].update
    Graphics.update
    Input.update
  end

  # 8. Disparition de tous les éléments
  150.times do
    sprites["pokemon"].update
    sprites["background"].opacity -= 3 if sprites["background"].opacity > 0
    sprites["pokemon"].opacity -= 2 if sprites["pokemon"].opacity > 0
    Graphics.update
    Input.update
  end

  # 9. Supprime les sprites
  sprites.each_value(&:dispose)
  viewport.dispose
end





  def self.create_egg(species)
    egg = Pokemon.new(species, Settings::EGG_LEVEL) # Crée le Pokémon au niveau de l'œuf défini
    egg.name = _INTL("Œuf") # Définit le nom de l'œuf (ou "Egg" si tu préfères)
    egg.steps_to_hatch = egg.species_data.hatch_steps # Nombre de pas nécessaires pour éclore
    egg.hatched_map = 0 # La carte où l'œuf a éclos (0 = aucune)
    egg.obtain_method = 1 # Obtention via un œuf
    egg.calc_stats # Recalcule les stats pour être sûr
    return egg # Retourne l'œuf
  end





end


# Commande pour lancer le Gatcha
def pkmgatcha
  GatchaPKM.start
end
