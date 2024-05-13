if not EID then return end

-- Mod Icon (TODO)
EID:setModIndicatorName("Restored Collection")
local iconSprite = Sprite()
iconSprite:Load("gfx/eid_restored_icon.anm2", true)
--EID:addIcon("Restored Items Icon", "Icon", 0, 10, 9, 1, 1, iconSprite)
--EID:setModIndicatorIcon("Restored Items Icons")
EID:addIcon("ImmortalHeart", "Icon", 0, 10, 9, 1, 1, iconSprite)
EID:addIcon("SunHeart", "Icon", 1, 10, 9, 1, 1, iconSprite)
EID:addIcon("IllusionHeart", "Icon", 2, 10, 9, 1, 1, iconSprite)

-- Items
--Stone Bombs
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_STONE_BOMBS, "Placed bombs now explode and create rock waves in all 4 cardinal directions#The rock waves can damage enemies, destroy objects, and reveal secret rooms#+5 Bombs", "Stone Bombs", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_STONE_BOMBS, "Las bombas colocadas ahora generan olas de piedra en los 4 puntos cardinales al explotar#Las olas de piedra pueden dañar enemigos, destruir objetos y revelar salas secretas#+5 bombas", "Bombas de Piedra", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_STONE_BOMBS, "Бомбы теперь создают каменные волны во все 4-е основные стороны#Каменные волны могут наносить урон врагам, разрушать объекты и открывать секретные комнаты# + 5 бомб", "Каменные бомбы", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_STONE_BOMBS, "Bombas colocadas agora explodem e criam ondas de pedra em todas as 4 direções cardeais#As ondas de pedra podem causar dano aos inimigos, destruir objetos, e revelar salas secretas#+5 Bombas", "Bombas de Pedra", "pt_br")

--Blank Bombs
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BLANK_BOMBS, "{{Bomb}} +5 Bombs#Bombs explode instantly. -50% bomb damage#Press {{ButtonRT}} + {{ButtonLB}} to place normal bombs. 100% bomb damage#The player is immune from their own bombs#Placed bombs destroy enemy projectiles and knock back enemies within a radius", "Blank Bombs", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BLANK_BOMBS, "{{Bomb}} +5 Bombas#Las bombas explotan inmediatamente. -50% daño de bomba#Pulsa {{ButtonRT}} + {{ButtonLB}} para poner bombas normales. 100% daño de bomba# El jugador es inmune a sus bombas#Las bombas que exploten eliminarán los disparos enemigos y empujarán a los enemigos cercanos", "Bombas de Fogueo", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BLANK_BOMBS, "{{Bomb}} +5 бомб#Бомбы мгновенно взрываются при размещении. -50% урон от бомбы#Нажмите кнопку {{ButtonRT}} + {{ButtonLB}}, чтобы разместить обычные бомбы. 100% урон от бомбы#Игрок невосприимчив к урону от собственной бомбы#Размещенные бомбы уничтожают вражеские снаряды и отбрасывают врагов в радиусе", "Пустые бомбы", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BLANK_BOMBS, "{{Bomb}} +5 Bombas#-50% de dano de bomba.#Pressione {{ButtonRT}} + {{ButtonLB}} para colocar bombas normais. 100% de dano de bomba. O jogador é imune a dano de suas próprias bombas#Bombas colocadas destroem projetéis de inimigos e empurram os inimigos ao seu redor", "Bombas de Festim", "pt_br")

