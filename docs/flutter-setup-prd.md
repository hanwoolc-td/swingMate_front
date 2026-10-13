# SwingMate Flutter 초기 세팅 PRD

| 항목 | 내용 |
| --- | --- |
| 버전 | v0.6 — 4단계 완료, 5단계 승인 대기 |
| 작성일 | 2026-09-30 |
| 기준 문서 | [기능 명세서](functional-specification.md) v0.6 |
| 대상 | Android·iOS Flutter 앱 |
| 현재 상태 | Flutter 앱과 Android·iOS 실행 환경, 공통 구조·패키지 구성 완료. Spring API와 DB는 미구현, Git 저장소는 미초기화 |

## 1. 목적

SwingMate의 프로·회원용 모바일 앱을 개발할 수 있는 Flutter 기반을 마련한다. 이번 작업은 앱 실행, 기능별 코드 구조, 상태관리·이동·모델 규칙, 가짜 데이터 연결까지 포함한다. 제품 기능 전체 구현과 Spring API 연동은 후속 작업으로 진행한다.

## 2. 확정된 방향

- 프론트엔드: Flutter/Dart, Android·iOS 단일 코드베이스
- 백엔드: Java Spring Boot 예정. 실제 API 계약은 백엔드 설계와 함께 확정
- 데이터베이스: 미정. Flutter 앱은 DB에 직접 접근하지 않음
- 구조: 기능별 디렉터리와 `presentation`·`domain`·`data` 책임 분리. 단순 기능에는 불필요한 Use Case를 만들지 않음
- 상태 및 의존성: Riverpod
- 화면 이동: GoRouter
- HTTP: Dio. 실제 Spring 서버가 생기기 전에는 Fake Repository 사용
- 모델: 불변 도메인 모델과 API DTO 분리. 복잡한 모델에는 Freezed, JSON DTO에는 json_serializable 사용
- 제품 범위: 골프 프로의 회원·레슨권·예약·일지·영상·Q&A 관리와 회원의 예약·복습. AI 스윙 분석은 현재 MVP 범위에 없음

## 3. 초기 의존성 원칙

직전 논의에서 정한 안정 버전을 출발 후보로 사용한다. 실제 설치 단계에서는 프로젝트에 설치한 Flutter/Dart SDK와 pub.dev의 안정 버전·의존성 호환성을 확인한 뒤 `pubspec.yaml` 및 `pubspec.lock`에 확정한다. 프리릴리스는 사용하지 않는다.

| 용도 | 패키지 | 직전 논의의 후보 버전 |
| --- | --- | --- |
| 상태관리 | `flutter_riverpod` | 3.4.3 |
| 라우팅 | `go_router` | 18.0.2 |
| HTTP | `dio` | 5.11.1 |
| 불변 모델 | `freezed_annotation`, `freezed` | 3.1.0, 4.0.2 |
| JSON DTO | `json_annotation`, `json_serializable` | 4.12.0, 6.14.1 |
| 코드 생성 | `build_runner` | 2.16.1 |
| 정적 검사 | `flutter_lints` | 6.0.0 |
| 선택적 코드 생성 | `riverpod_annotation`, `riverpod_generator` | 4.0.7, 4.0.9 |

Riverpod 코드 생성은 첫 기능에서 실제 이점이 확인될 때 도입한다. 백엔드 SDK, 푸시, 카메라·영상 패키지는 해당 기능 착수 시 결정한다.

## 4. 작업 단계와 완료 기준

각 단계는 하나의 승인 단위다. 완료 후 아래 항목을 직접 확인하고 이 문서의 체크박스·상태를 갱신한다. 확인 결과와 변경 파일을 보고한 다음, 사용자가 수락하면 다음 단계로 넘어간다. 문제가 남으면 해당 단계를 수정·재확인한다.

### 1단계 — 개발 환경 및 프로젝트 위치 결정 (완료: 2026-09-30)

- [x] Flutter/Dart, Xcode, Android 개발 도구의 설치·버전 상태 확인
- [x] 기존 명세·이미지 파일을 보존할 앱 디렉터리 위치 결정: `app/`
- [x] Android applicationId와 iOS bundle identifier, 앱 표시 이름의 확정 필요 여부 확인
- [x] 설치 가능한 최신 안정 Flutter SDK와 패키지의 최소 SDK 요구사항 확인
- [x] 환경에서 막히는 항목과 해결 방법 기록

완료 기준: 앱 생성 위치와 식별자 방침이 정해지고, 실행 가능한 SDK 상태 또는 구체적인 환경 차단 사유가 확인된다.

확인 결과:

