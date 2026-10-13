# SwingMate 프로젝트 규칙

이 파일의 규칙은 저장소 전체에 적용한다. Flutter 앱 작업은 `app/`에서 수행하며, 상세 아키텍처 기준은 `docs/flutter-architecture.md`를 따른다.

## 기능별 클린 아키텍처

새 기능과 기존 기능은 다음 구조를 기준으로 구성한다.

```text
app/lib/features/<feature>/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
├── di/
│   └── providers/
└── presentation/
    ├── helpers/
    ├── screens/
    ├── states/
    ├── viewmodels/
    └── widgets/
```

- 파일은 계층 바로 아래에 두지 않고 책임에 맞는 복수형 하위 폴더에 둔다.
- 사용되는 파일이 없으면 빈 폴더나 형식적인 계층을 미리 만들지 않는다.
- `domain`은 Flutter, Riverpod, Dio, DB, 플랫폼 SDK와 구체적인 `data` 구현에 의존하지 않는다.
- `data`는 `domain/repositories`의 계약을 구현하며 DTO, 데이터 소스, Mapper와 Repository 구현을 관리한다.
- `presentation`은 `domain`에 의존할 수 있지만 구체적인 `data` 구현을 직접 생성하거나 import하지 않는다.
- `di/providers`에서 Domain 계약과 Data 구현을 연결하고 Riverpod Provider를 조립한다.
- 의존성 방향은 `presentation → domain ← data`를 따른다. `domain`은 가장 안쪽 계층으로 유지하며 `presentation`이나 `data`를 import하지 않는다.
- `presentation`에서 API Client, DataSource, DTO/Model, DB 패키지에 직접 접근하지 않는다. 데이터가 필요하면 Domain Repository 계약을 통해 요청한다.
- `data`에서 화면 상태, Widget, BuildContext, 라우팅 등 Presentation 관심사를 참조하지 않는다.
- 계층 간에 전달하는 값은 각 계층의 책임에 맞는 타입을 사용한다. API DTO/Model을 화면이나 Domain Entity 대신 재사용하지 않는다.
- 날짜, 상태, 횟수 등은 Domain에 원본 타입으로 보관한다. 화면용 문자열과 포맷은 `presentation/helpers`에서 만든다.
- Use Case는 여러 Repository 작업을 조합하거나 업무 규칙을 표현할 때만 추가한다. 단순 Repository 메서드 전달을 위한 Use Case는 만들지 않는다.
- DTO, Mapper, RemoteDataSource는 실제 API 계약이 존재하는 기능에만 추가한다.
- Repository 구현은 네트워크·저장소 오류를 Domain이 이해할 수 있는 결과 또는 예외 계약으로 변환한다. Dio, HTTP 응답 코드, JSON 예외를 Presentation까지 노출하지 않는다.
- 로딩·성공·실패·빈 결과 등 화면 상태는 `presentation/states`에서 관리한다. Domain Entity에 화면 상태나 표시용 문구를 넣지 않는다.
- 기능 내부에서만 사용하는 모델, 위젯, Provider, 헬퍼는 다른 기능이나 `core`로 이동하지 않는다. 여러 기능에서 실제로 공유할 때만 공통 계층으로 승격한다.
- 기능 간 직접 참조가 필요하면 다른 기능의 `data`나 `presentation`이 아니라 공개된 Domain 계약을 우선 사용한다.
- 다른 기능의 `data`와 `presentation`을 직접 import하지 않는다. 기능 간 연동이 필요하면 공개된 Domain 계약이나 별도의 명확한 인터페이스를 사용하며 순환 의존성을 만들지 않는다.

### 네이밍과 책임

- Domain Entity는 일반 명사(`User`)를 사용하고, Repository 계약은 `<Feature>Repository`, 구현체는 `<Feature>RepositoryImpl`로 명명한다.
- API 응답 Model은 `<Feature>Model`, DataSource는 `<Feature>RemoteDataSource` 또는 `<Feature>LocalDataSource`, 변환 책임은 Mapper에 명시한다.
- 화면 상태는 `<Feature>State`, 화면 로직은 `<Feature>ViewModel`, Provider는 역할이 드러나는 이름(`<feature>RepositoryProvider`, `<feature>ViewModelProvider`)을 사용한다.
- `Manager`, `Service`, `Helper`처럼 책임이 모호한 이름은 구체적인 역할을 표현할 수 없을 때만 사용한다.
- 한 파일에 화면, 상태, 데이터 접근, 업무 규칙을 함께 넣지 않는다.

### ViewModel과 State 사용

