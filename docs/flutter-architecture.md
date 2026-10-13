# SwingMate Flutter 아키텍처 규칙

## 디렉터리와 의존성

```text
lib/
├── app/                 # 앱 조립: 라우팅, 테마, 최상위 위젯
├── core/                # 환경 설정, 네트워크 등 기능 공통 기반
└── features/<feature>/
    ├── presentation/
    │   ├── screens/     # 화면
    │   ├── widgets/     # 기능 내부에서 재사용하는 UI
    │   ├── helpers/     # 표시용 포맷터와 UI 보조 함수
    │   ├── states/      # 화면 상태 모델, 필요할 때 추가
    │   └── viewmodels/  # 화면 로직, 필요할 때 추가
    ├── domain/
    │   ├── entities/    # 도메인 모델
    │   ├── repositories/ # Repository 계약
    │   └── usecases/    # 업무 규칙, 필요할 때 추가
    ├── data/
    │   ├── datasources/ # 원격·로컬 데이터 접근
    │   ├── models/      # DTO와 Mapper
    │   └── repositories/ # Repository 구현
    └── di/
        └── providers/   # Riverpod Provider와 구현 조립
```

- `app`은 기능과 공통 기반을 조립하지만 비즈니스 규칙을 갖지 않는다.
- `presentation`은 `domain`에 의존할 수 있고, `data`의 구체 타입에는 직접 의존하지 않는다.
- `data`는 `domain`의 Repository 계약을 구현하고 `core`의 통신 기반을 사용할 수 있다.
- `domain`은 Flutter, Dio, DB 또는 백엔드 SDK에 의존하지 않는다.
- 날짜·상태 등의 도메인 값은 원본 타입으로 유지하고, 화면 표시 문자열은 `presentation`에서 만든다.
- `di`는 `domain` 계약과 `data` 구현을 연결한다. `presentation`은 구체 Repository 구현을 직접 생성하지 않는다.
- `core`에는 여러 기능에서 실제로 공유하는 코드만 둔다. 특정 기능의 업무 규칙은 해당 `features` 아래에 둔다.
- 단순 조회·변환은 Repository와 상태 객체로 충분하면 별도 Use Case를 만들지 않는다.
- DTO·Mapper·RemoteDataSource는 실제 API 계약이 생긴 기능에만 추가한다. 사용처가 없는 계층과 빈 디렉터리를 미리 만들지 않는다.
- Flutter 앱은 DB에 직접 연결하지 않고 Spring API를 통해서만 서버 데이터에 접근한다.

## 환경 설정과 비밀값

단일 진입점에서 컴파일 시점의 `dart-define` 값을 사용한다.

```sh
flutter run \
  --dart-define=APP_ENV=development \
  --dart-define=API_BASE_URL=http://localhost:8080
```

운영 빌드는 `APP_ENV=production`과 운영 API 주소를 배포 파이프라인에서 주입한다. `dart-define` 값은 앱 바이너리에서 추출할 수 있으므로 비밀 저장소가 아니다. API 비밀키, DB 접속 정보, 서명키는 앱에 넣거나 저장소에 커밋하지 않는다. 사용자 액세스 토큰은 인증 기능 구현 시 OS 보안 저장소를 사용하는 패키지를 별도로 선정한다.

## 코드 생성

Freezed 또는 JSON DTO가 처음 추가되면 다음 명령을 실행한다.

```sh
dart run build_runner build --delete-conflicting-outputs
```

지속 생성이 필요할 때는 `build` 대신 `watch`를 사용한다. 생성된 `*.freezed.dart`, `*.g.dart`는 소스와 함께 커밋해 CI와 다른 개발 환경에서도 동일한 소스 상태를 공유한다. 생성 파일은 직접 수정하지 않는다. Riverpod 생성기는 첫 기능에서 수동 Provider보다 이점이 확인될 때만 추가한다.

## 패키지 변경 원칙

- `pubspec.yaml`에는 호환 가능한 안정 버전 범위를 기록하고 실제 해석 결과는 `pubspec.lock`에 고정한다.
- 패키지 추가 후 `flutter pub get`, `flutter analyze`, 관련 테스트와 대상 빌드를 확인한다.
- 카메라, 영상, 푸시, 보안 저장소처럼 네이티브 설정이 필요한 패키지는 해당 기능 착수 시 선정한다.
