module Beatz where

import Haskore.Music (changeTempo, qnr, (=:=)) -- (qnr, enr, (=:=), changeTempo, rest, )
import Haskore.Basic.Duration (qn, en)
import Haskore.Composition.Trill
import Sound.MIDI.General as GM
import Haskore.Interface.MIDI.Render as Render
import Haskore.Composition.Drum

import qualified Haskore.Music as Music

renderMidi xs = Render.fileFromGeneralMIDIMusic "newfile.midi" song
    where song = changeTempo 3
               $ Music.take 6
               $ Music.repeat
               $ (foldl (=:=) (Music.line [])) xs
