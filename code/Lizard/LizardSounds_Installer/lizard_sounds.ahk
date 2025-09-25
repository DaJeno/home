; Lizard Sounds AutoHotkey Script (v2)
; Press letter keys to play different lizard sounds
; Press Ctrl+letter to see which sound is assigned

; Set working directory to script location
SetWorkingDir(A_ScriptDir)

; Function to get full path
GetFullPath(filename) {
    return A_ScriptDir . "\sounds\" . filename
}

; A - Arabic Lizard Funny
a::SoundPlay(GetFullPath("Arabic Lizard Funny 64716.mp3"), true)

; B - Bryce5
b::SoundPlay(GetFullPath("Bryce5 69848.mp3"), true)

; D - Dash U Lizards
d::SoundPlay(GetFullPath("Dash U Lizards 38582.mp3"), true)

; E - Dash You Lizards (alternative dash sound)
e::SoundPlay(GetFullPath("Dash You Lizards 49167.mp3"), true)

; G - Giant Lizards
g::SoundPlay(GetFullPath("Giant Lizards 25687.mp3"), true)

; H - If You Had Skin Like A Lizard
h::SoundPlay(GetFullPath("If You Had Skin Like A Lizard 80530.mp3"), true)

; I - I Am The Lizard Queen
i::SoundPlay(GetFullPath("I Am The Lizard Queen 90367.mp3"), true)

; J - (placeholder for future sounds)
; j::

; K - K9Kuro Lizard Noise
k::SoundPlay(GetFullPath("K9Kuro Lizard Noise No Bgm 78938.mp3"), true)

; L - Lizard Button (main lizard sound)
l::SoundPlay(GetFullPath("Lizard Button 12218.mp3"), true)

; M - Mlem Mlem Mlem
m::SoundPlay(GetFullPath("Mlem Mlem Mlem 67186.mp3"), true)

; N - (placeholder for future sounds)
; n::

; O - Oblivion Guard Make Fine Boots Lizard
o::SoundPlay(GetFullPath("Oblivion Guard Make Fine Boots Lizard 3789.mp3"), true)

; P - Pl Hate That Fn Lizard
p::SoundPlay(GetFullPath("Pl Hate Thet Fn Lizard 48858.mp3"), true)

; Q - Lizard Queen (duplicate mapping)
q::SoundPlay(GetFullPath("I Am The Lizard Queen 90367.mp3"), true)

; R - Rain World Lizard Hiss
r::SoundPlay(GetFullPath("Rain World Lizard Hiss 1 22773.mp3"), true)

; S - Lizard Stereo
s::SoundPlay(GetFullPath("Lizard Stereo 1 44145.mp3"), true)

; T - Lizard (basic)
t::SoundPlay(GetFullPath("Lizard 52641.mp3"), true)

; U - Lizzard (alternative spelling)
u::SoundPlay(GetFullPath("Lizzard 32991.mp3"), true)

; V - (placeholder for future sounds)
; v::

; W - Lizardman
w::SoundPlay(GetFullPath("Lizardman 11293.mp3"), true)

; X - Lizard Cries
x::SoundPlay(GetFullPath("Lizard Cries 36643.mp3"), true)

; Y - Yeah Baby I Am The Lizard King
y::SoundPlay(GetFullPath("Yeah Baby I Am The Lizard King 56204.mp3"), true)

; Z - Lizard King
z::SoundPlay(GetFullPath("Lizard King 68979.mp3"), true)

; Number keys for additional sounds
1::SoundPlay(GetFullPath("Lizard King Soft 34894.mp3"), true)
2::SoundPlay(GetFullPath("Lizard King22 88618.mp3"), true)
3::SoundPlay(GetFullPath("Lizard Kingg 68001.mp3"), true)
4::SoundPlay(GetFullPath("Lizard Lizard 67770.mp3"), true)
5::SoundPlay(GetFullPath("Lizard Meme 43779.mp3"), true)
6::SoundPlay(GetFullPath("Lizardddddddddddddddd 29616.mp3"), true)
7::SoundPlay(GetFullPath("Lizardon Kaenhosha 82617.mp3"), true)
8::SoundPlay(GetFullPath("Lizzard 1 94606.mp3"), true)
9::SoundPlay(GetFullPath("Lizzardddddddddddddddddddd 63662.mp3"), true)
0::SoundPlay(GetFullPath("Mah Lizard 53459.mp3"), true)

; Special keys for remaining sounds
Space::SoundPlay(GetFullPath("Mushu Dragon Not Lizard 56110.mp3"), true)
Enter::SoundPlay(GetFullPath("Pl Lizard Piss 70857.mp3"), true)
Tab::SoundPlay(GetFullPath("Mlg Lizard 46433.mp3"), true)
Escape::SoundPlay(GetFullPath("Lets Go Lizard 83271.mp3"), true)

; Help function - show key mappings
F1::{
    MsgBox("
    (
LETTER KEYS:
A - Arabic Lizard Funny
B - Bryce5
D - Dash U Lizards
E - Dash You Lizards
G - Giant Lizards
H - If You Had Skin Like A Lizard
I - I Am The Lizard Queen
K - K9Kuro Lizard Noise
L - Lizard Button (main)
M - Mlem Mlem Mlem
O - Oblivion Guard
P - Pl Hate That Fn Lizard
Q - Lizard Queen
R - Rain World Lizard Hiss
S - Lizard Stereo
T - Lizard (basic)
U - Lizzard
W - Lizardman
X - Lizard Cries
Y - Yeah Baby I Am The Lizard King
Z - Lizard King

NUMBER KEYS (1-0):
1-9,0 - Various lizard sounds

SPECIAL KEYS:
Space - Mushu Dragon Not Lizard
Enter - Pl Lizard Piss
Tab - MLG Lizard
Escape - Lets Go Lizard

Press Ctrl+Q to quit
Press F1 to show this help
    )", "Lizard Sounds Key Mappings")
}

; Ctrl+Q to quit
^q::ExitApp()

; Notification on startup
MsgBox("
(
Lizard sound board is ready!
Press F1 for key mappings
Press Ctrl+Q to quit

Total sounds loaded: 36
)", "Lizard Sounds Loaded!")