# SwingMate mobile app

Flutter 앱은 `app/`에 있습니다. 제품 범위와 단계별 진행 상태는 상위 `docs/` 문서를 참조하세요.

## 개발 환경

- Flutter 3.47.5 stable / Dart 3.13.4
- Android applicationId: `com.forgenovastudio.swingmate`
- iOS bundle identifier: `com.forgenovastudio.swingmate`

이 작업 환경의 Flutter SDK는 저장소 루트의 `.toolchains/flutter/`에 설치되어 있습니다. 이 디렉터리는 버전 관리에서 제외됩니다. 다른 환경에서는 [Flutter 공식 설치 안내](https://docs.flutter.dev/install/manual)에 따라 동일한 stable SDK를 설치하세요.

## 실행

Flutter가 `PATH`에 등록돼 있다면 `app/`에서 실행합니다.

```sh
flutter pub get
flutter doctor
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=http://localhost:8080
```

기본값도 개발 환경과 `http://localhost:8080`이므로 인자 없이 실행할 수 있습니다. Android 에뮬레이터에서 로컬 서버에 연결할 때는 API 주소를 `http://10.0.2.2:8080`으로 지정하세요. 운영 환경과 비밀값 규칙은 [Flutter 아키텍처 문서](../docs/flutter-architecture.md)를 참조하세요.

현재 첫 화면은 Figma 디자인을 적용한 로그인 화면입니다. 소셜 로그인 동작과 로고는 후속 단계에서 연결하며, 로고 영역은 크기와 위치만 유지하는 placeholder로 구성되어 있습니다.

현재는 소셜 로그인 버튼을 누르면 신규 회원의 역할 선택 화면으로 이동합니다. 실제 인증과 회원·프로별 가입 화면은 후속 단계에서 연결합니다.

로그인 이후 연결될 `PRO-01` 프로 홈 데이터는 `HomeRepository` 계약 뒤의 Fake Repository에서 공급하므로 Spring API가 준비되면 HTTP 구현으로 교체할 수 있습니다. 아직 구현하지 않은 상세 화면과 하단 메뉴는 안내 메시지만 표시합니다.