--Checked Mate
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_CHECKED_MATE, "Spawns a familiar that moves by jumping from tile to tile.#20 AOE damage is delt upon each landing.#If the familiar lands directly on a monster, 40 damage is delt.", "Checked Mate", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_CHECKED_MATE, "Создает фамильяра, который перемещается, прыгая с места на место.#20 урона по площади при каждом приземлении.#Если фамильяр приземляется прямо на монстра, тот получает 40 единиц урона.", "Checked Mate", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_CHECKED_MATE, "Genera un Rey de Ajedréz que saltará de cuadro en cuadro#Inflige 20 puntos de daño en área cada vez que aterriza#Si la pieza aterriza directamente sobre un enemigo, inflige 40 puntos de daño", "Rey en jaque", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_CHECKED_MATE, "Gera um familiar que se movimenta pulando de quadrado em quadrado.#Causa 20 pontos de dano em área ao aterrissar.#Se o familiar aterrissar diretamente sobre um inimigo, causa 40 de dano.", "Xeque Mate", "pt_br")

if Sewn_API then
    Sewn_API:AddFamiliarDescription(
        RestoredCollection.Enums.Familiars.CHECKED_MATE.Variant,
        "Increases damage",
        "Increases damage further and range"
    )
end

--Dice Bombs
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DICE_BOMBS, "{{Bomb}} +5 Bombs#Explosions will reroll pedestal items within its explosion radius#Holding certain dice actives will add additional effects", "Dice Bombs")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DICE_BOMBS, "{{Bomb}} +5 бомб#Артефакты на пьедесталах меняются, если они в радиусе взрыва#Имея определенные кубики, добавляются дополнительные еффекты", "Бомбы-кубики", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DICE_BOMBS, "{{Bomb}} +5 Bombas#Las explosiones cambiarán los pedestales de objetos que se encuentren dentro de su radio de explosión#Poseer ciertos objetos activos de dados otorgará efectos adicionales", "Bombas de dados", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DICE_BOMBS, "{{Bomb}} +5 Bombas#Explosões agora irão rerolar os pedestais de item pegos na área de explosão#Possuir certos items ativos de dados adicionará efeitos adicionais", "Bombas de Dado", "pt_br")

--Book of Despair
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} +100% Tears up when used# ↓ Effect is less effective with each use", "Book of Despair", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} Lágrimas +100% al usarlo# ↓ El efecto es menos efectivo cuanto más se use", "El Libro de la Desesperación", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} +100% к скорострельности при использовании# ↓ Эффект менее эффективен при каждом использовании", "Книга отчаяния", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "↑ {{Tears}} +100% Lágrimas quando usado ↓ Efeito é menos efetivo com cada uso", "Livro do Desespero", "pt_br")
EID:assignTransformation("collectible", RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_DESPAIR, "12") -- Bookworm

--Bowl of Tears
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Fires a cluster of tears#Each tear shot by Isaac increases item charge by one", "Bowl of Tears", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Otorga una recarga por cada lágrima que dispare el jugador#Al usarse, dispara una ráfaga de lágrimas en la dirección seleccionada", "Tazón de Lágrimas", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Стреляет скоплением слёз#Каждый выстрел слезы Исааком увеличивает заряд артефакта на один", "Чаша слёз", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOWL_OF_TEARS, "Atira um aglomerado de lágrimas#Adiciona uma carga por cada lágrima que Isaac dispara", "Tigela de Lágrimas", "pt_br")

--Donkey Jawbone
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "Upon taking damage, this item causes you do a spin attack, dealing damage to nearby enemies and blocking projectiles for a short while", "Donkey Jawbone", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "Al recibir daño, realizarás un ataque giratorio, dañando a los enemigos cercanos y bloqueando proyectiles por un momento", "Quijada de burro", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "При получении урона заставляет совершить круговую атаку, которая наносит урон ближайшим врагам и на короткое время блокирует снаряды", "Ослиная челюсть", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_DONKEY_JAWBONE, "Quando for atingido, esse item causa que você faça um ataque giratório, que causa dano em inimigos próximos e bloqueia projéteis por um curto período", "Maxilar de Burro", "pt_br")

