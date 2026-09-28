# TODO

Idee per l'iPad: vedi [ipad.md](ipad.md).

## Da fare

### Funzionalità
- [ ] Scorrimento automatico del testo del canto
- [ ] Tag nella ricerca dei canti
- [ ] Liste condivisibili (oggi si condividono solo le preparazioni di Parola ed Eucarestia, via WhatsApp o copia del testo)

### Interfaccia
- [ ] Barra di ricerca fissa nella pagina Cerca: oggi scorre insieme ai risultati
- [ ] Ridurre l'altezza del foglio per la scelta della lingua
  > https://jamesblasco.github.io/modal_bottom_sheet/#/
- [ ] La lente di ricerca apre la barra ma non mette a fuoco il campo: serve un secondo tocco
- [ ] Dettaglio lista: rimuovendo un canto con lo swipe mentre la ricerca è attiva, si vede un lampo di caricamento e la tastiera si chiude
- [ ] Rotella del barré: premendo "Ok" senza scorrere, un canto con barré originale passa a "Senza barré"

### Ricerca
- [ ] Ignorare accenti e caratteri speciali: "perche" non trova "perché", "akeda" non trova "Akedà"
- [ ] Turco: "İ" e "ı" non corrispondono a "i" e "I"
- [ ] Riferimenti biblici: il trattino normale non trova il trattino lungo dei dati ("18,1-5" contro "18,1–5")
- [ ] Apostrofo curvo della tastiera iOS contro apostrofo dritto nei titoli

### Dati dei canti
- [ ] Ucraino e turco: le categorie "Comunione" e "Canti per i bambini" hanno il nome in italiano negli XML
- [ ] Ucraino: 10 titoli contengono un backslash letterale (es. `П\'ятидесятниці`)
- [ ] Ucraino e turco: `indice_biblico.xml` è vuoto, quindi il filtro per riferimento biblico non dà risultati

### Pulizia del codice
- [ ] Chiavi di traduzione non più usate: `original_key`, `reset`, `liturgical_index`
- [ ] Dipendenze datate e vincolo SDK `<3.0.0` in `pubspec.yaml`; `DioError` deprecato

### Accantonato
- [ ] Stile Liquid Glass di iOS 26: da rivalutare quando sarà disponibile in `cupertino_ui`

## Fatto

- [x] Ordinamento per ogni indice
- [x] Prestazioni: "Local Server has been stopped." uscendo dalla pagina del canto
- [x] Prestazioni: apertura del canto lentissima con le cuffie collegate
- [x] Lingua ucraina non funzionante
- [x] Cronologia
- [x] Ottimizzazione del lettore audio
- [x] Liste personalizzate
  - [x] Bug uscendo dalla ricerca canti con la tastiera aperta
- [x] Cambio accordi
  - [x] Trasposizione non funzionante
  - [x] Barré assente se non indicato nel canto
- [x] Rimozione del codice duplicato
  - [x] Lingua (impostazioni e onboarding)
  - [x] Lettura delle informazioni dei canti
- [x] Strumenti
  - [x] Prepara l'Eucarestia
  - [x] Prepara la Parola
- [x] Barra di ricerca in ogni indice
- [x] Indice numerico separato da quello alfabetico
- [x] Scatti della tastiera tornando indietro dalle pagine con la ricerca (2.1.0)
- [x] Ricerca lenta con pochi caratteri, soprattutto nel testo (2.1.0)
