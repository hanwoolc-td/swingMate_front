# SwingMate Theme 구조

이 폴더는 SwingMate 앱의 색상, 텍스트 스타일, Material 3 테마를 관리한다.

현재는 작업이 완료된 홈 화면에서 실제 사용되는 색상과 그 색상에서 파생되는 테마 값만 정의한다. 앞으로 화면이 추가될 때 필요한 토큰을 확인한 뒤 점진적으로 확장한다.

## 파일 관계

```text
app.dart
  └── AppTheme.light
        ├── AppColorSchemes.light
        │     └── AppColors
        ├── AppTextTheme.light
        │     └── AppColors
        └── AppColors
```

핵심 의존성 흐름은 다음과 같다.

```text
AppColors
  ├── AppColorSchemes
  ├── AppTextTheme
  └── AppTheme
        └── app.dart에서 MaterialApp.router에 적용
```

홈 화면은 현재 일부 화면 전용 토큰을 직접 사용한다.

```text
home_screen.dart
  └── AppColors
```

## 파일별 책임

### `app_colors.dart`

앱에서 사용하는 원천 색상 값을 정의한다.

- 페이지 배경
- 카드 표면
- 본문 및 보조 텍스트
- 버튼
- 테두리와 구분선
- 레슨 상태 배지
- 레슨권 아이콘 배경
- 그림자

`AppColors`는 객체를 생성하기 위한 클래스가 아니라 정적 색상 토큰을 담는 네임스페이스다.

```dart
AppColors.action
AppColors.pageBackground
AppColors.secondaryText
```

새 색상을 추가할 때는 현재 화면이나 디자인에서 실제로 필요한 값인지 먼저 확인한다. 사용처가 없는 색상 팔레트를 미리 추가하지 않는다.

### `app_color_schemes.dart`

`AppColors`를 Material 3의 의미 기반 색상 역할에 연결한다.

```dart
AppColorSchemes.light.primary
AppColorSchemes.light.surface
AppColorSchemes.light.onSurface
AppColorSchemes.light.outline
```

Material 위젯이나 공통 컴포넌트에서 역할 중심의 색상이 필요할 때 사용한다. 단순히 특정 색상 값을 가져오기 위한 용도로 무분별하게 확장하지 않는다.

### `app_text_theme.dart`

앱의 텍스트 스타일을 정의한다.

- 제목 크기와 굵기
- 본문 스타일
- 보조 본문 스타일
- 버튼 및 라벨 스타일

색상은 가능한 한 `AppColors`에서 가져오며, 글꼴은 `ThemeData.fontFamily`에 설정된 `Inter`를 기본으로 사용한다.

### `app_theme.dart`

앞의 테마 구성 요소를 조립해 최종 `ThemeData`를 만든다.

현재 다음 공통 스타일을 포함한다.

- `ColorScheme`
- `TextTheme`
- 앱 기본 글꼴
- 페이지 배경
- AppBar
- Card
- FilledButton
- Divider
- InputDecoration

라이트/다크 테마가 추가될 때도 색상 원천과 역할별 스킴, 컴포넌트 설정을 가능한 한 분리해서 관리한다.

### `home_screen.dart`

홈 화면은 현재 `AppColors`를 사용해 화면 전용 색상을 적용한다.

현재 홈 화면에서 사용되는 주요 토큰은 다음과 같다.

- `pageBackground`: 화면 전체 배경
- `surface`: 카드와 하단 네비게이션 배경
- `ink`: 주요 텍스트
- `secondaryText`: 보조 텍스트와 비활성 아이콘
- `action`: 주요 버튼과 선택된 네비게이션
- `border`, `borderSubtle`: 구분선과 카드 테두리
- `lessonStatusBackground`, `lessonStatusForeground`: 레슨 상태 배지
- `lessonPassIconBackground`: 레슨권 아이콘 배경
- `shadow`: 카드 그림자

## 사용 원칙

### 공통 Material 역할에는 `ColorScheme` 사용

컴포넌트의 의미가 명확한 경우에는 `Theme.of(context).colorScheme`를 우선 사용한다.

```dart
final colors = Theme.of(context).colorScheme;

Text(
  '제목',
  style: TextStyle(color: colors.onSurface),
)
```

### 앱 고유 색상에는 `AppColors` 사용

Material `ColorScheme`에 자연스럽게 대응하지 않는 홈 전용 색상은 `AppColors`에 정의한다.

```dart
Container(color: AppColors.lessonStatusBackground)
```

### 화면 파일에 색상 리터럴을 직접 추가하지 않기

다음과 같이 화면 파일에 새로운 색상 값을 직접 작성하지 않는다.

```dart
// 지양
const Color(0xFF202428)
```

대신 `AppColors`에 이름 있는 토큰을 추가하고 사용한다.

```dart
// 권장
AppColors.action
```

### 아직 사용하지 않는 테마를 미리 만들지 않기

현재 다크 테마, 전체 앱 팔레트, 복잡한 `ThemeExtension`은 실제 요구사항이 생겼을 때 추가한다. 테마 파일은 화면 구현과 함께 필요한 만큼만 확장한다.

## 테마 적용 흐름

```dart
MaterialApp.router(
  theme: AppTheme.light,
)
```

앱 시작점에서 `AppTheme.light`를 `MaterialApp.router`에 전달하면, Material 위젯은 `AppColorSchemes`, `AppTextTheme`, 컴포넌트별 테마 설정을 자동으로 사용한다.
