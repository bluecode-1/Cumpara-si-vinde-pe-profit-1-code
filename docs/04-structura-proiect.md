# Pasul 3 — Structura de proiect pe platforme

> Stare: **în așteptarea confirmării**.

## 1. Depozitul (monorepo)

```
.
├── api/
│   ├── openapi.yaml              # contractul unic
│   └── fixtures/                 # răspunsuri JSON de referință, folosite de testele tuturor clienților
├── backend/                      # ASP.NET Core (vezi Pasul 2)
├── android/                      # Java, Gradle
├── flutter/                      # Dart 3
├── ios/                          # Swift, SwiftUI
├── design/
│   └── tokens.json               # culori, tipografie, spațieri → generate în XML, Dart și Swift
├── docs/
└── .github/workflows/            # câte un workflow per platformă, declanșat doar de directorul ei
```

De ce un singur depozit: o schimbare de contract (`openapi.yaml`) și adaptarea celor trei clienți intră în același pull request, iar CI-ul îi verifică împreună.

## 2. Reguli comune celor trei aplicații

Aceleași nume și aceleași granițe peste tot, ca un flux să poată fi citit în paralel pe cele trei platforme.

**Straturi** (în fiecare funcționalitate):

| Strat | Conține | Depinde de |
|---|---|---|
| `ui` | Ecrane, ViewModel / Notifier, stare de ecran imutabilă | `domain` |
| `domain` | Modele, interfețe de repository, cazuri de utilizare; cod pur, fără framework | nimic |
| `data` | DTO-uri, client API, DAO-uri, implementări de repository, mapări | `domain` |

**Funcționalități** (aceleași 11 pe toate platformele):

| Nume | Acoperă | MVP |
|---|---|---|
| `onboarding` | OTP telefon, consimțăminte, locație, interese | ✓ |
| `home` | „Aproape de tine azi”, colecții, potriviri | ✓ |
| `publish` | Fotografiere ghidată, stare, sugestii AI, preț, pașaport, ciorne | ✓ |
| `search` | Filtre, hartă pe rază, căutare vizuală | ✓ |
| `listing` | Detaliu anunț, pașaport, salvare | ✓ |
| `chat` | Conversații, mesaje, mascare, avertismente | ✓ |
| `deals` | Oferte, troc, întâlniri, puncte sigure, locație live | ✓ (ofertă în bani + întâlnire) |
| `checkout` | Plată escrow, QR de predare, livrare, dispută | ✓ |
| `closet` | Dulapul virtual | după MVP |
| `wanted` | Cereri „Caut” | după MVP |
| `profile` | Profil, insigne, impact, setări, verificare, GDPR | ✓ (parțial) |

**Convenții transversale:**

- **Modele scrise de mână, verificate prin contract.** Nu generăm cod din OpenAPI: cerințele impun Freezed în Flutter și zero dependențe inutile pe iOS, iar codul generat pentru Java + Retrofit e greu de citit. În schimb, toate cele trei suite de teste decodează aceleași fișiere din `api/fixtures/`, iar backend-ul validează că fixture-urile respectă `openapi.yaml`. O abatere de contract pică în CI pe toate platformele.
- **Offline, local-first.** Ciornele și anunțurile salvate trăiesc în baza locală; interfața citește doar din ea. Sincronizarea e un proces separat (WorkManager / `workmanager` / `BGTaskScheduler`).
- **Coadă de încărcare.** Pozele se comprimă, li se elimină EXIF/GPS, apoi se trimit pe blocuri de un job de fundal care supraviețuiește închiderii aplicației și reia de la ultimul bloc confirmat.
- **Sesiune.** Tokenuri în Keystore / Keychain; un interceptor unic reîmprospătează tokenul, serializat, la primul 401.
- **Erori.** Un singur tip `AppError` cu `code` din `problem+json`; mesajele pentru utilizator sunt în resursele de text, nu vin de la server.
- **Texte.** Româna e limba de bază, engleza a doua. Niciun text de interfață în cod.
- **Hartă.** MapLibre pe Android și Flutter, MapKit pe iOS. MapLibre ne lasă să stilizăm harta în identitatea proprie și nu leagă aplicația de serviciile Google; sursa de plăci (candidat: Azure Maps) rămâne de ales și verificat ca licență.

