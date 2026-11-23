# Direcții de design — de ales înainte de Pasul 4

> Stare: **aleasă direcția B, „Livadă”**. Implementarea fluxurilor pornește de la direcția aleasă, prin `design/tokens.json`.

## Ce evităm

| Concurent | Semnătura vizuală de care ne ținem departe |
|---|---|
| OLX | Verde-petrol închis cu accente turcoaz și galben, grilă de carduri |
| Vinted | Turcoaz, fundal alb, grilă de poze cu două coloane |
| Facebook Marketplace | Albastru, gri neutru, grilă de poze |
| Publi24 | Albastru cu portocaliu |
| Autovit | Roșu aprins cu bleumarin |

Deci: fără turcoaz, fără albastru ca primar, fără portocaliu sau roșu aprins, fără grilă de poze ca tipar dominant.

Rapoartele de contrast de mai jos sunt calculate (formula WCAG) pentru perechile indicate; toate depășesc pragul AA de 4,5:1 pentru text.

---

## A. „Registru” — obiectul ca document

Pornește de la pașaport: fiecare obiect are acte. Interfața arată ca o fișă bine tipărită, nu ca o vitrină.

| Rol | Mod deschis | Mod întunecat |
|---|---|---|
| Fundal | `#F7F3EC` hârtie | `#171412` |
| Text | `#1E1B18` cerneală (15,5:1) | `#F1EBE1` (15,5:1) |
| Text secundar | `#5F574E` (6,4:1) | — |
| Primar | `#6B2346` vișiniu (9,7:1; alb pe primar 10,8:1) | `#E39BBF` (8,5:1) |
| Accent | `#8A5A00` alamă (5,4:1) | — |

- **Tipografie:** titluri cu serif moale (Fraunces), text cu sans neutru (Inter), cifre monospațiate pentru prețuri, ani și coduri (IBM Plex Mono).
- **Iconografie:** linie subțire de 1,5 px; insignele de reputație arată ca ștampile, cu contur și text, nu ca medalii.
- **Forme:** colțuri mici (8 px), linii de separare în loc de umbre, perforații și margini de „cupon” pe cardul de pașaport și pe ecranul QR.
- **Anunțul:** card orizontal cu poză la stânga și trei rânduri de fapte la dreapta (stare, an, proprietari), nu o poză cu preț dedesubt.
- **Risc:** poate părea serios sau „birocratic” pentru haine și jucării; se compensează prin fotografie mare pe ecranul de detaliu.

## B. „Livadă” — cald, casnic, fără grabă

Pornește de la reutilizare și de la „Golesc casa”: lucruri bune care își schimbă casa.

| Rol | Mod deschis | Mod întunecat |
|---|---|---|
| Fundal | `#F4F1E8` in | `#15170F` |
| Text | `#20231A` (14,1:1) | `#ECE9DD` (14,9:1) |
| Primar | `#4F5D23` măsliniu (6,4:1; alb pe primar 7,2:1) | `#B9CC7A` (10,3:1) |
| Accent | `#9B3B2E` cărămidă stinsă (6,1:1) | — |

- **Tipografie:** un singur sans umanist, rotunjit (Manrope), în două greutăți; fără serif.
- **Iconografie:** pictograme pline, în două tonuri, cu forme rotunjite.
- **Forme:** colțuri mari (20 px), suprafețe tonale suprapuse, fără linii.
- **Anunțul:** card lat cu poză pe toată lățimea și o bandă tonală cu starea și distanța.
- **Risc:** verdele, chiar măsliniu, e culoarea pe care piața o asociază cel mai ușor cu second-hand-ul și sustenabilitatea — diferențierea e mai slabă decât la A sau C.

## C. „Semnal” — tehnic, direct, întunecat implicit

Pornește de la predarea securizată: QR, escrow, verificare. Aplicația arată ca un instrument.

| Rol | Mod deschis | Mod întunecat (implicit) |
|---|---|---|
| Fundal | `#F5F4F8` | `#111017` grafit |
| Text | `#16151C` (16,6:1) | `#EDEBF5` (16,0:1) |
| Primar | `#5A2BD6` violet (7,0:1; alb pe primar 7,6:1) | `#B8A2FF` (8,7:1) |
| Accent | — | `#C6F24E` lime (14,6:1; text închis pe lime 12,5:1) |

- **Tipografie:** sans geometric (Space Grotesk) pentru titluri și cifre, Inter pentru text.
- **Iconografie:** pictograme geometrice pline, colțuri drepte; stările (plătit, blocat, eliberat) au culoare și formă proprii.
- **Forme:** colțuri medii (12 px), contururi luminoase în loc de umbre, indicatori de stare de tip „pastilă”.
- **Anunțul:** rând dens, cu poză pătrată mică și date aliniate pe coloane; harta e ecranul dominant.
- **Risc:** atrage publicul de electronice, dar poate îndepărta publicul de haine, mobilă și articole pentru copii, care e majoritar.

---

## Recomandare: A, „Registru”

1. **Decurge din teza de produs.** Diferența noastră este că obiectul are istoric și dovezi; A este singura direcție în care interfața spune asta înainte ca utilizatorul să citească ceva.
2. **E cea mai îndepărtată de concurență.** Nimeni din categorie nu folosește serif, vișiniu sau estetică de document; B și C au rude apropiate în alte aplicații.
3. **Funcționează pe toate categoriile.** Un fundal de hârtie neutru lasă fotografiile să poarte culoarea, de la un telefon la o rochie.
4. **Susține accesibilitatea.** Contrastele sunt cele mai mari dintre cele trei, iar ierarhia se bazează pe tipografie, nu pe culoare.

## De verificat după alegere

- Diacriticele românești (ș, ț cu virgulă) în toate greutățile fonturilor alese, pe dispozitive reale.
- Scalarea până la 200% (Dynamic Type / dimensiunea fontului din sistem) fără trunchieri pe cardul de anunț și pe ecranul QR.
- Licențele fonturilor pentru includere în aplicații (cele numite sunt publicate sub licență deschisă; se confirmă la integrare).
- Starea pe 5 niveluri și insignele trebuie să se distingă și fără culoare (formă + text), pentru daltonism.
