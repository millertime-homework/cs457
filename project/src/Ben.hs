module Ben where

import Haskore.Music (changeTempo, qnr, enr, (=:=))
import Haskore.Basic.Duration (hn, qn, en)
import Haskore.Composition.Trill
import Sound.MIDI.General as GM
import Haskore.Interface.MIDI.Render as Render
import Haskore.Composition.Drum

import qualified Haskore.Music as Music

main = Render.fileFromGeneralMIDIMusic "ben.midi" song

song = hiHatRoll

hiHatRoll = changeTempo 3
          $ Music.take 12
          $ Music.repeat
          $ hiHat =:= bassKick =:= snare

snare = let psk = toMusic GM.AcousticSnare hn na
        in Music.line [qnr, qnr, psk, qnr, qnr, psk]

hiHat = roll qn (toMusic GM.ClosedHiHat 2 na)

bassKick = 
        let k1 = toMusic GM.BassDrum1 hn na -- half note kick
            k2 = toMusic GM.BassDrum1 en na -- eighth note kick
        in Music.line [k1, enr, k2, enr, k2, k2, k2, qnr, enr, k2]