## 3. Android — Java, MVVM, XML

Java 17, `minSdk 26`, `targetSdk` curent, Gradle cu *version catalog* și *convention plugins*. Pachet de bază: `ro.profitnet.app`.

```
android/
├── settings.gradle
├── gradle/libs.versions.toml
├── build-logic/                         # convention plugins: android-library, android-feature, hilt, testing
├── app/                                 # ProfitNetApp (@HiltAndroidApp), MainActivity, graf de navigare rădăcină,
│                                        # configurare R8, network_security_config (pinning)
├── core/
│   ├── common/                          # Result, AppError, dispatchers/executori, utilitare
│   ├── model/                           # modele de domeniu partajate: Money, ConditionGrade, ListingSummary…
│   ├── network/                         # Retrofit, OkHttp, AuthInterceptor, TokenAuthenticator,
│   │                                    # CertificatePinner, ProblemJsonConverter, *Api (interfețe Retrofit), DTO-uri
│   ├── database/                        # Room: ProfitNetDatabase, entități, DAO-uri, migrări
│   ├── security/                        # TokenStore pe Keystore + EncryptedSharedPreferences
│   ├── media/                           # ImageCompressor (WebP), ExifStripper, BlockUploader, UploadWorker
│   ├── realtime/                        # ChatHubClient (SignalR), reconectare, evenimente → LiveData
│   ├── location/                        # FusedLocation, rotunjire coordonate, permisiuni
│   ├── notifications/                   # FCM service, canale, rutare deep-link
│   ├── designsystem/                    # temă Material 3, culori/tipografie din tokens.json,
│   │                                    # componente: ConditionScaleView, BadgeChip, PriceView, PassportCard
│   └── testing/                         # fixture loader, reguli JUnit, fake-uri de repository
└── feature/
    ├── onboarding/
    ├── home/
    ├── publish/
    ├── search/
    ├── listing/
    ├── chat/
    ├── deals/
    ├── checkout/
    ├── closet/
    ├── wanted/
    └── profile/
```

Interiorul unui modul de funcționalitate (exemplu `feature/publish`):

```
ro.profitnet.app.feature.publish
├── ui/
│   ├── PublishFlowFragment.java          # gazda fluxului (nav graph imbricat)
│   ├── capture/GuidedCaptureFragment.java, GuidedCaptureViewModel.java, ShotOverlayView.java
│   ├── condition/ConditionFragment.java, ConditionViewModel.java
│   ├── details/DetailsFragment.java, DetailsViewModel.java     # sugestii AI editabile
│   ├── price/PriceFragment.java, PriceViewModel.java           # estimator + reducere automată
│   └── PublishUiState.java
├── domain/
│   ├── DraftRepository.java
│   ├── SaveDraftUseCase.java, PublishListingUseCase.java, DeriveConditionGradeUseCase.java
│   └── model/Draft.java, CapturedShot.java
├── data/
│   ├── DraftRepositoryImpl.java          # Room ca sursă de adevăr + sincronizare
│   ├── DraftSyncWorker.java
│   └── mapper/DraftMapper.java
└── di/PublishModule.java                 # @Module @InstallIn
```

| Preocupare | Alegere |
|---|---|
| DI | Hilt (`annotationProcessor`, fără kapt) |
| Navigare | Navigation Component, un graf per funcționalitate, Safe Args (Java) |
| Stare | `ViewModel` + `LiveData<UiState>`; stare imutabilă, evenimente unice prin `Event<T>` |
| Asincron | Retrofit `Call` / `ListenableFuture` pe executori injectați; fără RxJava în codul propriu |
| Interfață | XML + ViewBinding, Material 3, `RecyclerView` cu `ListAdapter` |
| Cameră / QR | CameraX; ML Kit Barcode Scanning pentru citire, ZXing pentru generare |
| Plăți | Stripe Android SDK (PaymentSheet) |
| Teste | JUnit 4 + Mockito + Robolectric (unitare), Espresso + Hilt testing (UI), MockWebServer cu `api/fixtures` |
| Livrare | Fastlane (`supply`), R8 cu reguli per modul |

Regulă de dependențe: `feature:*` depinde doar de `core:*`, niciodată de alt `feature`. Navigarea între funcționalități trece prin deep-link-uri declarate în `app`.