--Menorah
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH, "Spawns a menorah familiar that causes Isaac's tears to be multiplied by the number of lit candles#↓ {{Tears}} Halves tear delay and then multiplies it by the sum of lit candles plus 1#Getting hit with 7 lit candles bursts 8 blue flames and makes Isaac unable to shoot for a little while", "Menorah", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH, "Genera un familiar Menorah#El número de lágirmas Isaac aumentan en función de las velas encendidas, máximo 7 velas#↓ {{Tears}} Reduce el tiempo de disparo entre dos y lo multiplica por la suma de las velas encendidas mas 1 #Recibir daño con 7 velas encendidas hace estallar 8 llamas azules y hace que Isaac no pueda disparar por un rato", "Menorah", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH, "Создает подсвечник, который заставляет слезы Исаака размножиться на количество зажжённых свечей#↓ {{Tears}} Уменьшает скорострельность, а затем умножает её на количество зажженных свечей плюс 1#Получая урон с 7 заженными свечами разбрасывает 8 синих огней и делает Айзека неспособным стрелять некоторое время", "Менора", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH, "Gera um familiar menorah que causa as lágrimas de Isaac serem multiplicadas pelo número de velas acesas#↓ {{Tears}} Reduz o tempo de disparo de cada lágrima pela metade e multiplica pela soma das velas acesas mais 1#Ser atingido com as 7 velas acesas gera 8 chamas azuis e impede Isaac de atirar lágrimas por um tempinho", "Menorah", "pt_br")

if Sewn_API then
	Sewn_API:AddFamiliarDescription(
		FamiliarVariant.MENORAH,
		"Higher fire rate per flame",
		"Higher fire rate per flame#You can keep firing even with no flames"
	)
end

--Ancient Revelation
local AncientDesc = "Grants flight#{{ImmortalHeart}} +2 Immortal Hearts#↑ {{Shotspeed}} +0.48 Shot Speed up#↑ {{Tears}} +1 Fire Rate up#Spectral tears#Tears turn 90 degrees to target enemies that they may have missed"
local AncientDescRu = "Даёт полёт#{{ImmortalHeart}} +2 бессмертных сердца#↑ {{Shotspeed}} +0.48 к скорости полёта слезы#↑ {{Tears}} +1 к скорострельности#Спектральные слёзы#Слёзы поворачиваются на 90 градусов, чтобы попасть во врагов, которых они могли пропустить"
local AncientDescSpa = "Otorga vuelo#{{ImmortalHeart}} +2 Corazones inmortales#↑ {{Shotspeed}} Vel. de tiro +0.48#↑ {{Tears}} Lágrimas +1#Lágrimas espectrales#Las lágrimas girarán en 90 grados hacia un enemigo si es que fallan"
local AncientDescPt_Br = "Concede voo#{{ImmortalHeart}} +2 Corações imortais#↑ {{Shotspeed}} +0.48 Vel. de tiro#↑ {{Tears}} +1 Lágrimas#Lágrimas espectrais#Lágrimas viram 90 graus para atingir inimigos que elas não acertaram"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_ANCIENT_REVELATION, AncientDesc, "Ancient Revelation", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_ANCIENT_REVELATION, AncientDescRu, "Древнее откровение", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_ANCIENT_REVELATION, AncientDescSpa, "Antigua Revelación", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_ANCIENT_REVELATION, AncientDescPt_Br, "Revelação Anciã", "pt_br")
EID:assignTransformation("collectible", RestoredCollection.Enums.CollectibleType.COLLECTIBLE_ANCIENT_REVELATION, "10") -- Seraphim

