# Pasul 4a — Fundația și fluxul de onboarding

> Stare: **în lucru**. Această specificație este comună celor trei aplicații; implementările trebuie să se comporte identic.

## 1. Decizii de UX

| Decizie | Justificare |
|---|---|
| Cont doar cu numărul de telefon și cod SMS, fără parolă | Telefonul este oricum prima treaptă de verificare; o parolă ar fi un al doilea lucru de ținut minte și de furat. |
| Consimțămintele vin **după** verificarea telefonului | Până atunci nu prelucrăm nimic în afară de număr; după, le putem lega de un cont și de o versiune de politică. |
| Opționalele (marketing, analiză, AI pe fotografii) sunt debifate implicit | Cerință GDPR: consimțământul nu poate fi presupus. |
| Cerem locația cu explicație și cu alternativă manuală (alegerea orașului) | Ecranul principal este „Aproape de tine azi”; fără o zonă nu are ce arăta. Cine refuză permisiunea nu e blocat. |
| Coordonatele se rotunjesc la 2 zecimale (~1 km) înainte de trimitere | Zona de acasă nu are nevoie de adresa exactă. |
| Interesele sunt opționale și se pot sări | Ajută la colecții și potriviri, dar nu condiționăm intrarea în aplicație. |
| **Nu** cerem permisiunea de notificări la onboarding | O cerem la primul moment în care are sens (primul mesaj trimis, primul anunț publicat); rata de acceptare e mai mare și cererea are context. |
| Fluxul se poate relua | Pasul curent se păstrează local; dacă aplicația e închisă, utilizatorul revine unde a rămas. |

## 2. Ecrane

| # | Ecran | Conținut | Apel API | Trecere mai departe |
|---|---|---|---|---|
| 1 | `Welcome` | Trei afirmații despre produs, buton „Începe” | — | → 2 |
| 2 | `Phone` | Prefix fix `+40`, câmp numeric | `POST /auth/otp/request` | Număr valid și răspuns 202 → 3 |
| 3 | `Code` | 6 cifre, trimitere automată la a 6-a, retrimitere după numărătoare inversă (`retryAfterSeconds`) | `POST /auth/otp/verify` | Tokenurile se salvează securizat. Dacă `user.onboardingCompleted` → Acasă; altfel → 4 |
| 4 | `Consents` | Termeni și Confidențialitate (obligatorii), trei opționale | `PUT /me/consents` | Ambele obligatorii bifate → 5 |
| 5 | `Name` | Nume afișat, 2–40 de caractere | `PATCH /me` | → 6 |
| 6 | `Location` | Explicație, „Folosește locația mea”, „Aleg orașul” | `PATCH /me` (`homeLocation`); la permisiune acordată și `PUT /me/consents` cu `LOCATION` | → 7 |
| 7 | `Interests` | Categoriile de nivel superior, selecție multiplă, „Sari peste” | `GET /categories`, `PATCH /me` (`interestCategoryIds`, `onboardingCompleted: true`) | → Acasă |

„Acasă” este, în acest pas, un ecran provizoriu cu salutul „Bună, {nume}” și butonul „Ieși din cont” (`POST /auth/logout`, apoi ștergerea sesiunii locale). Conținutul real vine în pasul 4c.

## 3. Reguli

- **Număr de telefon.** Se acceptă `07XXXXXXXX`, `7XXXXXXXX` și `+407XXXXXXXX`, cu sau fără spații. Forma trimisă este `+407XXXXXXXX` (E.164). Orice altceva afișează eroarea de validare, fără apel la server.
- **Cod.** Exact 6 cifre. Eroarea `OTP_INVALID` golește câmpul și afișează mesajul; `RATE_LIMITED` afișează mesajul și blochează retrimiterea până la expirarea numărătorii.
- **Versiunea politicii** trimisă la consimțăminte: `2026-11`.
- **Orașe pentru alegerea manuală** (nume, lat, lng): București 44.43, 26.10 · Cluj-Napoca 46.77, 23.60 · Timișoara 45.76, 21.23 · Iași 47.16, 27.59 · Constanța 44.18, 28.63 · Brașov 45.65, 25.60 · Craiova 44.32, 23.80 · Galați 45.44, 28.05 · Oradea 47.05, 21.93 · Sibiu 45.80, 24.15.
- **Sesiune.** Tokenul de acces se atașează la fiecare cerere autentificată. La 401, clientul face o singură reîmprospătare (`POST /auth/refresh`), serializată între cererile concurente, apoi repetă cererea o dată. Dacă serverul respinge reîmprospătarea, sesiunea se șterge și utilizatorul ajunge la `Welcome`. Dacă reîmprospătarea eșuează din cauza rețelei, sesiunea se păstrează și se afișează eroarea de conexiune.
- **Erori.** Corpul `application/problem+json` se transformă în `AppError(code, status)`. Textul afișat vine din resursele aplicației, pe baza lui `code`; `detail` de la server nu se afișează. Fără rețea → mesajul de conexiune.
- **Accesibilitate.** Ținte de atingere de minimum 48 dp / 44 pt; etichete pentru cititoarele de ecran pe toate controalele; erorile se anunță (live region / `accessibilityAnnouncement`); niciun text cu dimensiune fixă care să nu scaleze; mod deschis și întunecat din `design/tokens.json`.