## 4. Flutter — Dart 3, Riverpod, go_router

Un singur pachet de aplicație, organizat pe funcționalități. Un monorepo de pachete (melos) ar adăuga ceremonie fără beneficiu la dimensiunea asta; granițele sunt impuse prin reguli de import în `analysis_options.yaml`.

```
flutter/
├── pubspec.yaml
├── analysis_options.yaml                # lint strict + reguli de import între straturi
├── l10n/app_ro.arb, app_en.arb
├── lib/
│   ├── main.dart, bootstrap.dart
│   ├── app/
│   │   ├── app.dart                     # MaterialApp.router, temă, localizare
│   │   ├── router.dart                  # go_router: rute, redirecționare după sesiune, deep-link-uri
│   │   └── adaptive/                    # widgeturi care aleg Material sau Cupertino după platformă
│   ├── core/
│   │   ├── error/                       # AppError, mapare problem+json
│   │   ├── network/                     # Dio, AuthInterceptor, pinning, RetryInterceptor
│   │   ├── database/                    # Drift: AppDatabase, tabele, DAO-uri, migrări
│   │   ├── security/                    # TokenStore (flutter_secure_storage)
│   │   ├── media/                       # compresie, eliminare EXIF, BlockUploader, coadă de fundal
│   │   ├── realtime/                    # ChatHubClient (SignalR)
│   │   ├── location/, notifications/
│   │   ├── model/                       # Money, ConditionGrade… (Freezed)
│   │   └── design/                      # ThemeData din tokens.json, componente comune
│   └── features/
│       └── publish/                     # la fel pentru celelalte 10
│           ├── data/                    # publish_api.dart, dto/ (Freezed + json_serializable),
│           │                            # draft_dao.dart, draft_repository_impl.dart
│           ├── domain/                  # draft.dart, draft_repository.dart, derive_condition_grade.dart
│           └── presentation/            # guided_capture_screen.dart, publish_controller.dart (Notifier),
│                                        # publish_state.dart (Freezed), widgets/
├── test/                                # unitare + widget, oglindește lib/
└── integration_test/                    # fluxurile cheie cap-coadă pe un API simulat
```

| Preocupare | Alegere | De ce |
|---|---|---|
| Stare | **Riverpod** (cu `riverpod_generator`) | Injecție și stare într-un singur mecanism, verificat la compilare; mai puțin cod repetitiv decât Bloc pentru 11 funcționalități. |
| Stocare | **Drift** | SQL tipizat, migrări explicite, interogări reactive. L-am preferat lui Isar pentru că întreținerea Isar e incertă, iar modelul relațional oglindește Room și SwiftData. |
| Rețea | Dio | Interceptori pentru token, reîncercare, pinning. |
| Modele | Freezed + json_serializable | Imutabilitate și `copyWith`; uniuni pentru stările de ecran. |
| Adaptare | `app/adaptive/` | Navigare, dialoguri, selectoare și gesturi native pe fiecare platformă, dintr-un singur punct. |
| Cameră / QR | `camera`, `mobile_scanner`, `qr_flutter` | |
| Plăți | `flutter_stripe` | |
| Fundal | `workmanager` | |
| Teste | `flutter_test`, `mocktail`, `integration_test` | |
| Livrare | Fastlane pentru ambele magazine; `--obfuscate --split-debug-info` | |

## 5. iOS — Swift, SwiftUI, iOS 17+

Un target de aplicație subțire plus un pachet Swift local cu câte un target per modul. Granițele sunt verificate de compilator, iar modulele se compilează și se testează independent (`swift test`).