| 항목 | 상태 |
| --- | --- |
| CPU | Apple Silicon ARM64 |
| Flutter/Dart | 실행 파일을 찾지 못함. [공식 릴리스 목록](https://storage.googleapis.com/flutter_infra_release/releases/releases_macos.json)에서 ARM64용 Flutter 3.47.5 / Dart 3.13.4가 현재 안정 버전임을 확인; 설치 필요 |
| Xcode | 27.0 설치, 명령줄 도구 경로 설정됨 |
| iOS Simulator | 사용 가능한 기기 0개. [iOS 개발 설정](https://docs.flutter.dev/platform-integration/ios/setup)에 따라 런타임·기기 설치 필요 |
| Android | Android Studio, Android SDK, `adb`, `sdkmanager`, Java 런타임을 찾지 못함. [Android 개발 설정](https://docs.flutter.dev/platform-integration/android/setup) 필요 |
| 저장소 | 현재 디렉터리는 Git 저장소가 아님. Git 초기화 여부는 별도 결정 사항 |

위치·식별자 방침: 현재 문서와 디자인 참고 파일은 저장소 루트에 두고 Flutter 앱은 `app/`에 생성한다. 앱 표시 이름은 `SwingMate`를 기본안으로 둔다. Android applicationId와 iOS bundle identifier는 모두 `com.forgenovastudio.swingmate`를 제안한다. 이 값은 배포 조직의 소유 도메인·계정과 맞춰 2단계 앱 생성 전에 사용자 확인을 받는다.

패키지 확인: 현재 [Flutter 공식 문서](https://docs.flutter.dev/release/release-notes)는 3.47 계열을 안정 릴리스로 안내한다. `flutter_riverpod 3.4.3`, `go_router 18.0.2`, Riverpod 코드 생성 최신 계열은 Dart 3.12 이상을 요구한다. 실제 의존성 전체 해석은 Flutter 설치 후 3단계에서 확인한다. [`json_serializable`의 최신 안정 버전](https://pub.dev/packages/json_serializable/versions)은 6.14.1로 확인해 표를 수정했다.

### 2단계 — Flutter 앱 생성 및 기본 실행 (완료: 2026-09-30)

- [x] Flutter SDK 설치 및 `flutter doctor`로 환경 상태 확인
- [x] iOS Simulator 런타임·기기와 Android SDK/에뮬레이터 개발 도구 준비
- [x] Android·iOS 대상 Flutter 프로젝트 생성
- [x] 앱 이름·기본 테마·개발용 시작 화면 설정
- [x] 생성된 샘플 코드와 불필요한 기본 템플릿 정리
- [x] `flutter analyze` 및 가능한 대상 기기/시뮬레이터 실행 확인

완료 기준: 앱이 한 대상에서 실행되고, 정적 분석 오류가 없다. 실행 가능한 기기가 없으면 빌드 또는 도구 확인 결과와 제한 사항을 명시한다.

완료 메모 (2026-09-30): Flutter 3.47.5 / Dart 3.13.4를 `.toolchains/flutter/`에 설치했고 공식 SHA-256과 일치함을 확인했다. `app/`를 `com.forgenovastudio.swingmate`로 생성했다. iOS 27.0의 iPhone 17과 Android 36의 Pixel 8 ARM64 에뮬레이터에서 각각 앱 빌드·설치·실행·화면 표시를 확인했다. `flutter analyze` 결과는 오류 0건이다. Android의 첫 Gradle 빌드에서 SDK 도구 버전 경고와 Java 네이티브 접근 경고가 출력됐으나 APK 생성과 실행은 성공했다.

### 3단계 — 앱 구조와 공통 패키지 (완료: 2026-09-30)

- [x] Flutter 프로젝트의 `lib/app/`, `lib/core/`, `lib/features/` 구조와 계층 의존성 규칙 적용
- [x] Riverpod 최상위 설정, GoRouter 경로, 앱 테마 구성
- [x] 필요한 안정 패키지 설치 후 `pubspec.lock` 고정
- [x] 개발·운영 환경 설정 방식과 비밀값 관리 규칙 마련
- [x] 코드 생성이 필요한 경우 생성 명령과 산출물 관리 규칙 문서화

완료 기준: 앱 시작·화면 이동·상태 주입이 동작하고, 패키지 해석 및 정적 분석이 통과한다.

완료 메모 (2026-09-30): `app`, `core`, 기능별 `features` 구조를 만들고 [아키텍처 규칙](flutter-architecture.md)에 의존 방향을 기록했다. 최상위 `ProviderScope`, Riverpod으로 관리하는 GoRouter·환경 설정·Dio, Material 3 테마를 구성했다. 홈에서 설정 화면으로 이동해 주입된 실행 환경과 API 주소를 확인할 수 있다. `dart-define` 기반 개발·운영 설정과 클라이언트에 비밀값을 저장하지 않는 규칙, Freezed/JSON 코드 생성 명령 및 산출물 커밋 규칙을 문서화했다.

직접 의존성은 잠금 파일 기준 `flutter_riverpod 3.4.3`, `go_router 18.0.2`, `dio 5.11.1`, `freezed_annotation 3.1.0`, `json_annotation 4.12.0`, `build_runner 2.16.1`, `freezed 4.0.2`, `json_serializable 6.14.1`, `flutter_lints 6.0.0`으로 확정했다. `flutter analyze`는 문제 0건, 라우팅·환경 주입 위젯 테스트는 통과했으며 Android debug APK와 iOS Simulator 앱 빌드도 성공했다. Android 빌드의 Java 네이티브 접근 경고는 2단계와 동일하며 빌드 결과에는 영향을 주지 않았다.

### 4단계 — 첫 제품 흐름의 가짜 데이터 연결 (완료: 2026-09-30)

- [x] 제공된 Figma 디자인에 맞춰 기능 명세의 `PRO-01` 프로 홈을 첫 흐름으로 선정
- [x] 화면에 필요한 최소 도메인 모델과 Repository 계약 정의
- [x] Fake Repository와 Riverpod 상태를 연결
- [x] 로딩·빈 화면·오류·정상 상태 표시
- [x] 선택한 흐름의 화면과 데이터 경계 확인

완료 기준: 실제 서버 없이 앱에서 첫 화면 흐름을 사용할 수 있고, 화면이 특정 DB나 API 구현 타입에 의존하지 않는다.

완료 메모 (2026-10-01): 사용자 제공 [Figma 프로 홈 디자인](https://www.figma.com/design/VUp39GywwB6AkyXy8CidQZ/%EA%B3%A8%ED%94%84%EC%95%B1?node-id=247-11238&m=dev)을 기준으로 다가오는 레슨, 레슨 예약, 레슨권 요약, 레슨권 추가, 최근 레슨 기록, 하단 내비게이션을 컴팩트한 섹션 카드로 구현했다. Figma의 골프장 이미지·SVG 아이콘과 Inter·Caveat 글꼴을 로컬 에셋으로 포함하고 `flutter_svg 2.3.0`을 잠금 파일에 고정했다. `HomeDashboard`, `UpcomingLesson`, `LessonPass`, `LessonRecord` 도메인 모델과 `HomeRepository` 계약을 만들고 `FakeHomeRepository`를 Riverpod `FutureProvider`에 연결했다. 정상·로딩·빈 화면·오류 상태는 Repository 경계를 통해 표현되며 DB나 Dio 구현 타입에 의존하지 않는다.

검증 결과 `flutter analyze` 문제 0건, 정상·빈 화면·오류 상태 위젯 테스트 3건 통과, iPhone 18 Pro 시뮬레이터 빌드·실행 및 전체 스크롤 영역 시각 확인, Android debug APK와 iOS Simulator 앱 빌드에 성공했다. Figma 원본과 비교해 이미지 확대 크롭, 393px 기준 콘텐츠 폭, 둥근 섹션 카드, 레슨권 진행률, 고정 하단 내비게이션을 확인했다. 아직 구현하지 않은 화면으로 이동하는 버튼은 다음 기능 연결 전까지 안내 메시지를 표시한다.

### 5단계 — Spring 연동 준비 문서

- [ ] 첫 흐름에서 필요한 엔드포인트·요청·응답 DTO 초안 작성
- [ ] 인증, 프로·회원 역할, 프로별 데이터 분리 요구사항 정리
- [ ] 페이지네이션·날짜/시간·오류 형식의 협의 항목 정리
- [ ] Fake Repository를 HTTP 구현으로 교체할 경계 확인

완료 기준: Spring 구현 담당자가 첫 API를 설계할 수 있는 초안이 있고, 미결정 사항이 명시돼 있다.

## 5. 범위 밖

이번 초기 세팅에서는 DB 선택·스키마 확정, Spring 서버 구현, 실제 로그인·예약 거래, 카메라 순환 촬영, 영상 업로드, 푸시 알림을 수행하지 않는다. 특히 예약 확정과 레슨권 차감은 서버의 원자적 처리와 권한 검증이 필요하다.

## 6. 진행 및 보고 규칙

1. 현재 단계의 체크리스트를 수행한다.
2. 결과를 확인하고 이 문서에서 완료한 항목만 `[x]`로 바꾼다.
3. 사용자에게 변경 내용, 확인 결과, 남은 문제, 다음 단계의 범위를 보고한다.
4. 사용자가 해당 단계 결과와 다음 단계 진행을 수락한 뒤 다음 단계에 착수한다.

현재 승인 대기 항목: **4단계 결과 수락 및 5단계 착수**.
