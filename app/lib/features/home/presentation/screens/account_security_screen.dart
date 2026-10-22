import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/network/auth_session.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/di/providers/device_session_providers.dart';
import 'package:swingmate/features/auth/di/providers/device_session_repository_provider.dart';

class AccountSecurityScreen extends ConsumerWidget {
  const AccountSecurityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(authSessionProvider);
    final isGoogle = session.socialProvider == 'google';
    final providerName = isGoogle ? 'Google' : '카카오';
    final accountEmail = session.socialAccountEmail ?? '$providerName 계정';

    return Scaffold(
      backgroundColor: AppColors.inputBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                const _AccountSecurityHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _SecuritySection(
                            title: '로그인 정보',
                            child: _LoginInfoCard(
                              providerName: providerName,
                              email: accountEmail,
                              isGoogle: isGoogle,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                            ),
                            child: Text(
                              '로그인 정보는 $providerName 계정에서 관리됩니다.\n'
                              '이메일 및 비밀번호 변경은 $providerName 계정 설정에서 진행해주세요.',
                              style: const TextStyle(
                                color: AppColors.secondaryText,
                                fontSize: 12,
                                height: 20 / 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      _SecuritySection(
                        title: '연결 관리',
                        child: _SecurityMenuGroup(
                          items: [
                            _SecurityMenuItem(
                              label: '로그인된 기기 관리',
                              icon: AppAssets.accountSecurityDevices,
                              onTap: () => context.push(AppRoutes.deviceSessionsPath),
                            ),
                            _SecurityMenuItem(
                              label: '모든 기기에서 로그아웃',
                              icon: AppAssets.accountSecurityLogout,
                              onTap: () => _logoutAllDevices(context, ref),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _SecuritySection(
                        title: '계정 관리',
                        child: Column(
                          children: [
                            _SecurityMenuGroup(
                              items: [
                                _SecurityMenuItem(
                                  label: '로그아웃',
                                  icon: AppAssets.accountSecurityLogout,
                                  onTap: () => _logoutCurrentDevice(context, ref),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            TextButton(
                              onPressed: () => _showComingSoon(context, '계정 탈퇴'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFFF35F5F),
                                minimumSize: const Size(0, 40),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              child: const Text('계정 탈퇴'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> _logoutCurrentDevice(BuildContext context, WidgetRef ref) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('로그아웃할까요?'),
      content: const Text('현재 기기에서 로그아웃됩니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('로그아웃'),
        ),
      ],
    ),
  );
  if (confirmed != true || !context.mounted) return;

  try {
    final repository = ref.read(deviceSessionRepositoryProvider);
    final sessions = await repository.getSessions();
    final currentSessions = sessions
        .where((session) => session.isCurrent)
        .toList(growable: false);
    if (currentSessions.isEmpty) {
      throw StateError('현재 기기의 로그인 세션을 찾을 수 없습니다.');
    }
    await repository.revokeSession(currentSessions.first.id);
    ref.read(authSessionProvider).clear();
    if (context.mounted) context.go(AppRoutes.loginPath);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          const SnackBar(content: Text('로그아웃 처리에 실패했어요. 다시 시도해주세요.')),
        );
    }
  }
}

Future<void> _logoutAllDevices(BuildContext context, WidgetRef ref) async {
  final confirmed = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x29000000),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    clipBehavior: Clip.antiAlias,
    builder: (sheetContext) => const _AllDeviceLogoutBottomSheet(),
  );
  if (confirmed != true || !context.mounted) return;
  try {
    await ref.read(deviceSessionsViewModelProvider.notifier).revokeAll();
    ref.read(authSessionProvider).clear();
    if (context.mounted) context.go(AppRoutes.loginPath);
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('로그아웃 처리에 실패했어요. 다시 시도해주세요.')),
      );
    }
  }
}

class _AllDeviceLogoutBottomSheet extends StatelessWidget {
  const _AllDeviceLogoutBottomSheet();

  static const _warningBackground = Color(0xFFFFF4F4);
  static const _logoutColor = Color(0xFFFA6565);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 487,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.fromBorderSide(BorderSide(color: AppColors.border)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                width: 80,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFE5E6E9),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
              const SizedBox(height: 32),
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  color: _warningBackground,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppAssets.accountSecurityLogout,
                    width: 32,
                    height: 32,
                    colorFilter: const ColorFilter.mode(
                      _logoutColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '모든 기기에서 로그아웃할까요?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  height: 24 / 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                '현재 사용 중인 이 기기를 제외하고\n'
                '내 계정으로 로그인된 모든 기기에서\n'
                '로그아웃합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.secondaryText,
                  fontSize: 16,
                  height: 28 / 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: _warningBackground,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'assets/icons/device_sessions/error.svg',
                      width: 28,
                      height: 28,
                      colorFilter: const ColorFilter.mode(
                        _logoutColor,
                        BlendMode.srcIn,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        '로그아웃 후에는 각 기기에서\n다시 로그인해야 합니다.',
                        style: TextStyle(
                          color: _logoutColor,
                          fontSize: 16,
                          height: 26 / 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 116,
                height: 48,
                child: _BottomSheetActionButton(
                  label: '취소',
                  backgroundColor: const Color(0xFFE2E4E9),
                  foregroundColor: AppColors.ink,
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: _BottomSheetActionButton(
                    label: '로그아웃',
                    backgroundColor: _logoutColor,
                    foregroundColor: const Color(0xFFF0F1F4),
                    fontWeight: FontWeight.w600,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BottomSheetActionButton extends StatelessWidget {
  const _BottomSheetActionButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.onPressed,
    this.fontWeight = FontWeight.w500,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final VoidCallback onPressed;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: foregroundColor,
              fontSize: 16,
              height: 24 / 16,
              fontWeight: fontWeight,
            ),
          ),
        ),
      ),
    );
  }
}

class _AccountSecurityHeader extends StatelessWidget {
  const _AccountSecurityHeader();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Padding(
              padding: const EdgeInsets.only(left: 20),
              child: InkWell(
                onTap: () => context.pop(),
                borderRadius: BorderRadius.circular(20),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Center(
                    child: SvgPicture.asset(AppAssets.accountSecurityBack),
                  ),
                ),
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                '계정 및 보안',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 80),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Text(
            title,
            style: const TextStyle(
              color: AppColors.ink,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

class _LoginInfoCard extends StatelessWidget {
  const _LoginInfoCard({
    required this.providerName,
    required this.email,
    required this.isGoogle,
  });

  final String providerName;
  final String email;
  final bool isGoogle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isGoogle
                  ? AppColors.selectionCardBackground
                  : AppColors.kakao,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: isGoogle
                ? Image.asset(
                    AppAssets.accountSecurityGoogle,
                    width: 32,
                    height: 32,
                  )
                : SvgPicture.asset(AppAssets.accountSecurityKakao),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '$providerName 계정으로 로그인 중',
                  style: const TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    height: 18 / 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityMenuItem {
  const _SecurityMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;
}

class _SecurityMenuGroup extends StatelessWidget {
  const _SecurityMenuGroup({required this.items});

  final List<_SecurityMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: items.length == 1 ? 0 : 8,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(items.length == 1 ? 20 : 24),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _SecurityMenuRow(item: items[index]),
            if (index < items.length - 1)
              const Divider(height: 1, thickness: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

class _SecurityMenuRow extends StatelessWidget {
  const _SecurityMenuRow({required this.item});

  final _SecurityMenuItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: item.onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            SvgPicture.asset(item.icon),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item.label,
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 16,
                  height: 24 / 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SvgPicture.asset(AppAssets.accountSecurityArrow),
          ],
        ),
      ),
    );
  }
}

void _showComingSoon(BuildContext context, String feature) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('$feature 기능은 다음 단계에서 연결합니다.')));
}