```
ios/
├── ProfitNet.xcodeproj
├── ProfitNet/                           # target aplicație
│   ├── ProfitNetApp.swift               # @main, ModelContainer, AppDependencies
│   ├── RootView.swift                   # TabView + NavigationStack per tab, rutare deep-link
│   ├── Info.plist, ProfitNet.entitlements
│   └── Resources/Localizable.xcstrings  # ro (bază) + en
├── Packages/ProfitNetKit/
│   ├── Package.swift
│   ├── Sources/
│   │   ├── Core/                        # AppError, Money, ConditionGrade, modele partajate
│   │   ├── Networking/                  # APIClient (URLSession, async/await), Endpoint, AuthInterceptor (actor),
│   │   │                                # PinningDelegate, ProblemDecoder
│   │   ├── Persistence/                 # modele SwiftData (@Model), ModelContainer, migrări (VersionedSchema)
│   │   ├── Security/                    # KeychainTokenStore
│   │   ├── Media/                       # ImageCompressor (HEIC), MetadataStripper, BlockUploader
│   │   │                                # pe URLSession de fundal
│   │   ├── Realtime/                    # ChatHubClient: protocolul SignalR JSON peste URLSessionWebSocketTask
│   │   ├── DesignSystem/                # culori și tipografie din tokens.json, ConditionScale, BadgeChip, PassportCard
│   │   ├── OnboardingFeature/
│   │   ├── HomeFeature/
│   │   ├── PublishFeature/              # Views/, PublishViewModel.swift (@Observable), DraftRepository.swift,
│   │   │                                # GuidedCaptureView.swift, CameraSession.swift (AVFoundation)
│   │   ├── SearchFeature/
│   │   ├── ListingFeature/
│   │   ├── ChatFeature/
│   │   ├── DealsFeature/
│   │   ├── CheckoutFeature/
│   │   ├── ClosetFeature/
│   │   ├── WantedFeature/
│   │   └── ProfileFeature/
│   └── Tests/                           # XCTest per modul, cu api/fixtures
├── ProfitNetUITests/                    # XCUITest pe fluxurile cheie
└── fastlane/
```

| Preocupare | Alegere |
|---|---|
| Stare | ViewModel-uri `@Observable` pe `@MainActor`; stare de ecran ca `struct` |
| Navigare | `NavigationStack` cu rute tipizate (`enum Route: Hashable`), câte o stivă per tab |
| DI | Injecție prin inițializator + `Environment`; fără container extern |
| Stocare | SwiftData; repository-urile ascund `ModelContext` în spatele unui `ModelActor` |
| Rețea | `URLSession` + `async/await`; `Codable` scris de mână |
| Timp real | Client SignalR propriu, minimal (handshake, invocări, ping, reconectare) peste `URLSessionWebSocketTask` |
| Cameră / QR | AVFoundation pentru fotografierea ghidată; `DataScannerViewController` (VisionKit) pentru scanare; CoreImage pentru generare |
| Hartă | MapKit pentru SwiftUI |
| Fundal | `BGTaskScheduler` pentru sincronizare, `URLSession` de fundal pentru încărcări |
| Teste | XCTest, `URLProtocol` simulat, XCUITest |

**Singura dependență externă: Stripe iOS SDK.** Datele de card nu pot fi colectate conform PCI fără el. Clientul SignalR îl scriem noi pentru că protocolul JSON e mic și evităm astfel un pachet terț; dacă întreținerea lui devine o povară, pachetul oficial Microsoft pentru Swift îl poate înlocui în spatele aceleiași interfețe `ChatHubClient`.

## 6. CI/CD

| Workflow | Declanșat de | Pași |
|---|---|---|
| `contract.yml` | `api/**` | Validare OpenAPI, validare fixture-uri față de schemă |
| `backend.yml` | `backend/**`, `api/**` | Build, teste unitare și de integrare (Testcontainers), imagine container |
| `android.yml` | `android/**`, `api/**`, `design/**` | Lint, teste unitare, build release cu R8; Espresso pe emulator la pull request-urile către `main` |
| `flutter.yml` | `flutter/**`, `api/**`, `design/**` | `analyze`, `test`, build Android + iOS; `integration_test` pe `main` |
| `ios.yml` | `ios/**`, `api/**`, `design/**` | `swift test` pe pachet, build aplicație, XCUITest pe simulator |
| `release-*.yml` | etichete `v*` | Fastlane: semnare, încărcare în Play (test intern) și TestFlight |

## 7. Limită de verificare în acest mediu

Mediul în care lucrez este un container Linux. Pot compila și testa aici backend-ul, proiectul Flutter (dacă instalez SDK-ul) și, cu Android SDK instalat, modulele Android. **Nu pot compila sau rula proiectul iOS**: Xcode există doar pe macOS. La Pasul 4 codul Swift va fi scris cu grijă și acoperit de workflow-ul `ios.yml`, dar prima compilare reală va avea loc în CI pe un runner macOS sau pe calculatorul tău.
