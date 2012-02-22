import Haskore.Melody
import Snippet
import MusicTest

main = render_to "music_test.midi" $ make_test 2 (pitch_line [c,d,c]) (pitch_line [c,d,e])