- 기능 화면의 입력값, 선택값, 로딩·성공·실패·빈 결과, validation 오류처럼 화면을 넘어 유지되거나 여러 위젯이 공유하는 상태는 `presentation/states`의 불변 State 객체로 관리한다.
- 화면별 상태 변경과 사용자 액션 처리는 `presentation/viewmodels`의 ViewModel에서 담당한다. 화면은 입력을 전달하고 State를 구독해 UI를 그리는 역할에 집중한다.
- Flutter 앱의 상태 관리와 Provider 조립에는 Riverpod을 사용한다. ViewModel은 Riverpod의 `Notifier` 또는 비동기 작업에 적합한 `AsyncNotifier`로 구현하고, ViewModel Provider는 기능의 `di/providers`에 두며 화면에서 구체적인 ViewModel을 직접 생성하지 않는다.
- 모든 화면 State는 `freezed`와 `freezed_annotation`을 사용한 불변 객체로 정의한다. `@freezed`, 생성된 `copyWith`, equality를 활용하며 State 클래스를 수동으로 구현하지 않는다.
- Freezed State의 로딩·성공·실패·빈 결과처럼 서로 배타적인 상태는 union/sealed 상태로 표현한다. 상태가 단순한 경우에도 생성자와 필드의 기본값을 명확히 정의한다.
- Freezed 생성 파일(`*.freezed.dart`)은 직접 수정하지 않는다. 원본 State 파일을 수정한 뒤 `build_runner` 생성 명령으로 갱신한다.
- State에 노출하는 `List`와 `Set`은 화면에서 직접 변경하지 않는다. ViewModel에서 새 컬렉션을 만들어 Freezed State를 갱신한다.
- ViewModel 이름은 `<Feature>ViewModel`, State 이름은 `<Feature>State`로 통일한다. Provider 이름은 `<feature>ViewModelProvider`처럼 역할이 드러나야 한다.
- ViewModel은 `BuildContext`, Widget, Navigator, GoRouter, 화면 전용 문자열 표시, `ScaffoldMessenger`에 의존하지 않는다. 화면 이동이나 SnackBar·Dialog 표시가 필요하면 ViewModel의 상태 또는 명시적인 UI 이벤트를 화면이 구독해 처리한다.
- ViewModel에는 입력값 정규화, validation, 업무 규칙 조합, Repository·Use Case 호출, 로딩·오류 상태 변경을 둔다. 단순한 포커스 이동, 키보드 닫기, 애니메이션 제어, `TextEditingController`와 `FocusNode` 생명주기는 화면에 둘 수 있다.
- 화면에만 의미가 있는 일시적인 UI 상태(탭 인덱스, 애니메이션 진행, 포커스 여부, 임시 입력 컨트롤러)는 ViewModel로 옮기지 않는다. 여러 화면에서 공유되거나 업무 흐름에 영향을 주는 값은 ViewModel State로 승격한다.
- 입력 validation은 화면에서 정규식을 임의로 반복하지 않고 ViewModel 또는 Domain의 명확한 정책으로 한 곳에서 수행한다. 화면은 validation 결과를 사용자에게 보여주는 책임만 갖는다.
- 비동기 작업은 `isLoading`·`hasError` 같은 Boolean을 무분별하게 조합하지 않는다. 서로 배타적인 로딩·성공·실패·빈 결과는 `AsyncValue` 또는 명시적인 상태 모델로 표현한다.
- 여러 화면이 이어지는 온보딩·회원가입 흐름은 기능 범위의 Provider State를 공유해 화면 이동에도 입력값을 유지한다. `autoDispose`는 화면을 벗어날 때 상태를 폐기해야 하는 근거가 있을 때만 사용한다.
- ViewModel은 라우팅을 직접 실행하지 않는다. 성공·실패·다음 단계 같은 결과를 반환하거나 State/UI 이벤트로 발행하고, 라우팅은 화면 또는 앱 라우터가 담당한다.
- ViewModel State에는 API DTO, `BuildContext`, Widget, 플랫폼 객체, 표시 전용 문구를 넣지 않는다. 서버 응답은 Domain 결과 또는 오류 계약으로 변환한 뒤 State에 반영한다.
- ViewModel은 Repository 계약과 Use Case를 통해 데이터에 접근한다. 화면과 ViewModel에서 Dio Client, DataSource, DB, API Model을 직접 참조하지 않는다.

### 상태와 오류 처리

- 로딩·성공·실패·빈 결과 등 비동기 화면 상태는 `presentation/states`와 ViewModel에서 일관되게 관리한다.
- `isLoading`, `hasError`, `isEmpty` 같은 Boolean을 무분별하게 조합하지 않는다. 서로 배타적인 상태는 하나의 상태 모델로 표현한다.
- Domain Entity에는 로딩 상태, 화면 선택 상태, 표시용 문구를 넣지 않는다.
- DataSource의 Dio, HTTP 상태 코드, JSON 예외는 Repository 경계에서 Domain이 이해할 수 있는 오류 또는 결과로 변환한다.
- Presentation은 Dio나 HTTP 구현 타입을 직접 처리하지 않으며, 사용자에게 보여줄 오류 문구는 Presentation에서 결정한다.
- 네트워크 오류, 인증 오류, 권한 오류, 잘못된 요청을 구분하고 모든 오류를 무조건 재시도하지 않는다.

