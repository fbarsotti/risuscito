# Piano: refactor della UI di modifica del canto

## Contesto
In modalità modifica la pagina del canto impila quattro righe: −1/valore/+1, "Ripristina", il pulsante barré, un altro "Ripristina", più due `Divider` Material. Occupano circa 180 pt in alto e, su un iPhone SE, al canto resta meno di metà schermo. Il barré si sceglie da un action sheet con 13 voci, e l'offset di trasposizione può crescere senza limite ("+14"). La barra audio ha 64 pt fissi di margine sotto.

Obiettivo: una barra compatta in basso con la stessa funzionalità, un offset limitato con modulo 12 e una barra audio più bassa.

**Decisioni dell'utente, da rispettare:**
- Ingresso da "…" → "Modifica" e spunta di chiusura: **invariati**.
- Due ripristini **separati**: uno per gli accordi, uno per il barré.
- Il badge "+x" e la riga del barré nel testo del canto restano **esattamente** come sono.
- **Niente tonalità nel badge.** Era stata provata ricavandola dal primo accordo, poi scartata: il primo accordo non è sempre la tonica (su 234 canti italiani il primo e l'ultimo accordo coincidono solo nel 51%) e alcuni canti modulano. Una tonalità a volte sbagliata è peggio di nessuna.
- Modulo 12 con intervallo **da −11 a +11**: arrivato a ±12 torna a 0 e il segno si mantiene.
- **Niente** conservazione dello scroll: la ricarica della WebView resta com'è.
- La barra di modifica va **in basso, sopra l'audio**, e la barra audio va abbassata.

## Branch (primo passo, richiesto dall'utente)
1. `git checkout main && git pull --ff-only`, poi `git checkout -b song-edit-ui`.
2. Copiare questo piano in `docs/plans/song-edit-ui.md`, fare un commit (`docs: add song edit UI refactor plan`) e `git push -u origin song-edit-ui`.
3. Poi fermarsi: l'implementazione parte solo su conferma dell'utente.

La pagina del canto non è toccata da `search-refactor`, quindi non ci sono conflitti.

## Modifiche

### 1. Nuovo `lib/feature/songs/presentation/sections/edit/song_edit_bar.dart`
Sostituisce `song_transposer.dart` e `barre_selector_button.dart`, che vengono eliminati. È una riga unica di circa 50 pt:
```
│  −   +2   +   ↺   │   Barré III ▾   ↺  │
```
- `StatelessWidget` con parametri `transposeOffset`, `onTranspose(int delta)`, `onTransposeReset`, `barreOffset` (int?), `onBarreChanged(int)`, `onBarreReset` e `bottomPadding`.
- I pulsanti sono `CupertinoButton` con icone `CupertinoIcons.minus`, `plus` e `arrow_counterclockwise`, con `minSize` 44 per i tap target.
- Il ↺ degli accordi è disattivato quando l'offset è 0; quello del barré quando `barreOffset == null`.
- Valore centrale: "+2" / "−3" / "0". La dicitura lunga "Tonalità originale" in una sola riga non ci sta.
- Etichetta del barré, corta:
  - `null` → `barre_original` ("Barré originale", chiave esistente);
  - `0` → `barre_without`;
  - `n` → nuova chiave `barre_short` ("Barré %s").
- Tocco sull'etichetta del barré: `showCupertinoModalPopup` con un `CupertinoPicker` a rotella (Senza barré, I…XII) e un pulsante "Fatto". Il valore si applica **solo con Fatto**, per non ricaricare la WebView a ogni scatto della rotella.
- Sfondo `CupertinoColors.systemFill` con un bordo superiore sottile, come la barra audio. Niente `Divider` Material.
- Riusa il `_toRoman` di `barre_selector_button.dart`, spostato qui.

### 2. `lib/feature/songs/presentation/sections/song_page.dart`
- Rimuovere `SongTransposer` e `BarreSelectorButton` dalla cima della `Column`.
- Inserire `SongEditBar` (se `_editingTranspose`) **tra** la WebView (`Expanded`) e `SongRecording`.
- `bottomPadding`: se il canto non ha audio (`widget.url` nullo o vuoto) la barra è l'ultimo elemento e riceve `MediaQuery.of(context).padding.bottom`; altrimenti 0.
- `_updateTranspose`: `transposeOffset = (transposeOffset + delta).remainder(12)`. `remainder` mantiene il segno: +12 → 0, −12 → 0, −1 → −1.
- Il reset degli accordi resta come oggi: `_updateTranspose(-transposeOffset)`. Il reset del barré e `onBarreChanged` restano identici, cioè `saveBarreOffset`, `clearBarreOffset` e `_loadAndDisplay`.

### 3. `lib/feature/songs/presentation/sections/song_recording.dart` (circa righe 133-182)
- Padding: `top: 8`, `bottom: MediaQuery.of(context).padding.bottom + 8` al posto dei 64 fissi.
- Pulsante play: padding da 16 a 10.
- Guadagno di circa 40–50 pt, di più su SE.

### 4. `lib/core/utils/chord_transposer.dart`
- `loadTransposeOffset`: restituisce il valore salvato `.remainder(12)`, per normalizzare le preferenze già salvate fuori intervallo.
- Nessun'altra modifica: badge e logica di trasposizione invariati.

### 5. i18n (`i18n/it.json`, `en.json`, `uk.json`, `tr.json`)
- Aggiungere `barre_short`: it "Barré %s", en "Barre %s", uk "Барре %s", tr "Bare %s".
- `original_key` non serve più nella barra, ma la lascio nei file.

## Verifica
1. `flutter analyze`: 0 errori e 0 warning.
2. `flutter build ios --simulator --debug`.
3. Prove manuali in simulatore (le fa l'utente, o io se c'è il simulatore attivo):
   - Da +11 premendo + si va a 0 e il badge sparisce. Da 0 premendo − si va a −1 (badge "-1").
   - Barré: rotella, Fatto, la riga nel canto si aggiorna. Il ↺ del barré torna all'originale senza toccare gli accordi, e viceversa.
   - Canto **senza audio**: la barra resta sopra la home indicator. Canto **con audio**: barra di modifica sopra l'audio, audio più basso.
   - iPhone SE e iPhone 17 Pro, tema chiaro e scuro.
4. Commit sul branch `song-edit-ui`. Push e merge solo dopo le prove d'uso dell'utente.
