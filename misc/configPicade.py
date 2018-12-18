import imp

# import picade
picade = imp.load_source('picade', '/home/pi/Downloads/Picade-Sketch/Config/picade.py')

def buttonsGalaga():
    # Galaga buttons
    #   Event Code: 103
    #   Event Code: 108
    #   Event Code: 105
    #   Event Code: 106
    #
    #   Event Key: x Event Code: 45
    #   Event Key: y Event Code: 44
    #   Event Key: X Event Code: 42
    #   Event Key: X Event Code: 57
    #   Event Key: X Event Code: 29
    #   Event Key: X Event Code: 56
    #
    #   Event Key: ^ Event Code: 1
    #   Event Key: X Event Code: 28
    #   Event Key: c Event Code: 46
    #   Event Key: s Event Code: 31
    #
    #   Event Key: b Event Code: 48
    #   Event Key: v Event Code: 47

    # Galaga box mappings
    return([picade.KEY_UP_ARROW,    #   - Event 103 - Joy U
            picade.KEY_DOWN_ARROW,  #   - Event 108 - Joy D
            picade.KEY_LEFT_ARROW,  #   - Event 105 - Joy L
            picade.KEY_RIGHT_ARROW, #   - Event 106 - Joy R

            picade.KEY_LEFT_CTRL,   #   - Event  56 - Btn 6
            picade.KEY_LEFT_ALT,    #   - Event  29 - Btn 5
             32,       # Space in ASCII - Event  57 - Btn 4
            picade.KEY_LEFT_SHIFT,  #   - Event  42 - Btn 3
            122,                    # z - Event  44 - Btn 2
            120,                    # x - Event  45 - Btn 1

            115,                    # s - Event  31 - Start
             99,                    # c - Event  46 - Coin
            picade.KEY_RETURN,      #   - Event  28 - Enter
            picade.KEY_ESC,         #   - Event   1 - Escape

             98,                    # b - Event  48 - Volume up
            118,                    # v - Event  47 - Volume Down

            # Beyond the standard button range on the Picade
            105,                    # i - Event     - MOSI
            111,                    # o - Event     - MISO
            112,                    # p - Event     - SCLK
            ])

def buttonsGoldenAxe():
    # Golden Axe Buttons
    #   Event Code: 103
    #   Event Code: 108
    #   Event Code: 105
    #   Event Code: 106
    #
    #   Event Key: X Event Code: 57
    #   Event Key: X Event Code: 56
    #   Event Key: X Event Code: 42
    #   Event Key: X Event Code: 29
    #   Event Key: y Event Code: 44
    #   Event Key: x Event Code: 45
    #
    #   Event Key: X Event Code: 28
    #   Event Key: ^ Event Code: 1
    #   Event Key: c Event Code: 46
    #   Event Key: s Event Code: 31

    # Golden Axe Buttons New
    #   Event Code: 103
    #   Event Code: 108
    #   Event Code: 105
    #   Event Code: 106
    #
    #   Event Key: x Event Code: 45
    #   Event Key: y Event Code: 44
    #   Event Key: X Event Code: 42
    #   Event Key: X Event Code: 57
    #   Event Key: X Event Code: 29
    #   Event Key: X Event Code: 56
    #
    #   Event Key: ^ Event Code: 1
    #   Event Key: X Event Code: 28
    #   Event Key: c Event Code: 46
    #   Event Key: s Event Code: 31
    #
    #   Event Key: b Event Code: 48
    #   Event Key: v Event Code: 47

    # Golden Axe box mappings
    return([picade.KEY_UP_ARROW,    #   - Event 103 - Joy U
            picade.KEY_DOWN_ARROW,  #   - Event 108 - Joy D
            picade.KEY_LEFT_ARROW,  #   - Event 105 - Joy L
            picade.KEY_RIGHT_ARROW, #   - Event 106 - Joy R

             32,       # Space in ASCII - Event  57 - Btn 4
            122,                    # z - Event  44 - Btn 2
            120,                    # x - Event  45 - Btn 1
            picade.KEY_LEFT_SHIFT,  #   - Event  42 - Btn 3
            picade.KEY_LEFT_CTRL,   #   - Event  56 - Btn 6
            picade.KEY_LEFT_ALT,    #   - Event  29 - Btn 5

            115,                    # s - Event  31 - Start
             99,                    # c - Event  46 - Coin
            picade.KEY_ESC,         #   - Event   1 - Escape
            picade.KEY_RETURN,      #   - Event  28 - Enter

             98,                    # b - Event  48 - Volume up
            118,                    # v - Event  47 - Volume Down

            # Beyond the standard button range on the Picade
            105,                    # i - Event     - MOSI
            111,                    # o - Event     - MISO
            112,                    # p - Event     - SCLK
            ])


def buttonsGyruss():
    # Gyruss Buttons
    #   Event Code: 103
    #   Event Code: 108
    #   Event Code: 105
    #   Event Code: 106
    #
    #   Event Key: X Event Code: 29
    #   Event Key: X Event Code: 56
    #   Event Key: X Event Code: 42
    #   Event Key: X Event Code: 57
    #   Event Key: y Event Code: 44
    #   Event Key: x Event Code: 45
    #
    #   Event Key: X Event Code: 28
    #   Event Key: ^ Event Code: 1
    #   Event Key: c Event Code: 46
    #   Event Key: s Event Code: 31

    # Gyruss New Buttons
    #   Event Code: 103
    #   Event Code: 108
    #   Event Code: 105
    #   Event Code: 106
    #
    #   Event Key: x Event Code: 45
    #   Event Key: y Event Code: 44
    #   Event Key: X Event Code: 42
    #   Event Key: X Event Code: 57
    #   Event Key: X Event Code: 29
    #   Event Key: X Event Code: 56
    #
    #   Event Key: ^ Event Code: 1
    #   Event Key: X Event Code: 28
    #   Event Key: c Event Code: 46
    #   Event Key: s Event Code: 31
    #
    #   Event Key: b Event Code: 48
    #   Event Key: v Event Code: 47

    # Gyruss mappings
    return([picade.KEY_UP_ARROW,    #   - Event 103 - Joy U
            picade.KEY_DOWN_ARROW,  #   - Event 108 - Joy D
            picade.KEY_LEFT_ARROW,  #   - Event 105 - Joy L
            picade.KEY_RIGHT_ARROW, #   - Event 106 - Joy R

            120,                    # x - Event  45 - Btn 1
            122,                    # z - Event  44 - Btn 2
             32,       # Space in ASCII - Event  57 - Btn 4
            picade.KEY_LEFT_SHIFT,  #   - Event  42 - Btn 3
            picade.KEY_LEFT_CTRL,   #   - Event  56 - Btn 6
            picade.KEY_LEFT_ALT,    #   - Event  29 - Btn 5


            115,                    # s - Event  31 - Start
             99,                    # c - Event  46 - Coin
            picade.KEY_ESC,         #   - Event   1 - Escape
            picade.KEY_RETURN,      #   - Event  28 - Enter

             98,                    # b - Event  48 - Volume up
            118,                    # v - Event  47 - Volume Down

            # Beyond the standard button range on the Picade
            105,                    # i - Event     - MOSI
            111,                    # o - Event     - MISO
            112,                    # p - Event     - SCLK
            ])

print "Current configuration: "
picade.dump()
print "Setting new bindings"
picade.bind(buttonsGyruss())
print "Setting default volume"
picade.command('--------------------++++++++++++++++')
print "Saving"
picade.save()