--Beth's Heart
local BHDescEng = "{{Throwable}} Spawns a throwable familiar#Stores soul and black hearts to use as charges for the active item, maximum 6 charges#{{HalfSoulHeart}}: 1 charge#{{SoulHeart}}: 2 charges#{{BlackHeart}}: 3 charges#Press {{ButtonRT}} to supply the charges to the active item"
local BHDescSpa = "{{Throwable}} Genera un familiar lanzable#Almacena corazones de alma y corazones negros para usarlos como cargas para el objeto activo, máximo 6 cargas#{{HalfSoulHeart}}: 1 carga#{{SoulHeart}}: 2 cargas#{{BlackHeart}}: 3 cargas#Presiona {{ButtonRT}} para suministrar las cargas al objeto activo"
local BHDescRu = "{{Throwable}} Создает спутника, которого можно бросать в выбранном направлении#Сохраняет синие и чёрные сердца как заряды для активируемых предметов, максимум 6 зарядов#{{HalfSoulHeart}}: 1 заряд#{{SoulHeart}}: 2 заряда#{{BlackHeart}}: 3 заряда#Для обеспечения зарядами активируемого предмета нужно нажать кнопку {{ButtonRT}}"
local BHDescPt_Br = "{{Throwable}} Gera um familiar arremessável#Armazenas corações de alma e negros para usar como carga para o seu item ativo, máximo de 6 cargas#{{HalfSoulHeart}}: 1 carga#{{SoulHeart}}: 2 cargas#{{BlackHeart}}: 3 cargas##Aperta {{ButtonRT}} para fornecer as cargas para o item ativo"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BETHS_HEART, BHDescEng, "Beth's Heart", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BETHS_HEART, BHDescSpa, "El corazón de Beth", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BETHS_HEART, BHDescRu, "Сердце Вифании", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BETHS_HEART, BHDescPt_Br, "Coração de Bethany", "pt_br")

--Illusion Hearts - Book Of Illusions
local BOIDesc = "Spawns an illusion clone when used#Illusion clones are the same character as you and die in one hit"
local BOIDescSpa = "Genera un clon de ilusión tras usarlo#El clon es el mismo personaje que el tuyo#Morirá al recibir un golpe"
local BOIDescRu = "При использовании создаёт иллюзию# Иллюзия - это тот же персонаж, что и ваш, которые умирают от одного удара"
local BOIDescPt_Br = "Gera um clone de ilusão quando usado#Clones de ilusão são o mesmo personagem que você e morrem em um golpe"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_ILLUSIONS, BOIDesc, "Book of Illusions", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_ILLUSIONS, BOIDescSpa, "El Libro de las ilusiones", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_ILLUSIONS, BOIDescRu , "Книга иллюзий", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_ILLUSIONS, BOIDescPt_Br, "Livro das Ilusões", "pt_br")
EID:assignTransformation("collectible", RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BOOK_OF_ILLUSIONS, "12")


--Keeper's Rope
local KeepersRopeDescEng = "Grants flight#↓ {{Luck}} -2 Luck down if not playing as {{Player14}} Keeper or {{Player33}} Tainted Keeper#{{Coin}} When monsters spawn they have a 25% chance to contain 1-3 pennies which can extracted by damaging them#{{Player14}} When playing as Keeper monsters have 16.7% chance to contain 1-2 pennies#{{Player33}} When playing as Tainted Keeper monsters have 12.5% chance to contain 1 penny#!!! The pennies disappear after 3 seconds"
local KeepersRopeDescRu = "Даёт полёт#↓ {{Luck}} -2 к удаче если играть не за {{Player14}} Хранителя или {{Player33}} Порченого Хранителя#{{Coin}} Когда монстры появляются у них есть 25% шанс иметь 1-3 монет, которые выпадают при нанесении им урона#{{Player14}} При игре за Хранителя у монстров есть 16.7% шанс иметь 1-2 монеты#{{Player33}} При игре за Порченого Хранителя у монстров есть 12.5% шанс иметь 1 монету#!!! Монеты исчезают через 3 секунды"
local KeepersRopeDescSpa = "Puedes volar##{{Luck}} Suerte -2 si no se está jugando como {{Player14}} Keeper o {{Player33}} Tainted Keeper#{{Coin}} Cuando se generen los enemigos, tendrán un 25% de tener 1-3 monedas #Las puedes obtener al hacerles daño#{{Player14}} Con Keeper los enemigos tendrán 16.7% de tener 1-2 monedas#{{Player33}} Con Tainted Keeper Contaminado los enemigos tendrán un 12.5% de tener 1 moneda#!!! Las monedas desaparecen después de 3 segundos"
local KeepersRopeDescPt_Br = "Concede voo#↓ {{Luck}} -2 sorte caso não esteja jogando como {{player14}} Keeper ou {{Player33}} Tainted Keeper#{{Coin}} Quando monstros surgem, possuem 25% de chance de conter entre 1-3 moedas que podem ser extraidas ao causar dano a eles#{{Player14}} Ao jogar de Keeper, monstros tem 16.7% de chance de conter 1-2 moedas#{{Player33}} Ao jogar de Tainted Keeper, monstros tem 12.5% de chance de conter 1 moeda#!!! As moedas desaparecerão após 3 segundos"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_KEEPERS_ROPE, KeepersRopeDescEng, "Keeper's Rope")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_KEEPERS_ROPE, KeepersRopeDescRu, "Веревка Хранителя", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_KEEPERS_ROPE, KeepersRopeDescSpa, "La soga de Keeper", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_KEEPERS_ROPE, KeepersRopeDescPt_Br, "Corda do Keeper", "pt_br")


