=begin
  The following settings for text formatting can be used for the description of each location.
  <b> ... </b>       - Formats the text in bold.
  <i> ... </i>       - Formats the text in italics.
  <u> ... </u>       - Underlines the text.
  <s> ... </s>       - Draws a strikeout line over the text.
  <al> ... </al>     - Left-aligns the text.  Causes line breaks before and after
                       the text.
  <r>                - Right-aligns the text until the next line break.
  <ar> ... </ar>     - Right-aligns the text.  Causes line breaks before and after
                       the text.
  <ac> ... </ac>     - Centers the text.  Causes line breaks before and after the
                       text.
  <br>               - Causes a line break.
  <o=X>              - Displays the text in the given opacity (0-255)
  <outln>            - Displays the text in outline format.
  <outln2>           - Displays the text in outline format (outlines more
                       exaggerated.
  <icon=X>           - Displays the icon X (in Graphics/Icons/).
=end

module ARMLocationPreview
  # Region0
  Luminelle = {
    description: _INTL("<ac>Village éclatante, célèbre pour son festival de lumière et ses Pokémon lumineux.<br>Votre village</ac>"), # \n or <br> can be used to add a line break.
    south: [6, 13],
    east: [7, 12]
    #icon: "LappetTown"
  }

  RivièreFélicité = {
    description: _INTL("<ac>Rivière Félicité</ac>"), # \n or <br> can be used to add a line break.
    west: [6, 12],
    #icon: "LappetTown"
  }

  Route01 = {
    description: _INTL("<ac>Un chemin lumineux où la nature rencontre les premiers Pokémon du voyage.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    south: [6, 14],
    north: [6, 12]
  }

  Floralie = {
    description: _INTL("<ac>Ville parfumée, où les fleurs colorées embellissent chaque coin de rue.</ac>"), # \n or <br> can be used to add a line break.
    north: [6, 13],
    east: [7, 14],
    #icon: "LappetTown"
  }

  Route02 = {
    description: _INTL("<ac>Un sentier paisible entouré de champs fleuris et de paysages verdoyants.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    east: [8, 14],
    west: [6, 14]

  }

  Grodoville = {
    description: _INTL("<ac>Ville historique, fortifiée par les échos des anciennes batailles Pokémon.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    east: [9, 14],
    west: [7, 14]
    
  }

  Route03 = {
    description: _INTL("<ac>Un sentier rocailleux menant à l'entrée mystérieuse de la Grotte Creuset.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    east: [10, 14],
    west: [8, 14],
    
  }

  GrotteCreuset = {
    description: _INTL("<ac>Une caverne profonde et obscure, où seuls les plus téméraires osent s'aventurer.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    east: [11, 14],
    west: [9, 14],
  }

  Orhenta = {
    description: _INTL("<ac>Un paisible village avec une arène et la célèbre pension Pokémon.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    east: [12, 14],
    west: [10, 14],
    north: [11, 13],
  }

  ForêtPurificatrice = {
    description: _INTL("<ac>Une forêt magique aux vertus curatives, où Célébi régénérer l'âme de ceux qui s'y aventurent.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    south: [11, 14],
  }

  Route04 = {
    description: _INTL("<ac>Une route sinueuse, avec une grotte glaciale dont l'eau resurgit plus loin dans la rivière, par le sous-sol.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    west: [11, 14],
    east: [13, 14],
  }

  Eudépole = {
    description: _INTL("<ac>Grande métropole animée, centre névralgique de la région, où le modernisme côtoie l'effervescence des commerçants.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    west: [12, 14],
    east: [15, 14],
    north: [13, 12],
  }

  Route05 = {
    description: _INTL("<ac>Une route très longue remplit de dresseur en tout genre et de surprise caché</ac>"), # <ac>text</ac> can be used to center text horizontally.
    north: [13, 10],
    south: [13, 13],
  }

  PlaineEcarlate = {
    description: _INTL("<ac>Une plaine enfoncé où des pokémon spécifique y mange les herbes rouges.<br>Il y a plus de chance de trouver un shiny la bas.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    west: [13, 12],
  }

  Submeralis = {
    description: _INTL("<ac>Submeralis est une ville reconstruite car l'ancienne était partiellement engloutie<br>Zone marchande près du petit port.</ac>"), # <ac>text</ac> can be used to center text horizontally.
    south: [13, 12],
  }


end