## 4. Texte (română; cheia este comună pe platforme)

| Cheie | Text |
|---|---|
| `welcome_title` | Lucrurile bune merită o a doua casă |
| `welcome_point_passport` | Fiecare obiect are un pașaport cu istoricul lui |
| `welcome_point_handover` | Plătești în siguranță și primești banii la predare |
| `welcome_point_wanted` | Spui ce cauți și primești potriviri |
| `welcome_cta` | Începe |
| `phone_title` | Care este numărul tău de telefon? |
| `phone_subtitle` | Îți trimitem un cod prin SMS ca să-ți confirmăm numărul. |
| `phone_label` | Număr de telefon |
| `phone_error_invalid` | Introdu un număr de mobil valid, de exemplu 0712 345 678. |
| `phone_cta` | Trimite codul |
| `code_title` | Introdu codul primit |
| `code_subtitle` | Am trimis un cod din 6 cifre la {phone}. |
| `code_label` | Cod de verificare |
| `code_resend` | Retrimite codul |
| `code_resend_in` | Poți retrimite codul în {seconds} s |
| `consents_title` | Înainte să continui |
| `consent_terms` | Sunt de acord cu Termenii și condițiile |
| `consent_privacy` | Am citit Politica de confidențialitate |
| `consent_marketing` | Vreau să primesc noutăți și oferte |
| `consent_analytics` | Ajut la îmbunătățirea aplicației cu date de utilizare anonime |
| `consent_ai` | Permit analiza automată a fotografiilor pentru sugestii de titlu și categorie |
| `consents_required_hint` | Primele două sunt necesare pentru a folosi aplicația. |
| `consents_optional_header` | Opțional |
| `name_title` | Cum vrei să-ți spunem? |
| `name_subtitle` | Numele apare în profilul tău și în conversații. |
| `name_label` | Nume afișat |
| `name_error_length` | Numele trebuie să aibă între 2 și 40 de caractere. |
| `location_title` | Unde ești de obicei? |
| `location_subtitle` | Îți arătăm ce e aproape de tine. Păstrăm doar zona aproximativă, nu adresa. |
| `location_use_mine` | Folosește locația mea |
| `location_pick_city` | Aleg orașul |
| `location_denied` | Nu avem acces la locație. Poți alege orașul din listă. |
| `interests_title` | Ce te interesează? |
| `interests_subtitle` | Alege câteva categorii. Le poți schimba oricând. |
| `interests_skip` | Sari peste |
| `action_continue` | Continuă |
| `action_finish` | Gata |
| `home_greeting` | Bună, {name} |
| `home_placeholder` | Ecranul principal este în lucru. |
| `action_logout` | Ieși din cont |
| `error_otp_invalid` | Codul nu este corect sau a expirat. |
| `error_rate_limited` | Prea multe încercări. Încearcă din nou peste câteva minute. |
| `error_network` | Nu există conexiune la internet. Verifică rețeaua și încearcă din nou. |
| `error_generic` | Ceva nu a mers. Încearcă din nou. |

Engleza (`en`) este a doua limbă; traducerile se adaugă în fișierele de resurse ale fiecărei platforme.

## 5. Mod demonstrativ (fără backend)

Backend-ul nu este încă implementat. Ca fluxurile să poată fi rulate și testate, fiecare aplicație are, **doar în build-urile de dezvoltare**, un API simulat care răspunde cu fișierele din `api/fixtures/`:

- orice număr valid primește răspunsul de trimitere a codului;
- codul `123456` autentifică; orice alt cod întoarce `OTP_INVALID`;
- `PATCH /me` și `PUT /me/consents` păstrează modificările în memorie pe durata rulării.

Modul demonstrativ este exclus din build-urile de lansare. Testele de contract decodează aceleași fixture-uri pe toate cele trei platforme.

## 6. Ce conține fundația (comun pentru pașii următori)

| Zonă | Android | Flutter | iOS |
|---|---|---|---|
| Rețea | Retrofit + OkHttp, `AuthInterceptor`, `TokenAuthenticator` | Dio + interceptori | `APIClient` pe `URLSession`, actor de reîmprospătare |
| Stocare tokenuri | Keystore | `flutter_secure_storage` | Keychain |
| Stare locală a onboardingului | Room | Drift | SwiftData |
| Temă | Material 3 din `tokens.json`, Manrope | `ThemeData` din `tokens.json`, Manrope | Culori și fonturi din `tokens.json`, Manrope |
| Certificate pinning | `CertificatePinner`, pinuri din configurare | Validare de amprentă în adaptorul HTTP | `URLSessionDelegate` |

Pinurile reale de certificat se adaugă când există domeniul de producție; până atunci mecanismul e prezent și dezactivat pentru API-ul simulat.
