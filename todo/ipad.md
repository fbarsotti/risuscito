# iPad: idee per una versione dedicata (2.2)

Obiettivo: rendere l'app "da iPad" sugli schermi larghi, lasciando identico il layout iPhone.

## Principio guida

- Decidere il layout in base alla **larghezza disponibile**, non al tipo di dispositivo: su iPad l'app può essere a schermo intero, in Split View o in Slide Over.
- Sotto la soglia (circa 600-700 pt) si usa il layout iPhone di oggi; sopra, quello iPad.
- Tutto su un branch dedicato, con prove su iPhone, iPad a schermo intero e iPad in Split View.

## Già fatto (2.1.0)

- Home: contenuto in una colonna centrata di 700 pt, e le tre card de "La tua raccolta" dividono la riga in parti uguali (`home_page.dart`, `quick_actions.dart`).

## Da fare

### Barra laterale al posto della tab bar (effort M-L, 3-5 giorni)
- Sugli schermi larghi la navigazione principale va in una colonna a sinistra, come in Note, Musica e File.
- Voci: Cerca, Home, Indice, più Preferiti, Liste e Cronologia, che su iPhone sono raggiungibili dalla Home.
- Sotto la soglia di larghezza resta l'attuale `CupertinoTabScaffold`.
- Attenzione a non perdere la correzione per la tastiera: oggi `CupertinoTabScaffold` è avvolto in `IgnoreKeyboardInsets` (`home.dart`), e lo stesso principio va applicato al nuovo contenitore.

### Larghezza di lettura per le altre pagine (effort S, circa 1 giorno)
- Come in home: contenuto in una colonna centrata di larghezza massima (circa 700 pt) invece di stirarsi su tutto lo schermo.
- Pagine: Impostazioni, Aiuto, Prepara la Parola/l'Eucarestia, liste e dettaglio lista, indici.

### Popover invece dei fogli dal basso (effort S, ½-1 giorno)
- Sugli schermi larghi, il menu "…" della pagina del canto e la scelta del barré si aprono in un riquadro attaccato al pulsante (stile iPad), invece che come foglio a tutta larghezza dal basso.

## Scartato

- **Elenco e canto affiancati (master-detail)**: non serve.
- **Scorciatoie da tastiera** (⌘F, frecce): non servono.

## Non necessario

- **Schermo sempre acceso sulla pagina del canto**: esiste già. È l'impostazione `always_on`, attiva di default, gestita in `song_recording.dart`, che si attiva aprendo un canto e si disattiva uscendo.
- **Testo del canto più grande o regolabile**: su iPad è già ben leggibile, da rivalutare solo se emergono richieste.
