# Pasul 1 — Analiza diferențierii

> Stare: **în așteptarea confirmării**. Numele aplicației este încă `[NUME_APLICAȚIE]`.
>
> Notă de metodă: coloanele despre concurență descriu comportamentul lor pe piața din România așa cum îl cunoaștem la data redactării (noiembrie 2026). Trebuie reverificate înainte de orice comunicare publică sau material de marketing comparativ.

## 1. Teza de produs

OLX, Vinted și Facebook Marketplace sunt construite în jurul **anunțului**: un text cu poze, pus într-o listă, pe care cumpărătorul îl găsește derulând. Tot riscul (stare reală, preț corect, întâlnire, plată) rămâne la utilizatori.

`[NUME_APLICAȚIE]` este construită în jurul **obiectului și al predării lui**:

| Axa | Concurența | Noi |
|---|---|---|
| Unitatea de bază | Anunțul (efemer, dispare la vânzare) | Obiectul (persistă, cu pașaport, trece de la un proprietar la altul) |
| Cine inițiază | Vânzătorul publică, cumpărătorul caută | Ambele sensuri: „Caut” + Dulap produc potriviri fără căutare |
| Încrederea | Reputație generală a contului (stele) | Dovezi despre obiect + atribute verificate despre persoană |
| Prețul | Ce cer alții acum | Cu cât s-a vândut efectiv |
| Momentul critic | Lăsat în afara aplicației | Predarea: escrow, QR, loc sigur, locație partajată |

Tot ce urmează derivă din aceste cinci alegeri.

## 2. Tabel comparativ pe funcții

Legendă: ✗ = nu există · ◐ = există parțial / sub altă formă · ✓ = există

| # | Funcție | OLX | Vinted | FB Marketplace | Ce facem diferit și de ce |
|---|---|---|---|---|---|
| 1 | **Pașaportul obiectului** | ✗ Descriere liberă | ✗ Descriere liberă; verificare de autenticitate doar pentru articole scumpe | ✗ | Istoricul (an achiziție, bon, reparații, nr. proprietari) e o entitate separată de anunț, care **supraviețuiește vânzării** și se transferă la revânzare. Creează un efect de rețea pe care un anunț clasic nu-l poate avea: un obiect revândut în aplicație valorează mai mult decât unul venit din afară. |
| 2 | **Fotografiere ghidată + stare pe 5 niveluri** | ◐ Câmp „nou/utilizat”, poze libere | ◐ Scară de stare, dar fără criterii verificabile și fără poze obligatorii | ◐ Listă de stări, poze libere | Camera cere cadrele care **dovedesc** starea (ecran aprins, sănătatea bateriei, etichetă, defecte). Nivelul de stare rezultă din criterii bifate, nu din autoevaluare. Reduce principala sursă de dispute: „nu arată ca în poze”. |
| 3 | **Preț corect din vânzări finalizate + reducere automată** | ◐ Sugestii bazate pe anunțuri active | ◐ Sugestii pe articole similare listate | ✗ | Prețurile cerute sunt umflate; doar prețul de tranzacție e real, iar noi îl avem pentru că plata trece prin escrow. Reducerea automată cu prag minim înlocuiește ritualul „mai lași din preț?” și ține anunțurile vechi în mișcare. |
| 4 | **„Caut” (cereri publicate)** | ◐ Căutări salvate cu alertă, private | ◐ Căutări salvate, private | ◐ Postări „caut” neformalizate în grupuri | Cererea e un **obiect public structurat** (categorie, buget, rază, stare minimă), potrivit automat cu anunțuri și cu Dulapul. Vânzătorul află că are un cumpărător înainte să publice ceva. |
| 5 | **Dulapul virtual** | ✗ | ✗ | ✗ | Inventar de obiecte **nelistate**. Captează oferta latentă (lucrurile pe care omul le-ar vinde „dacă ar cere cineva”) și e principala noastră armă la cold start: potrivirile vin din Dulap chiar când sunt puține anunțuri active. |
| 6 | **Troc și oferte mixte** | ◐ Bifă „schimb”, negociere în text liber | ◐ Doar pachete/oferte de preț | ✗ | Oferta e un mesaj structurat în chat: obiect(e) din anunțuri sau Dulap ± diferență în bani, cu accept/contraofertă. Diferența în bani trece prin același escrow; ambele pașapoarte se transferă. |
| 7 | **„Golesc casa” (lot)** | ✗ Anunțuri separate | ◐ „Pachet” cu reducere din garderoba unui vânzător | ✗ | Un singur anunț, zeci de obiecte, o singură ridicare. Cumpărătorul bifează, prețul total se recalculează (cu reducere pe volum definită de vânzător). Optimizează pentru timpul vânzătorului care se mută, nu pentru prețul maxim pe bucată. |
| 8 | **Predare cu QR + escrow față în față** | ◐ Plată reținută doar la livrarea prin curier | ◐ Protecția cumpărătorului doar la livrare | ✗ În România fără plăți integrate | Escrow și pentru **întâlnirea în persoană**, unde azi se întâmplă majoritatea tranzacțiilor locale și unde nimeni nu oferă protecție. Scanarea QR-ului este gestul unic care confirmă predarea și eliberează banii — fără numerar, fără „îți fac transfer acum”. |
| 9 | **Puncte de întâlnire sigure + locație partajată** | ✗ | ✗ (model axat pe livrare) | ✗ | Harta propune locuri publice, luminate, cu camere; întâlnirea e programată în chat, iar locația poate fi urmărită de o persoană de încredere printr-un link temporar. Răspunde direct fricii reale de a te vedea cu un străin. |
| 10 | **Reputație pe atribute** | ◐ Evaluări cu notă | ◐ Stele + comentariu | ◐ Evaluări cu notă și etichete | Fără medie numerică. Insignele („punctual”, „conform descrierii”, „răspunde rapid”, „ambalare atentă”) se acordă doar după tranzacții finalizate prin escrow și apar abia peste un prag minim de confirmări. O medie de 4,8 nu spune nimic; „punctual ×23” spune exact ce vrei să știi. |
| 11 | **Contor de impact (CO₂, deșeuri)** | ✗ | ◐ Mesaje generale de sustenabilitate | ✗ | Estimare personală, pe categorii, cu metodologia afișată. Stă în profil, nu pe ecranul principal: fără clasamente, serii sau notificări. |
| 12 | **Auto: VIN, checklist, alertă km** | ◐ Autovit/OLX: verificări de istoric plătite, prin parteneri | ✗ | ✗ | Categorie secundară, dar tratată cu aceeași logică de pașaport: documente încărcate (ITP, service), checklist la vizionare, semnal automat când kilometrajul declarat contrazice istoricul. |
| 13 | **Anti-fraudă în chat** | ◐ Avertismente generice, filtre de linkuri | ◐ Avertismente, mesagerie închisă | ◐ Avertismente generice | Linkurile, IBAN-urile și numerele de telefon sunt **mascate implicit** până la o tranzacție confirmată; tiparele de tip „curier/link de plată” declanșează un avertisment în context, lângă mesajul suspect. Putem fi stricți pentru că plata și predarea se întâmplă oricum în aplicație. |
| 14 | **Ecran principal** | Feed/grilă infinită | Feed personalizat infinit | Grilă infinită | Trei secțiuni finite: **„Aproape de tine azi”** (hartă), **colecții curatoriate** și **potriviri** cu cererile și Dulapul tău. Ecranul are un capăt — utilizatorul vine cu o intenție, nu ca să deruleze. |
| 15 | **Publicare** | Formular lung | Formular mediu | Formular scurt, calitate slabă | Sub 60 s: fotografierea ghidată produce cadrele, AI propune titlu/categorie/descriere (editabile), pașaportul se completează opțional ulterior. Viteză fără pierderea structurii. |

