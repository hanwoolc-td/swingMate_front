import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:swingmate/app/router/app_routes.dart';
import 'package:swingmate/app/theme/app_colors.dart';
import 'package:swingmate/core/theme/app_assets.dart';
import 'package:swingmate/features/home/presentation/widgets/home_bottom_navigation.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.inputBackground,
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 393),
            child: Column(
              children: [
                const _MoreHeader(),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 48),
                    children: [
                      _MoreSection(
                        title: '프로필',
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 353),
                          child: const _ProfileCard(),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _MoreSection(
                        title: '연결 관리',
                        child: _MenuGroup(
                          items: [
                            _MoreMenuItem(
                              label: '프로 코드 입력',
                              icon: AppAssets.moreProQr,
                              onTap: () => context.pushNamed(
                                AppRoutes.proCodeConnectionName,
                              ),
                            ),
                            _MoreMenuItem(
                              label: '연결된 프로 관리',
                              icon: AppAssets.moreProPerson,
                              onTap: () => _showComingSoon(context, '연결된 프로 관리'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _MoreSection(
                        title: '설정',
                        child: _MenuGroup(
                          items: [
                            _MoreMenuItem(
                              label: '알림 설정',
                              icon: AppAssets.moreNotificationAudio,
                              onTap: () => _showComingSoon(context, '알림 설정'),
                            ),
                            _MoreMenuItem(
                              label: '계정 및 보안',
                              icon: AppAssets.moreAccountSecurity,
                              onTap: () => context.pushNamed(
                                AppRoutes.accountSecurityName,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      _MoreSection(
                        title: '고객 지원',
                        child: _MenuGroup(
                          items: [
                            _MoreMenuItem(
                              label: '공지사항',
                              icon: AppAssets.moreArticle,
                              onTap: () => _showComingSoon(context, '공지사항'),
                            ),
                            _MoreMenuItem(
                              label: '자주 묻는 질문',
                              icon: AppAssets.moreHelp,
                              onTap: () => _showComingSoon(context, '자주 묻는 질문'),
                            ),
                            _MoreMenuItem(
                              label: '1:1 문의',
                              icon: AppAssets.moreSupportAgent,
                              onTap: () => _showComingSoon(context, '1:1 문의'),
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
      bottomNavigationBar: const HomeBottomNavigation(selectedIndex: 3),
    );
  }
}

class _MoreHeader extends StatelessWidget {
  const _MoreHeader();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 56,
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'SwingMate',
            style: TextStyle(
              color: AppColors.ink,
              fontFamily: 'Caveat',
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _MoreSection extends StatelessWidget {
  const _MoreSection({required this.title, required this.child});

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
              height: 20 / 16,
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

class _ProfileCard extends StatelessWidget {
  const _ProfileCard();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () => _showComingSoon(context, '프로필'),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              ClipOval(
                child: Image.asset(
                  AppAssets.moreProfileSample,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  '김도현',
                  style: TextStyle(
                    color: AppColors.ink,
                    fontSize: 16,
                    height: 18 / 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SvgPicture.asset(AppAssets.moreProfileChevron),
            ],
          ),
        ),
      ),
    );
  }
}

class _MoreMenuItem {
  const _MoreMenuItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final String icon;
  final VoidCallback onTap;
}

class _MenuGroup extends StatelessWidget {
  const _MenuGroup({required this.items});

  final List<_MoreMenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          for (var index = 0; index < items.length; index++) ...[
            _MenuRow(item: items[index]),
            if (index < items.length - 1)
              const Divider(height: 1, thickness: 1, color: AppColors.border),
          ],
        ],
      ),
    );
  }
}

class _MenuRow extends StatelessWidget {
  const _MenuRow({required this.item});

  final _MoreMenuItem item;

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
                style: const TextStyle(
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
