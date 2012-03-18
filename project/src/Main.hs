module Main where

import Haskore.Music (changeTempo, qnr, (=:=)) -- (qnr, enr, (=:=), changeTempo, rest, )
import Haskore.Basic.Duration (qn, en)
import Haskore.Composition.Trill
import Sound.MIDI.General as GM
import Haskore.Interface.MIDI.Render as Render
import Haskore.Composition.Drum

import qualified Haskore.Music as Music

main = Render.fileFromGeneralMIDIMusic "speeditup.midi" song

song = hiHatRoll

hiHatRoll = changeTempo 3
          $ Music.take 4
          $ Music.repeat
          $ hiHat =:= bassKick =:= snare

snare = let psk = toMusic GM.AcousticSnare qn na
        in Music.line [qnr, qnr, psk, qnr, qnr, qnr, psk, qnr]

hiHat = roll en (toMusic GM.ClosedHiHat 2 na)

bassKick = 
        let kick = toMusic GM.BassDrum1 qn na
        in Music.line [kick, qnr, qnr, qnr, kick, kick, qnr, qnr]