## 3. Unde nu suntem diferiți (și e în regulă)

- **Livrarea prin curier** cu plată reținută este deja standard la OLX și Vinted. O oferim (eliberare la confirmare sau după 48 h fără dispută), dar nu e un argument de diferențiere.
- **Filtrele de căutare** și **căutările salvate** sunt convenții pe care utilizatorii le așteaptă; le păstrăm.
- **Chatul** ca atare există peste tot. Diferența stă în ofertele structurate și în mascarea datelor de contact.

## 4. Riscuri ale diferențierii înseși

| Alegere | Risc | Atenuare |
|---|---|---|
| Fără feed infinit | Timp mai mic în aplicație, percepția de „puține anunțuri” | Măsurăm tranzacții finalizate și potriviri, nu timp petrecut; harta și colecțiile se actualizează zilnic |
| Mascarea contactelor în chat | Frustrare la utilizatorii obișnuiți să „treacă pe WhatsApp” | Explicație în context + programarea întâlnirii și apel în aplicație, ca să nu fie nevoie de număr |
| Escrow la întâlnire | Fricțiune față de numerar; comision | Comision vizibil și mic; numerarul rămâne permis, dar fără insigne și fără protecție |
| Fotografiere ghidată | Publicare percepută ca mai lungă | Minim 3 cadre obligatorii pe categorie; restul opționale, cu beneficiu vizibil („anunț verificat”) |
| Pașaport | Gol la început, valoare mică | Câmpuri opționale, completare progresivă; valoarea reală apare de la a doua vânzare a aceluiași obiect |
| Preț din vânzări finalizate | Lipsă de date la lansare | Interval afișat doar peste un prag de eșantion; sub prag, spunem deschis „date insuficiente” |

## 5. Decizii deschise înainte de Pasul 2

1. **Numele aplicației** — înlocuiește `[NUME_APLICAȚIE]` în pachete, bundle ID-uri și texte.
2. **Procesatorul de plăți** — recomandare: Stripe Connect, în spatele unei interfețe `PaymentProvider`, astfel încât Netopia să poată fi adăugat ulterior fără schimbări în aplicațiile mobile.
3. **Backend** — recomandare: NestJS (TypeScript) + PostgreSQL/PostGIS + Redis + Meilisearch + S3; justificarea completă vine în Pasul 2.