--Lucky seven
local Sevendesc = "Whenever any of the player's pickup counts ends in a 7, Isaac has a chance to shoot golden tears that spawn special slot machines when they hit monsters"
local SevendescRu = "Всякий раз, когда один из предметов игрока заканчивается на 7, у Исаака есть шанс выстрелить золотыми слезами, которые при попадании во врагов превращают их в особые игровые автоматы"
local SevendescSpa = "Si el numero de cualquier recolectable del jugador termina en 7, se tendrá la posibilidad de lanzar una lágrima dorada que genera una máquina tragaperras especial al golpear a un enemigo"
local SevendescPt_Br = "Se o número de qualquer um dos números de pickup do jogador acabar em um 7, Isaac terá a chance de atirar uma lágrima dourada que cria uma máquina Caça-níquel especial quando atingir um monstro"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN, Sevendesc, "Lucky Seven")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN, SevendescRu, "Счастливая семерка", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN, SevendescSpa, "7 de la suerte", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN, SevendescPt_Br, "Sete Sortudo", "pt_br")

--Pacifist
local Pacdesc = "Gives pickup rewards at the start of a floor based on how many rooms you haven't cleared on the previous floor"
local PacdescRu = "Дает награду предметами на следующем этаже в зависимости от того, сколько комнат вы не зачистили на текущем"
local PacdescSpa = "Genera recolectables en el siguiente piso en función a cuantas habitaciones no limpiaste en el piso actual"
local PacdescPt_Br = "Gera pickups de recompensa no início do próximo andar baseado em quantas salas você não completou no andar anterior"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PACIFIST, Pacdesc, "Pacifist")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PACIFIST, PacdescRu, "Пацифист", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PACIFIST, PacdescSpa, "Pacifista", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PACIFIST, PacdescPt_Br, "Pacifista", "pt_br")


---Pill crusher
local PCDesc = "{{Pill}} Gives a random pill when picked up#Increase pill drop rate when held#Consumes currently held pill and applies an effect to the entire room depending on the type of pill"
local PCDescSpa = "{{Pill}} Genera una píldora aleatoria al tomarlo#Las píldora aparecen con mas frecuencia#Consume la píldora que posees y aplica un efecto a la sala, basado en la píldora"
local PCDescRu = "{{Pill}} Дает случайную пилюлю#{{Pill}} Увеличивает шанс появления пилюль#Использует текущую пилюлю и накладывает зависимый от её типа эффект на всю комнату"
local PCDescPt_Br = "{{Pill}} Gera uma pílula aleatória quando pego#{{Pill}} Aumenta a taxa de queda de pílulas enquanto segurado# Consome a sua pílula atual e aplica um efeito na sala inteira dependendo no tipo de pílula consumida"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDesc, "Pill Crusher", "en_us")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDescSpa, "Triturador de Pildoras", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDescRu, "Дробилка пилюль", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PILL_CRUSHER, PCDescPt_Br, "Triturador de Pílulas", "pt_br")


