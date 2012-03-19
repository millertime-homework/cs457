module MoveAlong where

-- Move Along, by the All-American Rejects

import Haskore.Music (changeTempo, wnr, hnr, qnr, enr, snr, (=:=))
import Haskore.Basic.Duration (hn, qn, en, den, sn)
import Haskore.Composition.Trill
import Sound.MIDI.General as GM
import Haskore.Interface.MIDI.Render as Render
import Haskore.Composition.Drum
import Haskore.Melody.Standard (NoteAttributes, )

import qualified Haskore.Music as Music
--import qualified Haskore.Melody.Standard as Melody

myshit :: NoteAttributes
myshit  = NoteAttributes 0.5 (0,0) (0,0)

main = Render.fileFromGeneralMIDIMusic "movealong.midi" song

song = hiHatRoll

hiHatRoll = changeTempo 3
          $ Music.take 12
          $ Music.repeat
          $ low =:= hi =:= snare =:= hiHat

low   = let k1  = toMusic GM.HighFloorTom den myshit
            k2  = toMusic GM.HighFloorTom en myshit
            k3  = toMusic GM.HighFloorTom qn myshit
        in Music.line [k1, snr, enr, k2, qnr, k3, k1, snr, enr, k2, qnr, k2, enr]

hi    = let k1  = toMusic GM.HiMidTom sn myshit
            k2  = toMusic GM.HiMidTom den myshit
        in Music.line [enr, snr, k1, snr, qnr, snr, k2, qnr, enr, snr, k1, qnr, snr, k2]

snare = let psk = toMusic GM.AcousticSnare sn myshit
        in Music.line [wnr, hnr, qnr, enr, psk, psk]

hiHat = roll qn (toMusic GM.ClosedHiHat 2 myshit)
{-
bassKick = 
        let k1 = toMusic GM.BassDrum1 hn (NoteAttributes .5 (0,0) (0,0)) -- half note kick
            k2 = toMusic GM.BassDrum1 en (NoteAttributes .5 (0,0) (0,0)) -- eighth note kick
        in Music.line [k1, enr, k2, enr, k2, k2, k2, qnr, enr, k2]
-}