### 라우팅과 기능 경계

- 앱 전체 라우트와 라우트 이름은 `app/`에서 관리한다. Domain과 Data는 라우팅을 호출하거나 `BuildContext`를 참조하지 않는다.
- ViewModel은 화면 이동을 직접 수행하지 않는다. 필요한 경우 상태나 이벤트를 발행하고 화면 또는 라우터가 반응한다.
- 특정 기능의 내부 화면, Widget, Data 구현을 다른 기능에서 재사용하지 않는다. 재사용이 필요하면 공개 계약 또는 명시적인 공통 컴포넌트로 설계한다.
- 기능별 Provider는 해당 기능의 `di/providers`에서 조립하며, 구체적인 Repository 구현을 화면에서 직접 생성하지 않는다.

### 보안과 네트워크 데이터

- 액세스 토큰, Refresh Token, 비밀번호, API 비밀키와 개인정보를 로그에 남기지 않는다.
- `Authorization` 헤더와 민감한 요청·응답 값은 로그에서 마스킹한다.
- `dart-define`은 환경 설정 주입 수단일 뿐 비밀 저장소로 사용하지 않는다.
- 사용자 토큰은 인증 기능 구현 시 OS 보안 저장소를 사용하며, 로그아웃 시 관련 인증 캐시를 정리한다.
- 캐시·재시도·페이지네이션은 화면마다 임의로 구현하지 않고 Repository 또는 전용 정책으로 관리한다. 재시도 가능한 오류와 재시도하면 안 되는 오류를 구분한다.

### 테스트와 계층 경계

- Domain Entity와 업무 규칙은 Flutter 의존성 없이 단위 테스트할 수 있어야 한다.
- Repository와 Use Case 테스트에서는 실제 API나 DB 대신 Repository 계약의 Fake/Mock을 사용한다.
- DataSource·Mapper 테스트는 실제 API 응답 형식과 변환 규칙을 검증하고, Widget 테스트는 사용자에게 보이는 상태와 상호작용을 검증한다.
- 새 파일을 추가할 때 어느 계층의 책임인지 먼저 판단하고, 한 파일에 화면·상태·데이터 접근·업무 규칙을 함께 넣지 않는다.
- 업무 규칙을 추가하면 Domain 테스트를 추가하고, API Model이나 Mapper를 추가하면 성공·null·빈 응답을 포함한 변환 테스트를 추가한다.
- ViewModel 상태 변경은 최소한 로딩·성공·실패 흐름을 검증한다. 단순한 정적 Widget에는 필요 이상의 테스트를 만들지 않는다.
- Repository 테스트에서는 실제 네트워크와 DB에 의존하지 않으며, 통합 테스트가 필요한 경우에도 테스트 대상과 실행 조건을 명시한다.

## 앱 공통 계층

- `app/lib/app/`은 라우팅, 테마, 최상위 앱 조립을 담당하고 비즈니스 규칙을 갖지 않는다.
- `app/lib/core/`에는 여러 기능에서 실제로 공유하는 설정, 네트워크 기반, 공통 자산만 둔다.
- 특정 기능에서만 사용하는 코드는 `core`가 아니라 해당 `features/<feature>` 내부에 둔다.
- Flutter 앱은 DB에 직접 접근하지 않고 Spring API를 통해 서버 데이터에 접근한다.

## 변경 및 검증

- 새 화면이나 위젯을 만들기 전에 관련 기능의 기존 `presentation/widgets`, 공통 테마, 자산과 유사 화면을 먼저 확인한다.
- 화면 안에서 반복되는 UI는 기능 내부의 재사용 위젯으로 추출한다. 서로 다른 의미를 가진 위젯을 외형만 비슷하다는 이유로 공용화하지 않는다.
- 기존 위젯·테마의 개선, 공통 컴포넌트 추출, 중복 제거가 필요해 보이면 구현 전에 사용자에게 판단과 영향을 알린다. 사용자 승인 없이 관련 없는 기존 구조를 리팩터링하지 않는다.
- 파일을 이동하면 모든 import와 관련 문서를 함께 갱신한다.
- 화면에 색상 리터럴을 직접 추가하지 않고 `app/lib/app/theme/`의 테마 토큰을 사용한다.
- 패키지 추가 후 의존성 잠금 파일을 유지하고 정적 분석과 관련 테스트를 실행한다.
- `*.g.dart`, `*.freezed.dart` 등 생성 파일은 직접 수정하지 않고 원본을 수정한 뒤 생성 명령으로 갱신한다.
- Flutter 코드 변경 후 가능한 범위에서 `flutter analyze`와 관련 `flutter test`를 통과시킨다.
- 기존 사용자 변경과 관련 없는 파일은 수정하지 않는다.
