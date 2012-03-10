module Main where

import Haskore.Basic.Dynamics
import Haskore.Melody
import Haskore.Music.GeneralMIDI as MidiMusic
import Haskore.Interface.MIDI.Render as Render

main = do putStr "Enter a file name: "
          fname <- getLine
          render_to fname melody
          putStrLn ""

render_to f m = Render.fileFromGeneralMIDIMusic f song where
  song = MidiMusic.fromMelodyNullAttr MidiMusic.AcousticGrandPiano m

melody = c 1 4 ()