--Safety Bombs
local SBDesc = "{{Bomb}} +5 Bombs#Placed bombs will not explode until the player leaves its explosion radius"
local SBDescSpa = "{{Bomb}} +5 Bombas#Las bombas que coloques no explotarán hasta que te alejes de su radio de explosión"
local SBDescRu = "{{Bomb}} +5 бомб#Размещенные бомбы не взорвутся, пока игрок не покинет радиус взрыва"
local SBDescPt_Br = "{{Bombs}} +5 Bombas#Bombas não irão explodir até o jogador sair de sua área de explosão"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_SAFETY_BOMBS, SBDesc, "Safety Bombs")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_SAFETY_BOMBS, SBDescSpa, "Bombas de Seguridad", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_SAFETY_BOMBS, SBDescRu, "Безопасные бомбы", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_SAFETY_BOMBS, SBDescPt_Br, "Bombas de Segurança", "pt_br")


--Voodoo Pin
local VDPdesc = "Isaac holds up a voodoo pin that can be thrown into enemy#If the pin hits a monster, its hitbox will swap with Isaac's hitbox. Lasts until enemy is dead#Hitting bosses makes it last for 5 seconds"
local VDPdescRu = "Исаак достает булавку, которую можно бросить во врага#Если булавка попала в монстра, то его хитбокс поменяется местами с хитбоксом Исаака#При подании в босса действует 5 секунды"
local VDPdescSpa = "Isaac sostiene un pin de vudú que puede ser lanzado al enemigo#Si el pin golpea a un monstruo, su hitbox será intercambiada por la de Isaac hasta que muera#Si golpea a un jefe, durará 5 segundos"
local VDPdescPt_Br = "Isaac segura um alfinete de voodoo que pode ser atirado em um inimigo#Se o alfinete acertar um monstro, a sua hitbox será invertida com a hitbox do Isaac#Dura até o inimigo morrer#Acertar chefes fará o efeito durar por apenas 5 segundos"

EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_VOODOO_PIN, VDPdesc, "Voodoo Pin")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_VOODOO_PIN, VDPdescRu, "Вуду булавка", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_VOODOO_PIN, VDPdescSpa, "Pin de vudú", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_VOODOO_PIN, VDPdescPt_Br, "Alfinete de Voodoo", "pt_br")

--Lunch Box
for i = 0, 5 do
    EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUNCH_BOX - i, "Charged by collecting {{Heart}} red hearts#On use spawns one of the 'food' items#Disappears after 6 uses", "Lunch Box")
    EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUNCH_BOX - i, "Заряжается подпором {{Heart}} красных сердец#При использовании спавнит один из 'съедобных' предметов#Исчезает после 6 использований", "Коробка c ланчем", "ru")
    EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUNCH_BOX - i, "Se carga colleccionando {{Heart}} corazones rojos#Cuando se usa, aparece uno de los objetos de 'comida'#Desaparece después de 6 usos", "Caja del almuerzo", "spa")
end

--Max's Head
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MAXS_HEAD, "↑ {{Tears}} +1.50 tears up#Every 4th tear is shot faster", "Max's Head")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MAXS_HEAD, "↑ {{Tears}} +1.50 к скорострельности#Каждая 4-я слеза выстреливает быстрее", "Голова Макса", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MAXS_HEAD, "↑ {{Tears}} +1.50 lagrimas hacia arriba#Cada cuarta lagrima, el disparo acelera", "Cabeza de Max", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MAXS_HEAD, "↑ {{Tears}} +1.50 lágrimas#Toda quarta lágrima é mais veloz", "Cabeça do Max", "pt_br")


