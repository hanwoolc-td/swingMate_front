import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/auth/di/providers/device_session_providers.dart';
import 'package:swingmate/features/auth/domain/entities/device_session.dart';

class DeviceSessionsScreen extends ConsumerWidget {
  const DeviceSessionsScreen({super.key});

  static const _assetBase = 'assets/icons/device_sessions';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(deviceSessionsViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBackground,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                SizedBox(
                  height: 56,
                  child: Row(
                    children: [
                      SizedBox(
                        width: 56,
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: IconButton(
                              tooltip: '뒤로가기',
                              onPressed: () => context.pop(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 40,
                                height: 40,
                              ),
                              icon: SvgPicture.asset(
                                AppAssets.chevronLeft,
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            '로그인 기기 관리',
                            style: TextStyle(
                              // Use the platform's Korean-capable system font for Hangul glyphs.
                              inherit: false,
                              color: AppColors.ink,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 56),
                    ],
                  ),
                ),
                Expanded(
                  child: sessions.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => _LoadError(
                      onRetry: () => ref.read(deviceSessionsViewModelProvider.notifier).reload(),
                    ),
                    data: (items) => RefreshIndicator(
                      onRefresh: () => ref.read(deviceSessionsViewModelProvider.notifier).reload(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 48),
                        children: [
                          const Text(
                            '현재 내 계정으로 로그인된 기기 목록입니다.\n사용하지 않는 기기는 로그아웃 할 수 있어요.',
                            style: TextStyle(
                              fontFamily: 'Inter',
                              color: Color(0xFF3F4245),
                              fontSize: 16,
                              height: 1.625,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Text(
                              '연결된 기기',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                color: AppColors.ink,
                                fontSize: 16,
                                height: 1.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (items.isEmpty)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: const Text(
                                '로그인된 기기가 없습니다.',
                                style: TextStyle(fontFamily: 'Inter', color: AppColors.secondaryText, fontSize: 14),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(24),
                              ),
                              child: Column(
                                children: [
                                  for (final session in items)
                                    _DeviceSessionRow(
                                      session: session,
                                      onRevoke: () => _confirmRevoke(context, ref, session),
                                    ),
                                ],
                              ),
                            ),
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE4E5E8),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset('$_assetBase/error.svg', width: 28, height: 28),
                                const SizedBox(width: 10),
                                const Expanded(
                                  child: Text(
                                    '본인이 사용하지 않는 기기가 있다면\n즉시 로그아웃해 주세요.',
                                    style: TextStyle(
                                      fontFamily: 'Inter',
                                      color: Color(0xFF575C63),
                                      fontSize: 13,
                                      height: 21 / 13,
                                      fontWeight: FontWeight.w400,
                                    ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmRevoke(BuildContext context, WidgetRef ref, DeviceSession session) async {
    final shouldRevoke = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('기기에서 로그아웃할까요?'),
        content: Text('${session.deviceName}의 로그인 세션이 종료됩니다.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('취소')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('로그아웃')),
        ],
      ),
    );
    if (shouldRevoke != true || !context.mounted) return;
    try {
      await ref.read(deviceSessionsViewModelProvider.notifier).revoke(session.id);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('기기 로그아웃에 실패했어요.')));
      }
    }
  }
}

class _DeviceSessionRow extends StatelessWidget {
  const _DeviceSessionRow({required this.session, required this.onRevoke});

  final DeviceSession session;
  final VoidCallback onRevoke;

  static const _assetBase = DeviceSessionsScreen._assetBase;

  @override
  Widget build(BuildContext context) {
    final iconPath = _deviceIcon(session);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          SvgPicture.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.deviceName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.ink,
                    fontSize: 16,
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${_platformName(session.platform)} · ${_date(session.lastUsedAt)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: AppColors.secondaryText,
                    fontSize: 12,
                    height: 1,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          if (!session.isCurrent) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRevoke,
              style: TextButton.styleFrom(
                minimumSize: Size.zero,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: AppColors.inputBackground,
                foregroundColor: AppColors.ink,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                textStyle: const TextStyle(fontFamily: 'Inter', fontSize: 12, fontWeight: FontWeight.w500),
              ),
              child: const Text('로그아웃'),
            ),
          ],
        ],
      ),
    );
  }

  static String _deviceIcon(DeviceSession session) {
    final deviceName = session.deviceName.toLowerCase();
    if (deviceName.contains('ipad') || deviceName.contains('tablet')) {
      return '$_assetBase/tablet.svg';
    }
    if (deviceName.contains('mac') || deviceName.contains('laptop') || deviceName.contains('windows') ||
        session.platform.toUpperCase() == 'WEB') {
      return '$_assetBase/laptop.svg';
    }
    return '$_assetBase/mobile.svg';
  }

  static String _platformName(String platform) => switch (platform.toUpperCase()) {
        'IOS' => 'iOS',
        'ANDROID' => 'Android',
        'WEB' => '웹',
        _ => '기기',
      };

  static String _date(DateTime date) {
    final local = date.toLocal();
    return '${local.year}. ${local.month.toString().padLeft(2, '0')}. ${local.day.toString().padLeft(2, '0')}';
  }
}

class _LoadError extends StatelessWidget {
  const _LoadError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('기기 목록을 불러오지 못했어요.'),
            TextButton(onPressed: onRetry, child: const Text('다시 시도')),
          ],
        ),
      );
}
