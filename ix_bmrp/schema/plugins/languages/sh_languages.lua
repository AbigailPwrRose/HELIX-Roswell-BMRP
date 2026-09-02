local PLUGIN = PLUGIN

function PLUGIN:InitializedPlugins()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Cornish"
        LANGUAGE.uniqueID = "celtic_2"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/wales.png"
        LANGUAGE.format = "%s speaks in Cornish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in a celtic tongue"

        LANGUAGE.formatWhispering = "%s whispers in Cornish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in a celtic tongue."

        LANGUAGE.formatYelling = "%s yelling in Cornish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in a celtic tongue"
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Wylish"
        LANGUAGE.uniqueID = "celtic_4"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/wales.png"
        LANGUAGE.format = "%s speaks in Wylish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in a celtic tongue"

        LANGUAGE.formatWhispering = "%s whispers in Wylish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in a celtic tongue."

        LANGUAGE.formatYelling = "%s yelling in Wylish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in a celtic tongue"
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Welsh"
        LANGUAGE.uniqueID = "celtic_1"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/wales.png"
        LANGUAGE.format = "%s speaks in Welsh \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in a celtic tongue"

        LANGUAGE.formatWhispering = "%s whispers in Welsh \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in a celtic tongue."

        LANGUAGE.formatYelling = "%s yelling in Welsh \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in a celtic tongue"
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Irish"
        LANGUAGE.uniqueID = "celtic_3"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ie.png"
        LANGUAGE.format = "%s speaks in Irish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in a celtic tongue"

        LANGUAGE.formatWhispering = "%s whispers in Irish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in a celtic tongue."

        LANGUAGE.formatYelling = "%s yelling in Irish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in a celtic tongue"
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Polish"
        LANGUAGE.uniqueID = "polish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/pl.png"
        LANGUAGE.format = "%s speaks in Polish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Polish."

        LANGUAGE.formatWhispering = "%s whispers in Polish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Polish."

        LANGUAGE.formatYelling = "%s yelling in Polish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Polish."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Kobold"
        LANGUAGE.uniqueID = "kobold-liz"
        LANGUAGE.category = "Draconic"
        LANGUAGE.chatIcon = "icon16/fire.png"
        LANGUAGE.format = "%s speaks in Kobold \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Kobold."

        LANGUAGE.formatWhispering = "%s whispers in Kobold \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Kobold."

        LANGUAGE.formatYelling = "%s yelling in Kobold \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Kobold."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Draconic"
        LANGUAGE.uniqueID = "draconic"
        LANGUAGE.category = "Draconic"
        LANGUAGE.chatIcon = "icon16/fire.png"
        LANGUAGE.format = "%s speaks in Draconic \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Draconic."

        LANGUAGE.formatWhispering = "%s whispers in Draconic \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Draconic."

        LANGUAGE.formatYelling = "%s yelling in Draconic \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Draconic."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Occitan"
        LANGUAGE.uniqueID = "occitan"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/mq.png"
        LANGUAGE.format = "%s speaks in Occitan \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Occitan."

        LANGUAGE.formatWhispering = "%s whispers in Occitan \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Occitan."

        LANGUAGE.formatYelling = "%s yelling in Occitan \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Occitan."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Sangheili"
        LANGUAGE.uniqueID = "sangheili"
        LANGUAGE.category = "Alien"
        LANGUAGE.chatIcon = "icon16/fire.png"
        LANGUAGE.format = "%s speaks in Sangheili \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Sangheili."

        LANGUAGE.formatWhispering = "%s whispers in Sangheili \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Sangheili."

        LANGUAGE.formatYelling = "%s yelling in Sangheili \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Sangheili."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Kig-Yar"
        LANGUAGE.uniqueID = "kigyar"
        LANGUAGE.category = "Alien"
        LANGUAGE.chatIcon = "icon16/fire.png"
        LANGUAGE.format = "%s speaks in Kig-Yar \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Kig-Yar."

        LANGUAGE.formatWhispering = "%s whispers in Kig-Yar \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Kig-Yar."

        LANGUAGE.formatYelling = "%s yelling in Kig-Yar \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Kig-Yar."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Sign"
        LANGUAGE.uniqueID = "signlanguage"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "icon16/status_offline.png"
        LANGUAGE.format = "%s signs \"%s\""
        LANGUAGE.formatUnknown = "%s signs something."

        LANGUAGE.formatWhispering = "%s lightly signs \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s signs something."

        LANGUAGE.formatYelling = "%s widelt signs \"%s\""
        LANGUAGE.formatYellingUnknown = "%s signs something."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Mongolian"
        LANGUAGE.uniqueID = "mongolian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/mn.png"
        LANGUAGE.format = "%s speaks in Mongolian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Mongolian."

        LANGUAGE.formatWhispering = "%s whispers in Mongolian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Mongolian."

        LANGUAGE.formatYelling = "%s yelling in Mongolian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Mongolian."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Goblinese"
        LANGUAGE.uniqueID = "goblin"
        LANGUAGE.category = "Fantasy"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in Goblinese \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in tongues."

        LANGUAGE.formatWhispering = "%s whispers in Goblinese \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s quietly gibbers."

        LANGUAGE.formatYelling = "%s yelling in Goblinese \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something indecipherable."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Basque"
        LANGUAGE.uniqueID = "basque"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/mk.png"
        LANGUAGE.format = "%s speaks in Basque \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Basque."

        LANGUAGE.formatWhispering = "%s whispers in Basque \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Basque."

        LANGUAGE.formatYelling = "%s yelling in Basque \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Basque."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Andalusian"
        LANGUAGE.uniqueID = "Andalusian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ng.png"
        LANGUAGE.format = "%s speaks in Andalusian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Andalusian."

        LANGUAGE.formatWhispering = "%s whispers in Andalusian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Andalusian."

        LANGUAGE.formatYelling = "%s yelling in Andalusian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Andalusian."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Greek"
        LANGUAGE.uniqueID = "greek"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/gr.png"
        LANGUAGE.format = "%s speaks in Greek \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Greek."

        LANGUAGE.formatWhispering = "%s whispers in Greek \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Greek."

        LANGUAGE.formatYelling = "%s yelling in Greek \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Greek."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Swedish"
        LANGUAGE.uniqueID = "swedish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ax.png"
        LANGUAGE.format = "%s speaks in Swedish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Swedish."

        LANGUAGE.formatWhispering = "%s whispers in Swedish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Swedish."

        LANGUAGE.formatYelling = "%s yelling in Swedish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Swedish."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Sámi"
        LANGUAGE.uniqueID = "sami"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/cv.png"
        LANGUAGE.format = "%s speaks in Sámi \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Sámi."

        LANGUAGE.formatWhispering = "%s whispers in Sámi \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Sámi."

        LANGUAGE.formatYelling = "%s yelling in Sámi \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Sámi."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Norwegian"
        LANGUAGE.uniqueID = "norwegian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/no.png"
        LANGUAGE.format = "%s speaks in Norwegian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Norwegian."

        LANGUAGE.formatWhispering = "%s whispers in Norwegian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Norwegian."

        LANGUAGE.formatYelling = "%s yelling in Norwegian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Norwegian."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Danish"
        LANGUAGE.uniqueID = "danish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/dk.png"
        LANGUAGE.format = "%s speaks in Danish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in a Danish"

        LANGUAGE.formatWhispering = "%s whispers in Danish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Danish."

        LANGUAGE.formatYelling = "%s yelling in Danish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Danish."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Finish"
        LANGUAGE.uniqueID = "finn"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/fi.png"
        LANGUAGE.format = "%s speaks in Finish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Finish."

        LANGUAGE.formatWhispering = "%s whispers in Finish\"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Finish."

        LANGUAGE.formatYelling = "%s yelling in Finish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Finish."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Greenlandic"
        LANGUAGE.uniqueID = "green_extinct"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/gl.png"
        LANGUAGE.format = "%s speaks in Greenlandic \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Greenlandic."

        LANGUAGE.formatWhispering = "%s whispers in Greenlandic \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Greenlandic."

        LANGUAGE.formatYelling = "%s yelling in Greenlandic \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Greenlandic."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Icelandic"
        LANGUAGE.uniqueID = "icelandic"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ax.png"
        LANGUAGE.format = "%s speaks in Icelandic \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Icelandic."

        LANGUAGE.formatWhispering = "%s whispers in Icelandic \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Icelandic."

        LANGUAGE.formatYelling = "%s yelling in Icelandic \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Icelandic."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Inuk"
        LANGUAGE.uniqueID = "green_alive"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ax.png"
        LANGUAGE.format = "%s speaks in Inuk \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Inuk."

        LANGUAGE.formatWhispering = "%s whispers in Inuk \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Inuk."

        LANGUAGE.formatYelling = "%s yelling in Inuk \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Inuk."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Norn"
        LANGUAGE.uniqueID = "scottish_viking"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/scotland.png"
        LANGUAGE.format = "%s speaks in Norn \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in... No clue to be honest."

        LANGUAGE.formatWhispering = "%s whispers in Norn \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in... No clue to be honest."

        LANGUAGE.formatYelling = "%s yelling in Norn \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in... No clue to be honest."
    LANGUAGE:Register()
    
	local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Scotts"
        LANGUAGE.uniqueID = "scottish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/scotland.png"
        LANGUAGE.format = "%s speaks in Scottish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in... No clue to be honest."

        LANGUAGE.formatWhispering = "%s whispers in Scottish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in... No clue to be honest."

        LANGUAGE.formatYelling = "%s yelling in Scottish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in... No clue to be honest."
    LANGUAGE:Register()
    
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Ukrainian"
        LANGUAGE.uniqueID = "ukrain"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ua.png"
        LANGUAGE.format = "%s speaks in Ukrainian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Ukrainian."

        LANGUAGE.formatWhispering = "%s whispers in Ukrainian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Ukrainian."

        LANGUAGE.formatYelling = "%s yelling in Ukrainian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Ukrainian."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Polish"
        LANGUAGE.uniqueID = "polish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/pl.png"
        LANGUAGE.format = "%s speaks in Polish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Polish."

        LANGUAGE.formatWhispering = "%s whispers in Polish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Polish."

        LANGUAGE.formatYelling = "%s yelling in Polish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Polish."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Latvian"
        LANGUAGE.uniqueID = "latvian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/at.png"
        LANGUAGE.format = "%s speaks in Latvian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Latvian."

        LANGUAGE.formatWhispering = "%s whispers in Latvian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Latvian."

        LANGUAGE.formatYelling = "%s yelling in Latvian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Latvian."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Estonian"
        LANGUAGE.uniqueID = "estonian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ee.png"
        LANGUAGE.format = "%s speaks in Estonian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Estonian."

        LANGUAGE.formatWhispering = "%s whispers in Estonian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Estonian."

        LANGUAGE.formatYelling = "%s yelling in Estonian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Estonian."
    LANGUAGE:Register()

    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Lithuanian"
        LANGUAGE.uniqueID = "lithuanian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/lt.png"
        LANGUAGE.format = "%s speaks in Lithuanian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Lithuanian."

        LANGUAGE.formatWhispering = "%s whispers in Lithuanian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Lithuanian."

        LANGUAGE.formatYelling = "%s yelling in Lithuanian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Lithuanian."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "French"
        LANGUAGE.uniqueID = "french"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/fr.png"
        LANGUAGE.format = "%s speaks in French \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in French."

        LANGUAGE.formatWhispering = "%s whispers in French \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in French."

        LANGUAGE.formatYelling = "%s yelling in French \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in French."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Spanish"
        LANGUAGE.uniqueID = "spanish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/es.png"
        LANGUAGE.format = "%s speaks in Spanish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Spanish."

        LANGUAGE.formatWhispering = "%s whispers in Spanish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Spanish."

        LANGUAGE.formatYelling = "%s yelling in Spanish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Spanish."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "German"
        LANGUAGE.uniqueID = "german"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/de.png"
        LANGUAGE.format = "%s speaks in German \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in German."

        LANGUAGE.formatWhispering = "%s whispers in German \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in German."

        LANGUAGE.formatYelling = "%s yelling in German \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in German."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Latin"
        LANGUAGE.uniqueID = "latin"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/va.png"
        LANGUAGE.format = "%s speaks in Latin \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Latin."

        LANGUAGE.formatWhispering = "%s whispers in Latin \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Latin."

        LANGUAGE.formatYelling = "%s yelling in Latin \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Latin."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Dataspeak"
        LANGUAGE.uniqueID = "data"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "icon16/bug.png"
        LANGUAGE.format = "%s speaks in Dataspeak \"%s\""
        LANGUAGE.formatUnknown = "%s makes beeping sounds."

        LANGUAGE.formatWhispering = "%s whispers in Dataspeak \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s makes quiet beeps and boops."

        LANGUAGE.formatYelling = "%s yelling in Dataspeak \"%s\""
        LANGUAGE.formatYellingUnknown = "%s makes loud beeping sounds."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Korean"
        LANGUAGE.uniqueID = "korean"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/kr.png"
        LANGUAGE.format = "%s speaks in Korean \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Korean."

        LANGUAGE.formatWhispering = "%s whispers in Korean \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Korean."

        LANGUAGE.formatYelling = "%s yelling in Korean \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Korean."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Russian"
        LANGUAGE.uniqueID = "russ"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ru.png"
        LANGUAGE.format = "%s speaks in Russian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Russian."

        LANGUAGE.formatWhispering = "%s whispers in Russian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Russian."

        LANGUAGE.formatYelling = "%s yelling in Russian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Russian."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Japanese"
        LANGUAGE.uniqueID = "japanese"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/jp.png"
        LANGUAGE.format = "%s speaks in Japanese \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Japanese."

        LANGUAGE.formatWhispering = "%s whispers in Japanese \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Japanese."

        LANGUAGE.formatYelling = "%s yelling in Japanese \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Japanese."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Italian"
        LANGUAGE.uniqueID = "italian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/it.png"
        LANGUAGE.format = "%s speaks in Italian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Italian."

        LANGUAGE.formatWhispering = "%s whispers in Italian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Italian."

        LANGUAGE.formatYelling = "%s yelling in Italian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Italian."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Arabic"
        LANGUAGE.uniqueID = "arabic"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/sa.png"
        LANGUAGE.format = "%s speaks in Arabic \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Arabic."

        LANGUAGE.formatWhispering = "%s whispers in Arabic \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Arabic."

        LANGUAGE.formatYelling = "%s yelling in Arabic \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Arabic."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Turkish"
        LANGUAGE.uniqueID = "turkish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/tr.png"
        LANGUAGE.format = "%s speaks in Turkish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Turkish."

        LANGUAGE.formatWhispering = "%s whispers in Turkish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Turkish."

        LANGUAGE.formatYelling = "%s yelling in Turkish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Turkish."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Kurdish"
        LANGUAGE.uniqueID = "kurdish"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/ne.png"
        LANGUAGE.format = "%s speaks in Kurdish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Kurdish."

        LANGUAGE.formatWhispering = "%s whispers in Kurdish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Kurdish."

        LANGUAGE.formatYelling = "%s yelling in Kurdish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Kurdish."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Egyptian"
        LANGUAGE.uniqueID = "egyptian"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/eg.png"
        LANGUAGE.format = "%s speaks in Egyptian \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Egyptian."

        LANGUAGE.formatWhispering = "%s whispers in Egyptian \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Egyptian."

        LANGUAGE.formatYelling = "%s yelling in Egyptian \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Egyptian."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Godspeak"
        LANGUAGE.uniqueID = "godspeak"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "icon16/font.png"
        LANGUAGE.format = "%s speaks in Godspeak \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in... well, your not entirely sure."

        LANGUAGE.formatWhispering = "%s whispers in Godspeak \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in... well, your not entirely sure."

        LANGUAGE.formatYelling = "%s yelling in Godspeak \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in... well, your not entirely sure."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Portugese"
        LANGUAGE.uniqueID = "portugese"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/pt.png"
        LANGUAGE.format = "%s speaks in Portugese \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Portugese."

        LANGUAGE.formatWhispering = "%s whispers in Portugese \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Portugese."

        LANGUAGE.formatYelling = "%s yelling in Portugese \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Portugese."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Chinese"
        LANGUAGE.uniqueID = "chinese"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/cn.png"
        LANGUAGE.format = "%s speaks in Chinese \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Chinese."

        LANGUAGE.formatWhispering = "%s whispers in Chinese \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Chinese."

        LANGUAGE.formatYelling = "%s yelling in Chinese \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Chinese."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Klingon"
        LANGUAGE.uniqueID = "klingon"
        LANGUAGE.category = "Klingon"
        LANGUAGE.chatIcon = "icon16/error.png"
        LANGUAGE.format = "%s speaks in Klingon \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Klingon."

        LANGUAGE.formatWhispering = "%s whispers in Klingon \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Klingon."

        LANGUAGE.formatYelling = "%s yelling in Klingon \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Klingon."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Technobabble"
        LANGUAGE.uniqueID = "techno"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "icon16/dvd.png"
        LANGUAGE.format = "%s speaks in Technobabble \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in giberish science terms."

        LANGUAGE.formatWhispering = "%s whispers in Technobabble \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in giberish science terms."

        LANGUAGE.formatYelling = "%s yelling in Technobabble \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in giberish science terms."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Dwarvish"
        LANGUAGE.uniqueID = "dwarf"
        LANGUAGE.category = "Fantasy"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in Dwarvish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Dwarvish."

        LANGUAGE.formatWhispering = "%s whispers in Dwarvish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Dwarvish."

        LANGUAGE.formatYelling = "%s yelling in Dwarvish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Dwarvish."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Elvish"
        LANGUAGE.uniqueID = "elf"
        LANGUAGE.category = "Fantasy"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in Elvish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Elvish."

        LANGUAGE.formatWhispering = "%s whispers in Elvish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Elvish."

        LANGUAGE.formatYelling = "%s yelling in Elvish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Elvish."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Kind-ra-Ur"
        LANGUAGE.uniqueID = "giant"
        LANGUAGE.category = "Fantasy"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in Kind-ra-Ur \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Giant-tongue."

        LANGUAGE.formatWhispering = "%s whispers in Kind-ra-Ur \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Giant-tongue."

        LANGUAGE.formatYelling = "%s yelling in Kind-ra-Ur \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Giant-tongue."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Gnomish"
        LANGUAGE.uniqueID = "gnome"
        LANGUAGE.category = "Fantasy"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in Gnomish \"%s\""
        LANGUAGE.formatUnknown = "%s says something."

        LANGUAGE.formatWhispering = "%s whispers in Gnomish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something."

        LANGUAGE.formatYelling = "%s yelling in Gnomish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yells something."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Halfling"
        LANGUAGE.uniqueID = "halfling"
        LANGUAGE.category = "Fantasy"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in Halfling \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in an unknown language."

        LANGUAGE.formatWhispering = "%s whispers in Halfling \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in an unknown language."

        LANGUAGE.formatYelling = "%s yelling in Halfling \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in an unknown language."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Orkish"
        LANGUAGE.uniqueID = "ork"
        LANGUAGE.category = "Fantasy"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in Orkish \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Orkish."

        LANGUAGE.formatWhispering = "%s whispers in Orkish \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Orkish."

        LANGUAGE.formatYelling = "%s yelling in Orkish \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Orkish."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Legalese"
        LANGUAGE.uniqueID = "legal"
        LANGUAGE.category = "Divine"
        LANGUAGE.chatIcon = "icon16/eye.png"
        LANGUAGE.format = "%s speaks in a formal jargon, stating \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in Legalese."

        LANGUAGE.formatWhispering = "%s whispers in a formal jargon, stating \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Legalese."

        LANGUAGE.formatYelling = "%s yelling in a formal jargon, stating \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Legalese."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Hindi"
        LANGUAGE.uniqueID = "indian"
        LANGUAGE.category = "Huam"
        LANGUAGE.chatIcon = "flags16/in.png"
        LANGUAGE.format = "%s speaks in Hindi \"%s\""
        LANGUAGE.formatUnknown = "%s speaks something in Indian."

        LANGUAGE.formatWhispering = "%s whispers in Hindi \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in Indian."

        LANGUAGE.formatYelling = "%s yelling in Hindi \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in Indian."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Siderean Hindi"
        LANGUAGE.uniqueID = "sidereal"
        LANGUAGE.category = "Human"
        LANGUAGE.chatIcon = "flags16/in.png"
        LANGUAGE.format = "%s speaks in Siderean Hindi \"%s\""
        LANGUAGE.formatUnknown = "%s speaks in an Indian dialect."

        LANGUAGE.formatWhispering = "%s whispers in Siderean Hindi \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s whispers something in an Indian dialect."

        LANGUAGE.formatYelling = "%s yelling in Siderean Hindi \"%s\""
        LANGUAGE.formatYellingUnknown = "%s yelling something in an Indian dialect."
    LANGUAGE:Register()
    local LANGUAGE = ix.languages:New()
        LANGUAGE.name = "Abyssal"
        LANGUAGE.uniqueID = "abyssal"
        LANGUAGE.category = "Eldritch"
        LANGUAGE.chatIcon = "icon16/anchor.png"
        LANGUAGE.format = "%s speaks in Abyssal \"%s\""
        LANGUAGE.formatUnknown = "%s makes wretched blubbering sounds, that ripple like water."

        LANGUAGE.formatWhispering = "%s whispers in Abyssal \"%s\""
        LANGUAGE.formatWhisperingUnknown = "%s quietly blubbers, the air feels thick and slimey with their words."

        LANGUAGE.formatYelling = "%s yelling in Abyssal \"%s\""
        LANGUAGE.formatYellingUnknown = "%s loudly blubbers, globs of spit and slime being ejected from their mouth as the air feels damp and gross."
    LANGUAGE:Register()
end