--Ol' Lopper
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_OL_LOPPER, "Disconnects Isaac's head from his body allowing it to move like Mr. Maw head", "Ol' Lopper")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_OL_LOPPER, "Отсоединяет голову Айзека то его тела, позволяя ей двигаться как голова Мистера Пасть", "Ol' Lopper", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_OL_LOPPER, "Desconecta la cabeza de Isaac de su cuerpo, permitiéndole moverla como la cabeza de Sr. Maw", "Ol' Looper", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_OL_LOPPER, "Desconecta a cabeça de Isaac do seu corpo, permitindo com que se mova como a cabeça de Mr. Maw", "Ol' Looper", "pt_br")

--Pumpkin Mask
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PUMPKIN_MASK, "Fires a rapid inacurate strike of seeds#Seeds are fired within 30° of shooting direction", "Pumkin Mask")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PUMPKIN_MASK, "Выпускает быстрые неточные выстрелы семенами#Семена выстреливаются в пределах 30° направления стрельбы", "Тыквенная маска", "ru")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PUMPKIN_MASK, "Dispara rápidamente y sin precisión una ráfaga de semillas#Las semillas están disparadas en un rango de 30º desde la dirección de disparo", "Mascara de Calabaza", "spa")
EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_PUMPKIN_MASK, "Dispara rapidamente e com baixa precisão uma série de sementes#Sementes são disparadas dentro de 30° da direção do disparo", "Máscara de Abóbora", "pt_br")

--Melted Candle
--EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MELTED_CANDLE, "Lights a candle fire when shooting#↑ +0.5 tears up when a small fire is lit#↑ +1.5 tears up when a large fire is lit#A small fire is always lit when shooting#10% light a large fire when a small fire is lit#When a small fire is lit 30% chance to shoot a wax tear that slows down and sets enemies on fire#After 5 seconds without shooting the candle fire diminishes")
--EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MELTED_CANDLE, "Зажигает огонь всечи при стрельбе#↑ +0.5 к скорострельности при заженном маленьком огне#↑ +1.5 к скорострельности при заженном большом огне#Маленький огонь всегда зажигается при стрельбе#10% зажечь большой огонь при заженном меленьком огне#При заженном мелком огне 30% шанс выстрелить восковой слезой, которая замедляет и поджигает врагов#Не стреляя 5 секунд огонь свечи уменьшается", "Расплавленная свеча", "ru")
--EID:addCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MELTED_CANDLE, "Prende una llama en una vela cuando disparas#↑ Lágrimas hacia arriba +0.5 cuando un fuego pequeño es encendido#↑ Lágrimas arriba +1.5 cuando un fuego grande es encendido#10% de encender un fuego grande cuando un fuego pequeño es encendido#Cuando un fuego pequeño es encendido, 30% de disparar una lágrima de cera que ralentiza y prende fuego a enemigos#Después de 5 segundos sin disparar, el fuego de la vela disminuye", "Vela derretida", "spa")

--Game Squid
EID:addTrinket(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "5% change to shoot slowing tear that leaves black puddle on impact")
EID:addTrinket(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "5% шанс выстрелить замедляющей слезой, которая оставляет черную лужу при столкновении", "Игровой кальмар", "ru")
EID:addTrinket(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "5% de disparar una lágrima ralentizada que deja un charco negro cuando impacta", "", "spa")
EID:addTrinket(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "5% de chance de disparar uma lágrima que desascelera e deixa uma poça preta no impacto", "Lula dos Games", "pt_br")
EID:addGoldenTrinketMetadata(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "↑ +3% on top for every trinket multiplier")
EID:addGoldenTrinketMetadata(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "↑ +3% дополнительно за каждый множитель брелка", nil, nil, "ru")
EID:addGoldenTrinketMetadata(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "↑ +3% cuando se usa con cualquier trinket de multiplicador", nil, nil, "spa")
EID:addGoldenTrinketMetadata(RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID, "↑ +3% de chance por cada multiplicador de trinkets", nil, nil, "pt_br")